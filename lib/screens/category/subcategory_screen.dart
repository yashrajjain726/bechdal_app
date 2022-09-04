import 'package:bechdal_app/components/common_page_widget.dart';
import 'package:bechdal_app/forms/common_form.dart';
import 'package:bechdal_app/provider/category_provider.dart';
import 'package:bechdal_app/screens/category/product_by_category_screen.dart';
import 'package:bechdal_app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.constants.dart';

class SubCategoryScreen extends StatefulWidget {
  static const String screenId = 'subcategory_screen';
  const SubCategoryScreen({Key? key}) : super(key: key);

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    var categoryProvider = Provider.of<CategoryProvider>(context);
    final DocumentSnapshot? args = ModalRoute.of(context)!.settings.arguments
        as DocumentSnapshot<Object?>?;
    return CommonPageWidget(
        text: args!['category_name'],
        body: subCategoryBodyWidget(args, categoryProvider),
        containsAppbar: true,
        centerTitle: false);
  }

  subCategoryBodyWidget(args, CategoryProvider categoryProvider) {
    AuthService authService = AuthService();
    return FutureBuilder<DocumentSnapshot>(
        future: authService.categories.doc(args.id).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container();
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: blackColor,
              ),
            );
          }
          var data = snapshot.data!['subcategory'];
          return ListView.builder(
              itemCount: data.length,
              itemBuilder: ((context, index) {
                return Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListTile(
                      onTap: () {
                        categoryProvider.setSubCategory(data[index]);

                        Navigator.pushNamed(
                          context,
                          ProductByCategory.screenId,
                        );
                      },
                      title: Text(
                        data[index],
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ));
              }));
        });
  }
}
