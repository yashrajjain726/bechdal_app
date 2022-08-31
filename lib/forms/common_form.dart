import 'package:bechdal_app/components/common_page_widget.dart';
import 'package:bechdal_app/provider/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommonForm extends StatelessWidget {
  static const String screenId = 'common_form';
  const CommonForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var categoryProvider = Provider.of<CategoryProvider>(context);
    return CommonPageWidget(
        text: 'Add some details',
        body: formBodyWidget(context, categoryProvider),
        containsAppbar: true,
        centerTitle: false);
  }

  formBodyWidget(BuildContext context, CategoryProvider categoryProvider) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
              '${categoryProvider.selectedCategory} > ${categoryProvider.selectedSubCategory}'),
        ],
      ),
    );
  }
}
