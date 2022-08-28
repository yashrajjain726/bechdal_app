import 'package:bechdal_app/components/common_page_widget.dart';
import 'package:bechdal_app/forms/sell_car_form.dart';
import 'package:bechdal_app/provider/category_provider.dart';
import 'package:bechdal_app/screens/category/subcategory_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.constants.dart';
import '../../services/auth_service.dart';

class CategoryListScreen extends StatelessWidget {
  static const String screenId = 'category_list_screen';
  const CategoryListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var categoryProvider = Provider.of<CategoryProvider>(context);
    return CommonPageWidget(
      text: 'Categories',
      body: categoryListWidget(categoryProvider),
      containsAppbar: true,
      centerTitle: false,
    );
  }

  categoryListWidget(categoryProvider) {
    AuthService authService = AuthService();

    return FutureBuilder<QuerySnapshot>(
        future: authService.categories.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

          return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: ((context, index) {
                var doc = snapshot.data?.docs[index];
                return Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListTile(
                      onTap: () {
                        categoryProvider.setCategory(doc!['category_name']);
                        categoryProvider.setCategorySnapshot(doc);
                        if (doc['subcategory'] == null) {
                          Navigator.of(context).pushNamed(SellCarForm.screenId);
                        } else {
                          Navigator.pushNamed(
                              context, SubCategoryScreen.screenId,
                              arguments: doc);
                        }
                      },
                      leading: Image.network(doc!['img']),
                      title: Text(
                        doc['category_name'],
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      trailing: doc['subcategory'] != null
                          ? const Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                            )
                          : null,
                    ));
              }));
        });
  }
}
