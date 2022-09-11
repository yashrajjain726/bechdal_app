import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/provider/product_provider.dart';
import 'package:bechdal_app/screens/product/product_details_screen.dart';
import 'package:bechdal_app/services/auth_service.dart';
import 'package:bechdal_app/services/firebase_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  AuthService authService = AuthService();
  FirebaseUser firebaseUser = FirebaseUser();

  String address = '';
  DocumentSnapshot? sellerDetails;
  bool isLiked = false;
  List fav = [];
  @override
  void initState() {
    getSellerData();
    getFavourites();
    super.initState();
  }

  getSellerData() {
    firebaseUser.getSellerData(widget.data['seller_uid']).then((value) {
      if (mounted) {
        setState(() {
          address = value['address'];
          sellerDetails = value;
        });
      }
    });
  }

  getFavourites() {
    authService.products.doc(widget.data.id).get().then((value) {
      if (mounted) {
        setState(() {
          fav = value['favourites'];
        });
      }
      if (fav.contains(firebaseUser.user!.uid)) {
        if (mounted) {
          setState(() {
            isLiked = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLiked = false;
          });
        }
      }
    });
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
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      alignment: Alignment.center,
                      height: 120,
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
                  Text(
                    widget.data['title'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  (widget.data['category'] == 'Cars')
                      ? Text(
                          '${widget.data['year']} - ${widget.numberFormat.format(int.parse(widget.data['km_driven']))} Km')
                      : SizedBox(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
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
                  right: 0,
                  bottom: 0,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          isLiked = !isLiked;
                        });
                        firebaseUser.updateFavourite(
                          context: context,
                          isLiked: isLiked,
                          productId: widget.data.id,
                        );
                      },
                      color: isLiked ? secondaryColor : disabledColor,
                      icon: Icon(
                        isLiked
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart,
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
