import 'package:bechdal_app/components/product_listing_widget.dart';
import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/constants/functions/functions.validation.dart';
import 'package:bechdal_app/provider/product_provider.dart';
import 'package:bechdal_app/screens/product_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';

class SearchService {
  searchQueryPage(
      {required BuildContext context,
      required List<Products> products,
      required String address,
      DocumentSnapshot? sellerDetails,
      required ProductProvider provider}) {
    showSearch(
      context: context,
      delegate: SearchPage<Products>(
          barTheme: ThemeData(
              appBarTheme: AppBarTheme(
                  backgroundColor: whiteColor,
                  elevation: 0,
                  surfaceTintColor: primaryColor,
                  iconTheme: IconThemeData(color: blackColor),
                  actionsIconTheme: IconThemeData(color: blackColor))),
          onQueryUpdate: (s) => print(s),
          items: products,
          searchLabel: 'Search cars, mobiles, properties...',
          suggestion: const SingleChildScrollView(child: ProductListing()),
          failure: const Center(
            child: Text('No product found, Please check and try again..'),
          ),
          filter: (product) => [
                product.title,
                product.description,
                product.category,
                product.subcategory,
              ],
          builder: (product) {
            return InkWell(
                onTap: () {
                  provider.setProductDetails(product.document);
                  provider.setSellerDetails(sellerDetails);
                  Navigator.pushNamed(context, ProductDetail.screenId);
                },
                child: SearchCardWidget(
                  product: product,
                  address: address,
                ));
          }),
    );
  }
}

class SearchCardWidget extends StatelessWidget {
  final String address;
  final Products product;
  const SearchCardWidget({
    required this.address,
    required this.product,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      margin: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Container(
                width: 120,
                height: 120,
                child: Image.network(product.document!['images'][0]),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.title ?? '',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '\u{20b9} ${product.price != null ? intToStringFormatter(product.price) : ''}',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      product.description ?? '',
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.postDate != null
                            ? 'Posted At: ${formattedTime(product.postDate)}'
                            : ''),
                        Row(
                          children: [
                            Icon(
                              Icons.location_pin,
                              size: 15,
                            ),
                            Text(
                              address,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Products {
  String? title;
  String? description;
  String? category;
  String? subcategory;
  String? price;
  num? postDate;
  DocumentSnapshot? document;
  Products(
      {this.title,
      this.description,
      this.category,
      this.subcategory,
      this.price,
      this.postDate,
      this.document});
}
