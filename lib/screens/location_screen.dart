import 'package:bechdal_app/components/common_page_widget.dart';
import 'package:bechdal_app/components/large_heading_widget.dart';
import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/constants/functions/functions.permission.dart';
import 'package:bechdal_app/constants/functions/functions.widgets.dart';
import 'package:bechdal_app/screens/home_screen.dart';
import 'package:bechdal_app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

class LocationScreen extends StatefulWidget {
  static const String screenId = 'location_screen';
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return CommonPageWidget(
      text: '',
      body: bodyLocationWidget(context),
      containsAppbar: false,
      centerTitle: true,
      bottomNavigation: const BottomLocationPermissionWidget(),
    );
  }

  Widget bodyLocationWidget(context) {
    return Column(
      children: [
        const LargeHeadingWidget(
            heading: 'Choose Location',
            subheadingTextSize: 16,
            headingTextSize: 30,
            subHeading:
                'To continue, we need to know your sell/buy location so that we can further assist you'),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          child: Lottie.asset(
            'assets/lottie/location_lottie.json',
          ),
          height: 300,
          width: 300,
        ),
      ],
    );
  }
}

class BottomLocationPermissionWidget extends StatefulWidget {
  const BottomLocationPermissionWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomLocationPermissionWidget> createState() =>
      _BottomLocationPermissionWidgetState();
}

class _BottomLocationPermissionWidgetState
    extends State<BottomLocationPermissionWidget> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: roundedButton(
          context: context,
          text: 'Choose Location',
          bgColor: primaryColor,
          onPressed: () {
            openLocationBottomsheet(context);
          }),
    );
  }

  openLocationBottomsheet(BuildContext context) {
    String countryValue = '';
    String stateValue = '';
    String cityValue = '';
    String _address = '';
    String manualAddress = '';
    loadingDialogBox(context, 'Fetching details..');
    getLocationAndAddress(context).then((location) {
      if (location != null) {
        Navigator.pop(context);
        setState(() {
          _address = location;
        });
        showModalBottomSheet(
            isScrollControlled: true,
            enableDrag: true,
            context: context,
            builder: (context) {
              return Container(
                color: whiteColor,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    AppBar(
                      automaticallyImplyLeading: false,
                      iconTheme: IconThemeData(
                        color: blackColor,
                      ),
                      elevation: 1,
                      backgroundColor: whiteColor,
                      title: Row(children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.clear,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Select Location',
                          style: TextStyle(color: blackColor),
                        )
                      ]),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: TextFormField(
                        decoration: InputDecoration(
                            suffixIcon: const Icon(Icons.search),
                            hintText: 'Select city, area or neighbourhood',
                            hintStyle: TextStyle(
                              color: greyColor,
                              fontSize: 12,
                            ),
                            contentPadding: const EdgeInsets.all(20),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8))),
                      ),
                    ),
                    ListTile(
                      onTap: () async {
                        loadingDialogBox(context, 'Updating location..');
                        await getCurrentLocation(
                                context, serviceEnabled, permission)
                            .then((value) {
                          if (value != null) {
                            authService.updateFirebaseUser(context, {
                              'location':
                                  GeoPoint(value.latitude, value.longitude),
                              'address': _address
                            }).then((value) {
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(
                                context,
                                HomeScreen.screenId,
                              );
                            });
                          }
                        });
                      },
                      horizontalTitleGap: 0,
                      leading: Icon(
                        Icons.my_location,
                        color: primaryColor,
                      ),
                      title: Text(
                        'Use current Location',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        _address == '' ? 'Fetch current Location' : _address,
                        style: TextStyle(
                          color: greyColor,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Text(
                        'Choose City',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: blackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: CSCPicker(
                        layout: Layout.vertical,
                        defaultCountry: DefaultCountry.India,
                        flagState: CountryFlag.DISABLE,
                        dropdownDecoration:
                            const BoxDecoration(shape: BoxShape.rectangle),
                        onCountryChanged: (value) async {
                          setState(() {
                            countryValue = value;
                          });
                        },
                        onStateChanged: (value) async {
                          setState(() {
                            if (value != null) {
                              stateValue = value;
                            }
                          });
                        },
                        onCityChanged: (value) async {
                          setState(() {
                            if (value != null) {
                              cityValue = value;
                              manualAddress = "$cityValue, $stateValue";
                              print(manualAddress);
                            }
                          });
                          if (value != null) {
                            authService.updateFirebaseUser(context, {
                              'address': manualAddress,
                              'state': stateValue,
                              'city': cityValue,
                              'country': countryValue
                            }).then((value) {
                              print(manualAddress + 'inside manual selection');
                              Navigator.pushReplacementNamed(
                                context,
                                HomeScreen.screenId,
                              );
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            });
      } else {
        Navigator.pop(context);
      }
    });
  }
}
