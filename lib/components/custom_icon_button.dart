import 'package:bechdal_app/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final String? text;
  final String? imageIcon;
  final IconData? icon;
  final Color? imageOrIconColor;
  final double? imageOrIconRadius;
  final Color? bgColor;
  final EdgeInsets? padding;
  const CustomIconButton({
    Key? key,
    this.text,
    this.imageIcon,
    this.icon,
    this.imageOrIconColor,
    this.imageOrIconRadius,
    this.bgColor,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: bgColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: Padding(
          padding:
              padding ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageIcon != null
                  ? Container(
                      height: 25,
                      margin: const EdgeInsets.only(left: 20),
                      child: Image.asset(
                        imageIcon!,
                        color: imageOrIconColor,
                        height: imageOrIconRadius,
                        width: imageOrIconRadius,
                      ))
                  : Container(),
              icon != null
                  ? Container(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        icon,
                        size: imageOrIconRadius,
                        color: imageOrIconColor ?? whiteColor,
                      ),
                    )
                  : Container(),
              const SizedBox(
                width: 10,
              ),
              text != null
                  ? Container(
                      alignment: Alignment.center,
                      child: Text(
                        text!,
                        style: TextStyle(
                          color:
                              (bgColor == whiteColor) ? blackColor : whiteColor,
                          fontSize: 15,
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ));
  }
}
