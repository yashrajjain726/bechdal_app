import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  final Color bannerColor;
  final String heading;
  final List<String?> tagLines;
  final String buttonTextOne;
  final String buttonTextTwo;
  final String bannerImage;

  const BannerWidget(
      {Key? key,
      required this.bannerColor,
      required this.heading,
      required this.tagLines,
      required this.buttonTextOne,
      required this.buttonTextTwo,
      required this.bannerImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bannerHeight = MediaQuery.of(context).size.height * 0.25;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: bannerHeight,
      child: Card(
        color: bannerColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: bannerHeight - 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          heading,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: blackColor,
                            letterSpacing: 1,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 200,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: DefaultTextStyle(
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: blackColor,
                            ),
                            child: AnimatedTextKit(
                              repeatForever: true,
                              isRepeatingAnimation: true,
                              animatedTexts: [
                                FadeAnimatedText(
                                  tagLines[0] ?? '',
                                  duration: const Duration(
                                    seconds: 4,
                                  ),
                                ),
                                FadeAnimatedText(
                                  tagLines[1] ?? '',
                                  duration: const Duration(
                                    seconds: 4,
                                  ),
                                ),
                                FadeAnimatedText(
                                  tagLines[2] ?? '',
                                  duration: const Duration(
                                    seconds: 4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                        child: Align(
                      alignment: Alignment.center,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          bannerColor,
                          BlendMode.darken,
                        ),
                        child: Image.network(
                          bannerImage,
                        ),
                      ),
                    ))
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(whiteColor)),
                    child: Text(
                      buttonTextOne,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: blackColor,
                      ),
                    ),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(blackColor)),
                    child: Text(
                      buttonTextTwo,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: whiteColor,
                      ),
                    ),
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
