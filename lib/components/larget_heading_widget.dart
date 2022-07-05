import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/screens/login_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LargeHeadingWidget extends StatefulWidget {
  final String heading;
  final double? headingTextSize;
  final Color? headingTextColor;
  final String subHeading;
  final double? subheadingTextSize;
  final Color? subheadingTextColor;
  final String? anotherTaglineText;
  final Color? anotherTaglineColor;
  final bool? taglineNavigation;

  const LargeHeadingWidget(
      {Key? key,
      required this.heading,
      required this.subHeading,
      this.subheadingTextSize,
      this.headingTextSize,
      this.subheadingTextColor,
      this.headingTextColor,
      this.anotherTaglineText,
      this.anotherTaglineColor,
      this.taglineNavigation})
      : super(key: key);

  @override
  State<LargeHeadingWidget> createState() => _LargeHeadingWidgetState();
}

class _LargeHeadingWidgetState extends State<LargeHeadingWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                widget.heading,
                style: TextStyle(
                    color: widget.headingTextColor ?? blackColor,
                    fontSize: widget.headingTextSize ?? 40,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: RichText(
                text: TextSpan(
                    text: widget.subHeading,
                    style: TextStyle(
                      color: widget.subheadingTextColor ?? greyColor,
                      fontSize: widget.subheadingTextSize ?? 25,
                    ),
                    children: [
                      widget.anotherTaglineText != null
                          ? TextSpan(
                              recognizer: new TapGestureRecognizer()
                                ..onTap = widget.taglineNavigation != null
                                    ? () {
                                        Navigator.pushReplacementNamed(
                                            context, LoginScreen.screenId);
                                      }
                                    : () {},
                              text: widget.anotherTaglineText,
                              style: TextStyle(
                                color: widget.anotherTaglineColor ?? greyColor,
                                fontSize: widget.subheadingTextSize ?? 25,
                              ),
                            )
                          : TextSpan(),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
