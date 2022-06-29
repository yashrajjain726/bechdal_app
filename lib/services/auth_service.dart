import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/constants/functions.constants.dart';
import 'package:bechdal_app/screens/auth/otp_screen.dart';
import 'package:bechdal_app/screens/location_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final storage = const FlutterSecureStorage();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(BuildContext context, user) async {
    final uid = user!.uid;
    final mobileNo = user!.phoneNumber;
    final email = user!.email;

    final QuerySnapshot userDataQuery =
        await users.where('uid', isEqualTo: user!.uid).get();
    List<DocumentSnapshot> wasUserPresentInDatabase = userDataQuery.docs;
    if (wasUserPresentInDatabase.isNotEmpty) {
      fetchLocationAndAddress(
        context,
        selectedLocation,
        serviceEnabled,
        permission,
      );
    } else {
      fetchLocationAndAddress(
          context, selectedLocation, serviceEnabled, permission,
          navigateTo: const LocationScreen());
      return users.doc(uid).set({
        'uid': uid,
        'mobile_no': mobileNo,
        'email': email,
        'location': selectedLocation,
      }).then((value) {
        print('user added successfully');
      }).catchError((error) => print("Failed to add user: $error"));
    }
  }

  Future<void> verifyPhoneNumber(
    BuildContext context,
    number,
  ) async {
    final PhoneVerificationCompleted verificationCompleted =
        (phoneAuthCredential) async {
      await _firebaseAuth.signInWithCredential(phoneAuthCredential);
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        Navigator.pop(context);
        wrongDetailsAlertBox(
            'The phone number that you entered is invalid. Please enter a valid phone number.',
            context);
      } else {
        Navigator.pop(context);
        wrongDetailsAlertBox(e.code, context);
      }
    };
    final PhoneCodeSent phoneCodeSent =
        ((verificationId, forceResendingToken) async {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (builder) => OTPScreen(
                    phoneNumber: number,
                    verificationIdFinal: verificationId,
                  )));
    });
    try {
      _firebaseAuth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          timeout: const Duration(seconds: 60),
          codeSent: phoneCodeSent,
          codeAutoRetrievalTimeout: (String verificationId) {
            print(verificationId);
          });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signInwithPhoneNumber(
      String verificationId, String smsCode, BuildContext context) async {
    try {
      loadingDialogBox(context, 'Please Wait');
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      Navigator.pop(context);
      if (userCredential != null) {
        addUser(context, userCredential.user);
      } else {
        wrongDetailsAlertBox('Login Failed, Please retry again.', context);
      }
    } catch (e) {
      Navigator.pop(context);
      wrongDetailsAlertBox(
          'The details you entered is not matching with our database. Please validate details again, before proceeding. ',
          context);
    }
  }

  void storeTokenAndData(UserCredential userCredential) async {
    print("storing token and data");
    await storage.write(
        key: "token", value: userCredential.credential!.token.toString());
    await storage.write(
        key: "usercredential", value: userCredential.toString());
  }

  wrongDetailsAlertBox(String text, BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Text(
        text,
        style: const TextStyle(
          color: blackColor,
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Ok',
            )),
      ],
    );

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                content:
                    'The account already exists with a different credential',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                content:
                    'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              content: 'Error occurred using Google Sign In. Try again.',
            ),
          );
        }
      }
    }

    return user;
  }
}
