import 'package:bechdal_app/components/large_heading_widget.dart';
import 'package:bechdal_app/screens/main_navigatiion_screen.dart';
import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/constants/functions/functions.permission.dart';
import 'package:bechdal_app/constants/functions/functions.widgets.dart';
import 'package:bechdal_app/services/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LocationScreen extends StatefulWidget {
  final bool? onlyPop;
  final String? popToScreen;
  static const String screenId = 'location_screen';
  const LocationScreen({
    this.popToScreen,
    this.onlyPop,
    Key? key,
  }) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: _body(context),
        bottomNavigationBar: BottomLocationPermissionWidget(
            onlyPop: widget.onlyPop, popToScreen: widget.popToScreen ?? ''));
  }

  Widget _body(context) {
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
          height: 300,
          width: 300,
          child: Lottie.asset(
            'assets/lottie/location_lottie.json',
          ),
        ),
      ],
    );
  }
}

class BottomLocationPermissionWidget extends StatefulWidget {
  final bool? onlyPop;
  final String popToScreen;
  const BottomLocationPermissionWidget({
    required this.popToScreen,
    this.onlyPop,
    Key? key,
  }) : super(key: key);

  @override
  State<BottomLocationPermissionWidget> createState() =>
      _BottomLocationPermissionWidgetState();
}

class _BottomLocationPermissionWidgetState
    extends State<BottomLocationPermissionWidget> {
  UserService firebaseUser = UserService();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: roundedButton(
          context: context,
          text: 'Choose Location',
          bgColor: secondaryColor,
          onPressed: () {
            openLocationBottomsheet(context);
          }),
    );
  }

  openLocationBottomsheet(BuildContext context) {
    String countryValue = '';
    String stateValue = '';
    String cityValue = '';
    String address = '';
    String manualAddress = '';
    loadingDialogBox(context, 'Fetching details..');
    getLocationAndAddress(context).then((location) {
      if (location != null) {
        Navigator.pop(context);
        setState(() {
          address = location;
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
                            firebaseUser.updateFirebaseUser(context, {
                              'location':
                                  GeoPoint(value.latitude, value.longitude),
                              'address': address
                            }).then((value) {
                              return (widget.onlyPop == true)
                                  ? (widget.popToScreen.isNotEmpty)
                                      ? Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              widget.popToScreen,
                                              (route) => false)
                                      : Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              MainNavigationScreen.screenId,
                                              (route) => false)
                                  : Navigator.of(context)
                                      .pushNamedAndRemoveUntil(
                                          MainNavigationScreen.screenId,
                                          (route) => false);
                            });
                          }
                        });
                      },
                      horizontalTitleGap: 0,
                      leading: Icon(
                        Icons.my_location,
                        color: secondaryColor,
                      ),
                      title: Text(
                        'Use current Location',
                        style: TextStyle(
                          color: secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        address == '' ? 'Fetch current Location' : address,
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
                            firebaseUser.updateFirebaseUser(context, {
                              'address': manualAddress,
                              'state': stateValue,
                              'city': cityValue,
                              'country': countryValue
                            }).then((value) {
                              if (kDebugMode) {
                                print(
                                    manualAddress + 'inside manual selection');
                              }
                              return (widget.onlyPop == true)
                                  ? (widget.popToScreen.isNotEmpty)
                                      ? Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              widget.popToScreen,
                                              (route) => false)
                                      : Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              MainNavigationScreen.screenId,
                                              (route) => false)
                                  : Navigator.of(context)
                                      .pushNamedAndRemoveUntil(
                                          MainNavigationScreen.screenId,
                                          (route) => false);
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
