import 'package:bechdal_app/components/common_page_widget.dart';
import 'package:bechdal_app/screens/category/subcategory_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.constants.dart';
import '../../services/auth_service.dart';

class CategoryListScreen extends StatelessWidget {
  static const String screenId = 'category_list_screen';
  const CategoryListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonPageWidget(
        text: 'Categories',
        body: categoryListWidget(),
        containsAppbar: true,
        centerTitle: false);
  }

  categoryListWidget() {
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
                        if(doc!['subcategory']==null){
                          return print('No SubCategories');
                        }
                        Navigator.pushNamed(context, SubCategoryScreen.screenId,
                            arguments: doc);
                      },
                      leading: Image.network(doc!['img']),
                      title: Text(
                        doc['category_name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                      ),
                    ));
              }));
        });
  }
}
