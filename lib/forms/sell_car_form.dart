import 'package:bechdal_app/components/bottom_nav_widget.dart';
import 'package:bechdal_app/constants/colors.dart';
import 'package:bechdal_app/constants/widgets.dart';
import 'package:bechdal_app/forms/user_form_review.dart';
import 'package:bechdal_app/provider/category_provider.dart';
import 'package:bechdal_app/services/user.dart';
import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:provider/provider.dart';

import '../components/image_picker_widget.dart';
import '../constants/validators.dart';

class SellCarForm extends StatefulWidget {
  static const screenId = 'sell_car_form';

  const SellCarForm({Key? key}) : super(key: key);

  @override
  State<SellCarForm> createState() => _SellCarFormState();
}

class _SellCarFormState extends State<SellCarForm> {
  UserService firebaseUser = UserService();
  late TextEditingController _carModelNameController;
  late TextEditingController _yearController;
  late TextEditingController _priceController;
  late TextEditingController _fuelController;
  late TextEditingController _transmissionController;
  late TextEditingController _kmDrivenController;
  late TextEditingController _ownerController;
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late FocusNode _carModelNameNode;
  late FocusNode _yearNode;
  late FocusNode _priceNode;
  late FocusNode _fuelNode;
  late FocusNode _transmissionNode;
  late FocusNode _kmDrivenNode;
  late FocusNode _ownerNode;
  late FocusNode _titleNode;
  late FocusNode _descNode;
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
    _carModelNameNode = FocusNode();
    _yearNode = FocusNode();
    _priceNode = FocusNode();
    _fuelNode = FocusNode();
    _transmissionNode = FocusNode();
    _kmDrivenNode = FocusNode();
    _ownerNode = FocusNode();
    _titleNode = FocusNode();
    _descNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _carModelNameController.dispose();
    _yearController.dispose();
    _priceController.dispose();
    _fuelController.dispose();
    _transmissionController.dispose();
    _kmDrivenController.dispose();
    _ownerController.dispose();
    _titleController.dispose();
    _descController.dispose();
    _carModelNameNode.dispose();
    _yearNode.dispose();
    _priceNode.dispose();
    _fuelNode.dispose();
    _transmissionNode.dispose();
    _kmDrivenNode.dispose();
    _ownerNode.dispose();
    _titleNode.dispose();
    _descNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // it is used to get context
    var categoryProvider = Provider.of<CategoryProvider>(context);
    setState(() {
      _carModelNameController.text = categoryProvider.formData.isEmpty
          ? ""
          : categoryProvider.formData['brand'];
      _yearController.text = categoryProvider.formData.isEmpty
          ? ""
          : categoryProvider.formData['year'];
      _priceController.text = categoryProvider.formData.isEmpty
          ? ""
          : categoryProvider.formData['price'];
      _fuelController.text = categoryProvider.formData.isEmpty
          ? ""
          : categoryProvider.formData['fuel_type'];
      _transmissionController.text = categoryProvider.formData.isEmpty
          ? ""
          : categoryProvider.formData['transmission_type'];
      _kmDrivenController.text = categoryProvider.formData.isEmpty
          ? ""
          : categoryProvider.formData['km_driven'];
      _ownerController.text = categoryProvider.formData.isEmpty
          ? ""
          : categoryProvider.formData['owners'];
      _titleController.text = categoryProvider.formData.isEmpty
          ? ""
          : categoryProvider.formData['title'];
      _descController.text = categoryProvider.formData.isEmpty
          ? ""
          : categoryProvider.formData['description'];
    });
    super.didChangeDependencies();
  }

  final List<String> _fuelType = ['Diesel', 'Petrol', 'Electric', 'LPG'];
  final List<String> _transmissionType = ['Automatic', 'Manual'];
  final List<String> _noOfOwner = ['1st', '2nd', '3rd', '4th', '4th+'];

  @override
  Widget build(BuildContext context) {
    var categoryProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 0,
          iconTheme: IconThemeData(color: blackColor),
          title: Text(
            'Add Car Details',
            style: TextStyle(color: blackColor),
          )),
      body: sellCarFormWidget(categoryProvider),
      bottomNavigationBar: BottomNavigationWidget(
        buttonText: 'Next',
        validator: true,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            categoryProvider.formData.addAll({
              'seller_uid': firebaseUser.user!.uid,
              'category': categoryProvider.selectedCategory,
              'subcategory': categoryProvider.selectedSubCategory,
              'brand': _carModelNameController.text,
              'year': _yearController.text,
              'price': _priceController.text,
              'fuel_type': _fuelController.text,
              'transmission_type': _transmissionController.text,
              'km_driven': _kmDrivenController.text,
              'owners': _ownerController.text,
              'title': _titleController.text,
              'description': _descController.text,
              'images': categoryProvider.imageUploadedUrls.isEmpty
                  ? ''
                  : categoryProvider.imageUploadedUrls,
              'posted_at': DateTime.now().microsecondsSinceEpoch,
              'favourites': [],
            });
            if (categoryProvider.imageUploadedUrls.isNotEmpty) {
              Navigator.pushNamed(context, UserFormReview.screenId);
            } else {
              customSnackBar(
                  context: context,
                  content: 'Please upload images to the database');
            }
            print(categoryProvider.formData);
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
    return SafeArea(
      child: SingleChildScrollView(
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
                    fontSize: 25,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () => _getCarModelList(context, categoryProvider),
                  child: TextFormField(
                      focusNode: _carModelNameNode,
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
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    _fuelTypeListView(context);
                  },
                  child: TextFormField(
                    controller: _fuelController,
                    focusNode: _fuelNode,
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
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    _transmissionTypeListView(context);
                  },
                  child: TextFormField(
                    controller: _transmissionController,
                    focusNode: _transmissionNode,
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
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    _ownerListView(context);
                  },
                  child: TextFormField(
                    controller: _ownerController,
                    focusNode: _ownerNode,
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
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    controller: _yearController,
                    focusNode: _yearNode,
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
                            borderSide: BorderSide(color: disabledColor)))),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    controller: _priceController,
                    focusNode: _priceNode,
                    validator: (value) {
                      return validatePrice(value);
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefix: const Text('₹ '),
                      labelText: 'Car Price',
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
                    )),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    controller: _kmDrivenController,
                    focusNode: _kmDrivenNode,
                    validator: (value) {
                      return checkNullEmptyValidation(
                          value, 'Kilometer driven');
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
                    )),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    controller: _titleController,
                    focusNode: _titleNode,
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
                    )),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    controller: _descController,
                    focusNode: _descNode,
                    maxLines: 3,
                    validator: (value) {
                      return checkNullEmptyValidation(
                          value, 'car\'s description');
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Description*',
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
                    )),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    print(categoryProvider.imageUploadedUrls.length);
                    return openBottomSheet(
                        context: context, child: const ImagePickerWidget());
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.grey[300],
                    ),
                    child: Text(
                      categoryProvider.imageUploadedUrls.isNotEmpty
                          ? 'Upload More Images'
                          : 'Upload Image',
                      style: TextStyle(
                          color: blackColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                categoryProvider.imageUploadedUrls.isNotEmpty
                    ? GalleryImage(
                        titleGallery: 'Uploaded Images',
                        numOfShowImages:
                            categoryProvider.imageUploadedUrls.length,
                        imageUrls: categoryProvider.imageUploadedUrls)
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
