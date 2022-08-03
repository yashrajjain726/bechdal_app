import 'package:bechdal_app/components/custom_icon_button.dart';
import 'package:bechdal_app/components/large_heading_widget.dart';
import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/constants/functions/functions.validation.dart';
import 'package:bechdal_app/constants/functions/functions.widgets.dart';
import 'package:bechdal_app/screens/auth/phone_auth_screen.dart';
import 'package:bechdal_app/services/auth_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static const screenId = 'register_screen';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: LargeHeadingWidget(
              heading: 'Create Account',
              subHeading: 'Enter your Name, Email and Password for sign up.',
              anotherTaglineText: ' Already have an account ?',
              anotherTaglineColor: primaryColor,
              subheadingTextSize: 16,
              taglineNavigation: true,
            ),
          ),
          RegisterFormWidget(),
        ]),
      ),
    );
  }
}

class RegisterFormWidget extends StatefulWidget {
  const RegisterFormWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {
  bool obsecure = true;
  AuthService authService = AuthService();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 250,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextFormField(
                          validator: (value) {
                            return validateName(value, 'first');
                          },
                          controller: _firstNameController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              labelText: 'First Name',
                              labelStyle: TextStyle(
                                color: greyColor,
                                fontSize: 14,
                              ),
                              hintText: 'Enter your First Name',
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
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          validator: (value) {
                            return validateName(value, 'last');
                          },
                          controller: _lastNameController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              labelText: 'Last Name',
                              labelStyle: TextStyle(
                                color: greyColor,
                                fontSize: 14,
                              ),
                              hintText: 'Enter your Last Name',
                              hintStyle: TextStyle(
                                color: greyColor,
                                fontSize: 14,
                              ),
                              contentPadding: const EdgeInsets.all(15),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8))),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      return validateEmail(value,
                          EmailValidator.validate(_emailController.text));
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: greyColor,
                          fontSize: 14,
                        ),
                        hintText: 'Enter your Email',
                        hintStyle: TextStyle(
                          color: greyColor,
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.all(15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    obscureText: obsecure,
                    controller: _passwordController,
                    validator: (value) {
                      return validatePassword(value, _passwordController.text);
                    },
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(
                              Icons.remove_red_eye_outlined,
                              color: obsecure ? greyColor : blackColor,
                            ),
                            onPressed: () {
                              setState(() {
                                obsecure = !obsecure;
                              });
                            }),
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: greyColor,
                          fontSize: 14,
                        ),
                        hintText: 'Enter Your Password',
                        hintStyle: TextStyle(
                          color: greyColor,
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.all(15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: _confirmPasswordController,
                    validator: (value) {
                      return validateSamePassword(
                          value, _passwordController.text);
                    },
                    decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(
                          color: greyColor,
                          fontSize: 14,
                        ),
                        hintText: 'Enter Your Confirm Password',
                        hintStyle: TextStyle(
                          color: greyColor,
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.all(15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  roundedButton(
                      context: context,
                      bgColor: primaryColor,
                      text: 'Sign Up',
                      textColor: whiteColor,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await authService.getAdminCredentialEmailAndPassword(
                              context: context,
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                              isLoginUser: false);
                        }
                      }),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            child: Text(
              'By Signing up you agree to our Terms and Conditions, and Privacy Policy',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: greyColor,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Or',
            style: TextStyle(
              fontSize: 18,
              color: greyColor,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const SignUpWidget(),
        ],
      ),
    );
  }
}

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) => const PhoneAuthScreen(
                          isFromLogin: false,
                        )));
          },
          child: CustomIconButton(
            text: 'Signup with Phone',
            imageIcon: 'assets/phone.png',
            bgColor: greyColor,
            imageOrIconColor: whiteColor,
            imageOrIconRadius: 20,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () async {
            User? user = await AuthService.signInWithGoogle(context: context);
            if (user != null) {
              authService.getAdminCredentialPhoneNumber(context, user);
            }
          },
          child: CustomIconButton(
            text: 'Signup with Google',
            imageIcon: 'assets/google.png',
            bgColor: whiteColor,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
