import 'package:bechdal_app/components/common_page_widget.dart';
import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/constants/functions/functions.validation.dart';
import 'package:bechdal_app/services/firebase_user.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/category_provider.dart';

class UserFormReview extends StatefulWidget {
  static const screenId = 'user_form_review_screen';

  const UserFormReview({Key? key}) : super(key: key);

  @override
  State<UserFormReview> createState() => _UserFormReviewState();
}

class _UserFormReviewState extends State<UserFormReview> {
  FirebaseUser firebaseUser = FirebaseUser();

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _countryCodeController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _countryCodeController = TextEditingController(text: '+91');
    _phoneNumberController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    firebaseUser.getUserData().then((value) {
      setState(() {
        _addressController.text = value['address'];
      });
    });
  }

  @override
  void didChangeDependencies() {
    var categoryProvider = Provider.of<CategoryProvider>(context);
    categoryProvider.getUserDetail();
    setState(() {
      _nameController.text =
          categoryProvider.userDetails!.data()!['name'] ?? "";
      _phoneNumberController.text =
          categoryProvider.userDetails!.data()!['phone_number'] ?? "";
      _emailController.text =
          categoryProvider.userDetails!.data()!['email'] ?? "";
      _addressController.text =
          categoryProvider.userDetails!.data()!['address'] ?? "";
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // var categoryProvider = Provider.of<CategoryProvider>(context);
    // categoryProvider.getUserDetail();
    return CommonPageWidget(
      text: 'Review your details',
      body: userFormReviewBody(),
      containsAppbar: true,
      centerTitle: false,
    );
  }

  userFormReviewBody() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: secondaryColor,
                  radius: 40,
                  child: CircleAvatar(
                    backgroundColor: primaryColor,
                    radius: 37,
                    child: Icon(
                      CupertinoIcons.person,
                      color: whiteColor,
                      size: 40,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
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
                        errorStyle:
                            const TextStyle(color: Colors.red, fontSize: 10),
                        contentPadding: const EdgeInsets.all(15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: blackColor)),
                      )),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Contact Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFormField(
                      enabled: false,
                      controller: _countryCodeController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: disabledColor)),
                      )),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                      controller: _phoneNumberController,
                      validator: (value) => validateMobile(value),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter your phone number',
                        labelStyle: TextStyle(
                          color: greyColor,
                          fontSize: 14,
                        ),
                        errorStyle:
                            const TextStyle(color: Colors.red, fontSize: 10),
                        contentPadding: const EdgeInsets.all(15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: blackColor)),
                      )),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
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
            TextFormField(
                controller: _addressController,
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
                  errorStyle: const TextStyle(color: Colors.red, fontSize: 10),
                  contentPadding: const EdgeInsets.all(15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: disabledColor)),
                )),
          ],
        ),
      ),
    );
  }
}
