import 'package:bechdal_app/constants/colors.dart';
import 'package:bechdal_app/constants/validators.dart';
import 'package:bechdal_app/constants/widgets.dart';
import 'package:bechdal_app/screens/location_screen.dart';
import 'package:bechdal_app/screens/main_navigatiion_screen.dart';
import 'package:bechdal_app/services/auth.dart';
import 'package:bechdal_app/services/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../components/bottom_nav_widget.dart';
import '../provider/category_provider.dart';

class UserFormReview extends StatefulWidget {
  static const screenId = 'user_form_review_screen';

  const UserFormReview({Key? key}) : super(key: key);

  @override
  State<UserFormReview> createState() => _UserFormReviewState();
}

class _UserFormReviewState extends State<UserFormReview> {
  UserService firebaseUser = UserService();
  Auth authService = Auth();

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _countryCodeController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late FocusNode _nameNode;
  late FocusNode _countryCodeNode;
  late FocusNode _phoneNumberNode;
  late FocusNode _emailNode;
  late FocusNode _addressNode;
  @override
  void dispose() {
    _nameController.dispose();
    _countryCodeController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _nameNode.dispose();
    _countryCodeNode.dispose();
    _phoneNumberNode.dispose();
    _emailNode.dispose();
    _addressNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _countryCodeController = TextEditingController(text: '+91');
    _phoneNumberController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _nameNode = FocusNode();
    _countryCodeNode = FocusNode();
    _phoneNumberNode = FocusNode();
    _emailNode = FocusNode();
    _addressNode = FocusNode();
    firebaseUser.getUserData().then((value) {
      setState(() {
        print(value);
        _nameController.text = value['name'] ?? '';
        _phoneNumberController.text = value['contact_details']['mobile'] ?? '';
        _emailController.text = value['contact_details']['email'] ?? '';
        _addressController.text =
            value['contact_details']['address'] ?? value['address'];
      });
      print("valus is ${value['contact_details']['mobile']}");
    });
  }

  Future<void> updateUserProductData(
      categoryProvider, Map<String, dynamic> data, BuildContext context) {
    return authService.users
        .doc(firebaseUser.user!.uid)
        .update(data)
        .then((value) {
      saveProductToDatabase(categoryProvider, context);
    }).catchError((error) {
      if (kDebugMode) {
        print(error);
      }
      customSnackBar(
          context: context,
          content: 'Failed to update user product to database');
    });
  }

  Future<void> saveProductToDatabase(categoryProvider, BuildContext context) {
    return authService.products.add(categoryProvider.formData).then((value) {
      categoryProvider.clearData();
      customSnackBar(
          context: context, content: 'We have added your product to database');
      Navigator.of(context).pushNamedAndRemoveUntil(
          MainNavigationScreen.screenId, (route) => false);
    }).catchError((error) {
      if (kDebugMode) {
        print(error);
      }
      customSnackBar(
          context: context,
          content: 'Failed to update user product to database');
    });
  }

  confirmFormDataDialog(CategoryProvider categoryProvider) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Confirm Details',
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Are you sure, you want to continue adding the product?',
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading:
                        Image.network(categoryProvider.formData['images'][0]),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoryProvider.formData['title'],
                          maxLines: 1,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          categoryProvider.formData['description'],
                          style: TextStyle(
                            color: disabledColor,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        )
                      ],
                    ),
                    subtitle: Text(
                      '\u{20B9} ${categoryProvider.formData['price']}',
                      style: TextStyle(
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            secondaryColor,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            secondaryColor,
                          ),
                        ),
                        onPressed: () async {
                          loadingDialogBox(context, 'uploading to database..');
                          await updateUserProductData(
                                  categoryProvider,
                                  {
                                    'contact_details': {
                                      'mobile':
                                          '+91${_phoneNumberController.text}',
                                      'email': _emailController.text,
                                    },
                                    'name': _nameController.text,
                                  },
                                  context)
                              .whenComplete(() {
                            print('uploaded');
                          });
                        },
                        child: const Text(
                          'Confirm',
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var categoryProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: blackColor),
          backgroundColor: whiteColor,
          title: Text(
            'Review details',
            style: TextStyle(color: blackColor),
          )),
      body: userFormReviewBody(),
      bottomNavigationBar: BottomNavigationWidget(
        validator: true,
        buttonText: 'Confirm',
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            return confirmFormDataDialog(categoryProvider);
          }
        },
      ),
    );
  }

  userFormReviewBody() {
    return Form(
      key: _formKey,
      child: FutureBuilder<DocumentSnapshot>(
        future: firebaseUser.getUserData(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error loading Review Form...');
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text('Document does not ecist');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: secondaryColor,
            ));
          }
          _nameController.text = snapshot.data!['name'] ?? '';
          _phoneNumberController.text =
              snapshot.data!['contact_details']['mobile'] != null
                  ? snapshot.data!['contact_details']['mobile'].substring(3)
                  : snapshot.data!['mobile'] != null
                      ? snapshot.data!['mobile'].substring(3)
                      : '';
          print(snapshot.data!.data());
          _emailController.text = snapshot.data!['email'] ?? '';
          _addressController.text = snapshot.data!['address'] ?? '';
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: primaryColor,
                        radius: 40,
                        child: CircleAvatar(
                          backgroundColor: secondaryColor,
                          radius: 37,
                          child: Icon(
                            CupertinoIcons.person,
                            color: whiteColor,
                            size: 40,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                            focusNode: _nameNode,
                            controller: _nameController,
                            validator: (value) =>
                                checkNullEmptyValidation(value, "name"),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(
                                color: greyColor,
                                fontSize: 14,
                              ),
                              errorStyle: const TextStyle(
                                  color: Colors.red, fontSize: 10),
                              contentPadding: const EdgeInsets.all(15),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: blackColor)),
                            )),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Contact Details',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                            focusNode: _countryCodeNode,
                            enabled: false,
                            controller: _countryCodeController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: disabledColor)),
                            )),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                            focusNode: _phoneNumberNode,
                            controller: _phoneNumberController,
                            maxLength: 10,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            validator: (value) => validateMobile(value),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              counterText: '',
                              labelText: 'Enter your phone number',
                              labelStyle: TextStyle(
                                color: greyColor,
                                fontSize: 14,
                              ),
                              errorStyle: const TextStyle(
                                  color: Colors.red, fontSize: 10),
                              contentPadding: const EdgeInsets.all(15),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: blackColor)),
                            )),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      focusNode: _emailNode,
                      controller: _emailController,
                      validator: (value) => validateEmail(
                            value,
                            EmailValidator.validate(
                              _emailController.text,
                            ),
                          ),
                      decoration: InputDecoration(
                          labelText: 'Enter your email address',
                          labelStyle: TextStyle(
                            color: greyColor,
                            fontSize: 14,
                          ),
                          errorStyle:
                              const TextStyle(color: Colors.red, fontSize: 10),
                          contentPadding: const EdgeInsets.all(15),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: blackColor)))),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (builder) => LocationScreen(
                                onlyPop: true,
                                popToScreen: UserFormReview.screenId,
                              )));
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                              focusNode: _addressNode,
                              enabled: false,
                              controller: _addressController,
                              validator: (value) {
                                return checkNullEmptyValidation(
                                    value, 'your address');
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
                                errorStyle: const TextStyle(
                                    color: Colors.red, fontSize: 10),
                                contentPadding: const EdgeInsets.all(15),
                              )),
                        ),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
