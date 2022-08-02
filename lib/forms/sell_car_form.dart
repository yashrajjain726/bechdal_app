import 'package:bechdal_app/components/bottom_nav_widget.dart';
import 'package:bechdal_app/components/common_page_widget.dart';
import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/main.dart';
import 'package:bechdal_app/provider/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/functions/functions.validation.dart';

class SellCarForm extends StatefulWidget {
  static const screenId = 'sell_car_form';

  const SellCarForm({Key? key}) : super(key: key);

  @override
  State<SellCarForm> createState() => _SellCarFormState();
}

class _SellCarFormState extends State<SellCarForm> {
  late TextEditingController _carModelNameController;
  late TextEditingController _yearController;
  final _formKey = GlobalKey<FormState>();
  
  
  @override
  void initState() {
    _carModelNameController = TextEditingController();
    _yearController = TextEditingController();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    var categoryProvider = Provider.of<CategoryProvider>(context);
    return CommonPageWidget(
      text: 'Add Car Details',
      body: sellCarFormWidget(categoryProvider),
      containsAppbar: true,
      centerTitle: false,
      bottomNavigation: BottomNavigationWidget(
        buttonText: 'Next',
        validator: true,
        onPressed: () async{
          if (_formKey.currentState!.validate()) {
            print('value is ${_carModelNameController.text}');
          }

        },
      ),
    );
  }
  Widget _appBar(title){
    return AppBar(
      backgroundColor: whiteColor,
      iconTheme: IconThemeData(color: blackColor),
      automaticallyImplyLeading: false,
      title: Text('${title} > Brands',style: TextStyle(color: blackColor,fontWeight: FontWeight.normal),),
    );
  }
  _getCarModelList(BuildContext context,var categoryProvider) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _appBar(categoryProvider.selectedCategory),
          Expanded(
            child: ListView.builder(
              itemCount: categoryProvider.doc['models'].length,
                itemBuilder: (BuildContext context,int index ){
              return ListTile(
                onTap: (){
                  setState(() {
                    _carModelNameController.text = categoryProvider.doc['models'][index];
                  });
                  Navigator.pop(context);
                },
                title: Text(categoryProvider.doc['models'][index]),);
            }),
          ),
        ],
      ),
    );
  }

  sellCarFormWidget(categoryProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Form(
        key: _formKey,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Car Details',
              style: TextStyle(
                color: blackColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return _getCarModelList(context,categoryProvider);
                    });
              },
              child: TextFormField(

                controller: _carModelNameController,
                validator: (value) {
                  if(value==null || value.isEmpty){
                    return 'Please choose a car model';
                  }
                  return null;
                },
                keyboardType: TextInputType.name,
                enabled: false,
                decoration: InputDecoration(
                    labelText: 'Model Name',
                    errorStyle: TextStyle(color: Colors.red,fontSize: 10),
                    labelStyle: TextStyle(
                      color: greyColor,
                      fontSize: 14,
                    ),
                    hintText: 'Enter your car model variant',
                    hintStyle: TextStyle(
                      color: greyColor,
                      fontSize: 14,
                    ),
                    contentPadding: const EdgeInsets.all(15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _yearController,
              validator: (value) {
                return validateYear(value.toString());
              },
              keyboardType: TextInputType.number,
              enabled: true,
              decoration: InputDecoration(
                  labelText: 'Purchase Year',
                  labelStyle: TextStyle(
                    color: greyColor,
                    fontSize: 14,
                  ),
                  hintText: 'Enter your car purchase year',
                  hintStyle: TextStyle(
                    color: greyColor,
                    fontSize: 14,
                  ),
                  contentPadding: const EdgeInsets.all(15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8))),
            ),
          ],
        ),
      ),
    );
  }
}
