import 'package:bechdal_app/components/common_page_widget.dart';
import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:flutter/material.dart';

class SellCarForm extends StatelessWidget {
  static const screenId = 'sell_car_form';
  final _formKey = GlobalKey<FormState>();
  SellCarForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonPageWidget(
      text: 'Add Car Details',
      body: sellCarFormWidget(),
      containsAppbar: true,
      centerTitle: false,
    );
  }

  sellCarFormWidget() {
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
            SizedBox(
              height: 20,
            ),
            TextFormField(
              validator: (value) {},
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  labelText: 'Model Name',
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
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
