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
  late TextEditingController _priceController;
  late TextEditingController _fuelController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _carModelNameController = TextEditingController();
    _yearController = TextEditingController();
    _priceController = TextEditingController();
    _fuelController = TextEditingController();
    super.initState();
  }

  final List<String> _fuelType = ['Diesel', 'Petrol', 'Electric', 'LPG'];

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
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            print('value is ${_carModelNameController.text}');
          }
        },
      ),
    );
  }

  Widget _appBar(title, fieldValue) {
    return AppBar(
      elevation: 0,
      backgroundColor: whiteColor,
      iconTheme: IconThemeData(color: blackColor),
      automaticallyImplyLeading: false,
      title: Text(
        '$title > $fieldValue',
        style: TextStyle(color: blackColor, fontWeight: FontWeight.normal),
      ),
    );
  }

  _fuelTypeListView(
      BuildContext context, var categoryProvider, String fieldValue) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: _fuelType.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_fuelType[index]),
                  onTap: () {
                    setState(() {
                      _fuelController.text = _fuelType[index];
                    });
                    Navigator.pop(context);
                  },
                );
              });
        });
  }

  _getCarModelList(BuildContext context, var categoryProvider) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _appBar(categoryProvider.selectedCategory, 'brands'),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: categoryProvider.doc['models'].length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      setState(() {
                        _carModelNameController.text =
                            categoryProvider.doc['models'][index];
                      });
                      Navigator.pop(context);
                    },
                    title: Text(categoryProvider.doc['models'][index]),
                  );
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
                      return _getCarModelList(context, categoryProvider);
                    });
              },
              child: TextFormField(
                  controller: _carModelNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please choose a car model';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  enabled: false,
                  decoration: InputDecoration(
                      labelText: 'Model Name',
                      errorStyle: TextStyle(color: Colors.red, fontSize: 10),
                      labelStyle: TextStyle(
                        color: greyColor,
                        fontSize: 14,
                      ),
                      suffixIcon: Icon(
                        Icons.arrow_drop_down_sharp,
                        color: blackColor,
                        size: 30,
                      ),
                      hintText: 'Enter your car model variant',
                      hintStyle: TextStyle(
                        color: greyColor,
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.all(15),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: disabledColor)))),
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
                decoration: InputDecoration(
                    labelText: 'Purchase Year',
                    labelStyle: TextStyle(
                      color: greyColor,
                      fontSize: 14,
                    ),
                    errorStyle: TextStyle(color: Colors.red, fontSize: 10),
                    hintText: 'Enter your car purchase year',
                    hintStyle: TextStyle(
                      color: greyColor,
                      fontSize: 14,
                    ),
                    contentPadding: const EdgeInsets.all(15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: disabledColor)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: disabledColor)))),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: _priceController,
                validator: (value) {
                  return validateCarPrice(value);
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    prefix: const Text('₹ '),
                    labelText: 'Car Price (in lakhs)',
                    labelStyle: TextStyle(
                      color: greyColor,
                      fontSize: 14,
                    ),
                    errorStyle: TextStyle(color: Colors.red, fontSize: 10),
                    contentPadding: const EdgeInsets.all(15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: disabledColor)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: disabledColor)))),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                _fuelTypeListView(
                    context, categoryProvider, 'fuel');
              },
              child: TextFormField(
                controller: _fuelController,
                enabled: false,
                validator: (value) {
                  return validateFuelType(value);
                },
                decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.arrow_drop_down_sharp,
                      size: 30,
                      color: blackColor,
                    ),
                    labelText: 'Fuel Type',
                    errorStyle:
                        const TextStyle(color: Colors.red, fontSize: 10),
                    labelStyle: TextStyle(
                      color: greyColor,
                      fontSize: 14,
                    ),
                    contentPadding: const EdgeInsets.all(15),

                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: disabledColor))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
