import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/provider/category_provider.dart';
import 'package:bechdal_app/provider/product_provider.dart';
import 'package:bechdal_app/screens/product_details_screen.dart';
import 'package:bechdal_app/services/auth_service.dart';
import 'package:bechdal_app/services/firebase_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

class ProductListing extends StatefulWidget {
  final bool? isProductByCategory;

  const ProductListing({Key? key, this.isProductByCategory}) : super(key: key);

  @override
  State<ProductListing> createState() => _ProductListingState();
}

class _ProductListingState extends State<ProductListing> {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<ProductProvider>(context);
    var categoryProvider = Provider.of<CategoryProvider>(context);
    final numberFormat = NumberFormat('##,##,##0');
    return FutureBuilder<QuerySnapshot>(
        future: (widget.isProductByCategory == true)
            ? categoryProvider.selectedCategory == 'Cars'
                ? authService.products
                    .orderBy('posted_at')
                    .where('category',
                        isEqualTo: categoryProvider.selectedCategory)
                    .get()
                : authService.products
                    .orderBy('posted_at')
                    .where('category',
                        isEqualTo: categoryProvider.selectedCategory)
                    .where('subcategory',
                        isEqualTo: categoryProvider.selectedSubCategory)
                    .get()
            : authService.products.orderBy('posted_at').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading products..'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: whiteColor,
              ),
            );
          }
          return (snapshot.data!.docs.length == 0)
              ? Container(
                  height: MediaQuery.of(context).size.height - 50,
                  child: Center(
                    child: Text('No Products Found.'),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (widget.isProductByCategory != null)
                          ? const SizedBox()
                          : Column(
                              children: [
                                Text(
                                  'Recommendation',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: blackColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                      GridView.builder(
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 2 / 2,
                            mainAxisExtent: 300,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: snapshot.data!.size,
                          itemBuilder: (BuildContext context, int index) {
                            var data = snapshot.data!.docs[index];
                            var price = int.parse(data['price']);
                            String formattedPrice = numberFormat.format(price);
                            return ProductCard(
                              data: data,
                              formattedPrice: formattedPrice,
                              numberFormat: numberFormat,
                            );
                          }),
                    ],
                  ),
                );
        });
  }
}

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    required this.data,
    required this.formattedPrice,
    required this.numberFormat,
  }) : super(key: key);

  final QueryDocumentSnapshot<Object?> data;
  final String formattedPrice;
  final NumberFormat numberFormat;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  FirebaseUser firebaseUser = FirebaseUser();
  String address = '';
  DocumentSnapshot? sellerDetails;
  @override
  void initState() {
    firebaseUser.getSellerData(widget.data['seller_uid']).then((value) {
      setState(() {
        address = value['address'];

        sellerDetails = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<ProductProvider>(context);
    return InkWell(
      onTap: () {
        productProvider.setSellerDetails(sellerDetails);
        productProvider.setProductDetails(widget.data);
        Navigator.pushNamed(context, ProductDetail.screenId);
      },
      child: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      alignment: Alignment.center,
                      height: 150,
                      child: Image.network(
                        widget.data['images'][0],
                        fit: BoxFit.cover,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '\u{20B9} ${widget.formattedPrice}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.data['title'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  (widget.data['category'] == 'Cars')
                      ? Text(
                          '${widget.data['year']} - ${widget.numberFormat.format(int.parse(widget.data['km_driven']))} Km')
                      : SizedBox(),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_pin,
                        size: 14,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Flexible(
                        child: Text(
                          address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                right: 15,
                bottom: 20,
                child: LikeButton(
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      isLiked
                          ? CupertinoIcons.heart_fill
                          : CupertinoIcons.heart,
                      color: isLiked ? secondaryColor : blackColor,
                      size: 20,
                    );
                  },
                  likeCount: 0,
                  countBuilder: (int? count, bool isLiked, String text) {
                    Widget result;
                    result = Text('');
                    return result;
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
