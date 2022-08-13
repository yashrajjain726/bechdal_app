import 'package:bechdal_app/components/bottom_nav_widget.dart';
import 'package:bechdal_app/components/common_page_widget.dart';
import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/constants/functions/functions.widgets.dart';
import 'package:bechdal_app/provider/category_provider.dart';
import 'package:bechdal_app/services/firebase_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/image_picker_widget.dart';
import '../constants/functions/functions.validation.dart';

class SellCarForm extends StatefulWidget {
  static const screenId = 'sell_car_form';

  const SellCarForm({Key? key}) : super(key: key);

  @override
  State<SellCarForm> createState() => _SellCarFormState();
}

class _SellCarFormState extends State<SellCarForm> {
  final FirebaseUser _firebaseUser = FirebaseUser();
  late TextEditingController _carModelNameController;
  late TextEditingController _yearController;
  late TextEditingController _priceController;
  late TextEditingController _fuelController;
  late TextEditingController _transmissionController;
  late TextEditingController _kmDrivenController;
  late TextEditingController _ownerController;
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _sellerAddressController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _carModelNameController = TextEditingController();
    _yearController = TextEditingController();
    _priceController = TextEditingController();
    _fuelController = TextEditingController();
    _transmissionController = TextEditingController();
    _kmDrivenController = TextEditingController();
    _ownerController = TextEditingController();
    _titleController = TextEditingController();
    _descController = TextEditingController();
    _sellerAddressController = TextEditingController();
    _firebaseUser.getUserData().then((value) {
      setState(() {
        _sellerAddressController.text = value['address'];
      });
    });
    super.initState();
  }

  final List<String> _fuelType = ['Diesel', 'Petrol', 'Electric', 'LPG'];
  final List<String> _transmissionType = ['Automatic', 'Manual'];
  final List<String> _noOfOwner = ['1', '2', '3', '4', '4+'];

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
            print('validated');
          } else {
            customSnackBar(
                context: context,
                content: 'Please complete the required details');
          }
        },
      ),
    );
  }

  _fuelTypeListView(BuildContext context) {
    return openBottomSheet(
        context: context,
        appBarTitle: 'Select Fuel Type',
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: _fuelType.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: () {
                  setState(() {
                    _fuelController.text = _fuelType[index];
                  });
                  Navigator.pop(context);
                },
                title: Text(_fuelType[index]),
              );
            }));
  }

  _transmissionTypeListView(BuildContext context) {
    return openBottomSheet(
        context: context,
        appBarTitle: 'Select Transmission Type',
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: _transmissionType.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: () {
                  setState(() {
                    _transmissionController.text = _transmissionType[index];
                  });
                  Navigator.pop(context);
                },
                title: Text(_transmissionType[index]),
              );
            }));
  }

  _ownerListView(BuildContext context) {
    return openBottomSheet(
        context: context,
        appBarTitle: 'Select No. Of Owners',
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: _noOfOwner.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: () {
                  setState(() {
                    _ownerController.text = _noOfOwner[index];
                  });
                  Navigator.pop(context);
                },
                title: Text(_noOfOwner[index]),
              );
            }));
  }

  _getCarModelList(BuildContext context, var categoryProvider) {
    return openBottomSheet(
      context: context,
      appBarTitle: 'Select Car Model',
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
    );
  }

  sellCarFormWidget(categoryProvider) {
    return SingleChildScrollView(
      child: Padding(
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
                onTap: () => _getCarModelList(context, categoryProvider),
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
                        errorStyle:
                            const TextStyle(color: Colors.red, fontSize: 10),
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
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: disabledColor)),
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
                    return validateYear(value);
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Purchase Year',
                      labelStyle: TextStyle(
                        color: greyColor,
                        fontSize: 14,
                      ),
                      errorStyle:
                          const TextStyle(color: Colors.red, fontSize: 10),
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
                      errorStyle:
                          const TextStyle(color: Colors.red, fontSize: 10),
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
                  _fuelTypeListView(context);
                },
                child: TextFormField(
                  controller: _fuelController,
                  enabled: false,
                  validator: (value) {
                    return checkNullEmptyValidation(value, 'fuel type');
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
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: disabledColor)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: disabledColor))),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  _transmissionTypeListView(context);
                },
                child: TextFormField(
                  controller: _transmissionController,
                  enabled: false,
                  validator: (value) {
                    return checkNullEmptyValidation(
                        value, 'transmission type ');
                  },
                  decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.arrow_drop_down_sharp,
                        size: 30,
                        color: blackColor,
                      ),
                      labelText: 'Transmission Type',
                      errorStyle:
                          const TextStyle(color: Colors.red, fontSize: 10),
                      labelStyle: TextStyle(
                        color: greyColor,
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.all(15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: disabledColor)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: disabledColor))),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                  controller: _kmDrivenController,
                  validator: (value) {
                    return checkNullEmptyValidation(value, 'Kilometer driven');
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Kilometer Driven',
                      labelStyle: TextStyle(
                        color: greyColor,
                        fontSize: 14,
                      ),
                      errorStyle:
                          const TextStyle(color: Colors.red, fontSize: 10),
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
                  _ownerListView(context);
                },
                child: TextFormField(
                  controller: _ownerController,
                  enabled: false,
                  validator: (value) {
                    return checkNullEmptyValidation(value, 'no. of owners ');
                  },
                  decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.arrow_drop_down_sharp,
                        size: 30,
                        color: blackColor,
                      ),
                      labelText: 'No. Of Owners',
                      errorStyle:
                          const TextStyle(color: Colors.red, fontSize: 10),
                      labelStyle: TextStyle(
                        color: greyColor,
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.all(15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: disabledColor)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: disabledColor))),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                  controller: _titleController,
                  maxLength: 50,
                  validator: (value) {
                    return checkNullEmptyValidation(value, 'title');
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: 'Title',
                      counterText:
                          'Mention the key features, i.e Brand, Model, Type',
                      labelStyle: TextStyle(
                        color: greyColor,
                        fontSize: 14,
                      ),
                      errorStyle:
                          const TextStyle(color: Colors.red, fontSize: 10),
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
                  controller: _descController,
                  maxLength: 50,
                  validator: (value) {
                    return checkNullEmptyValidation(
                        value, 'car\'s description');
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: 'Description',
                      counterText: '',
                      labelStyle: TextStyle(
                        color: greyColor,
                        fontSize: 14,
                      ),
                      errorStyle:
                          const TextStyle(color: Colors.red, fontSize: 10),
                      contentPadding: const EdgeInsets.all(15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: disabledColor)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: disabledColor)))),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                  controller: _sellerAddressController,
                  validator: (value) {
                    return checkNullEmptyValidation(value, 'your address');
                  },
                  minLines: 2,
                  maxLines: 4,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: 'Address',
                      labelStyle: TextStyle(
                        color: greyColor,
                        fontSize: 14,
                      ),
                      errorStyle:
                          const TextStyle(color: Colors.red, fontSize: 10),
                      contentPadding: const EdgeInsets.all(15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: disabledColor)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: disabledColor)))),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () => openBottomSheet(
                    context: context, child: const ImagePickerWidget()),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Colors.grey[300],
                  ),
                  child: Text(
                    'Upload Image',
                    style: TextStyle(
                        color: blackColor, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
