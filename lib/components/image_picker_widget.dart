import 'dart:io';

import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/constants/functions/functions.widgets.dart';
import 'package:bechdal_app/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({Key? key}) : super(key: key);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _image;
  bool _isUploading = false;
  String? downloadUrl;
  final List<XFile> _galleryImages = [];

  Future getImageFromCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _image = pickedImageFile;
    });
  }

  void getImageFromGallery() async {
    final pickedMultiImage = await ImagePicker().pickMultiImage();
    if (pickedMultiImage == null) {
      print('No images were selected');
      return;
    }
    setState(() {
      _galleryImages.addAll(pickedMultiImage);
    });
    if (kDebugMode) {
      print(_galleryImages);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (_image != null) ? null : 150,
      child: (_image != null)
          ? (_isUploading)
              ? CircularProgressIndicator(
                  color: blackColor,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      Stack(
                        children: [
                          Container(
                              height:
                                  MediaQuery.of(context).size.height / 2 - 150,
                              child: Image.file(
                                _image!,
                                width: double.infinity,
                                fit: BoxFit.contain,
                              ))
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            roundedButton(
                              width: 150,
                              heightPadding: 10,
                              onPressed: () {},
                              bgColor: Colors.grey[300],
                              textColor: blackColor,
                              borderColor: Colors.grey[300],
                              text: 'Save',
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            roundedButton(
                                width: 150,
                                heightPadding: 10,
                                onPressed: () {},
                                bgColor: Colors.grey[300],
                                textColor: blackColor,
                                borderColor: Colors.grey[300],
                                text: 'Cancel')
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 30),
                          child: roundedButton(
                              onPressed: () async {
                                setState(() {
                                  _isUploading = true;
                                });
                                await uploadFile(context, _image!.path)
                                    .then((value) {
                                  if (value != null && value.isNotEmpty) {
                                    setState(() {
                                      _isUploading = false;
                                      _image = null;
                                      downloadUrl = value;
                                    });
                                  }
                                });
                              },
                              bgColor: primaryColor,
                              text: 'Upload Image')),
                      const SizedBox(
                        height: 10,
                      )
                    ])
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => getImageFromCamera(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: blackColor,
                        radius: 30,
                        child: Icon(
                          Icons.camera_alt,
                          size: 30,
                          color: whiteColor,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text('Camera')
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => getImageFromGallery(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: blackColor,
                        radius: 30,
                        child: Icon(
                          Icons.add_photo_alternate,
                          size: 30,
                          color: whiteColor,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text('Gallery')
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
