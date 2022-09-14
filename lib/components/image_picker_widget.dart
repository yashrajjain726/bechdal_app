import 'dart:io';

import 'package:bechdal_app/constants/colors.dart';
import 'package:bechdal_app/provider/category_provider.dart';
import 'package:bechdal_app/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({Key? key}) : super(key: key);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _image;
  final picker = ImagePicker();
  bool isUploading = false;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No Image Selected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context);
    return Container(
      height: _image != null
          ? isUploading
              ? 150
              : 420
          : _provider.imageUploadedUrls.isNotEmpty
              ? 320
              : 320,
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          (_image != null)
              ? SizedBox(
                  height: isUploading ? 100 : 300,
                  child: isUploading
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: secondaryColor,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                                'Uploading your image to the database ...')
                          ],
                        )
                      : Image.file(_image!),
                )
              : (_provider.imageUploadedUrls.isNotEmpty)
                  ? Expanded(
                      child: GalleryImage(
                          titleGallery: 'Uploaded Images',
                          numOfShowImages: _provider.imageUploadedUrls.length,
                          imageUrls: _provider.imageUploadedUrls),
                    )
                  : Icon(
                      CupertinoIcons.photo_on_rectangle,
                      size: 200,
                      color: disabledColor,
                    ),
          const SizedBox(
            height: 20,
          ),
          (_image == null)
              ? Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: getImage,
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 20)),
                                backgroundColor:
                                    MaterialStateProperty.all(secondaryColor)),
                            child: const Text('Select Image')),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                )
              : (isUploading)
                  ? SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isUploading = true;
                                  uploadFile(context, _image!.path).then((url) {
                                    if (url != null) {
                                      _provider.setImageList(url);
                                      setState(() {
                                        isUploading = false;
                                        _image = null;
                                      });
                                    }
                                  });
                                });
                              },
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 20)),
                                  backgroundColor:
                                      MaterialStateProperty.all(blackColor)),
                              child: const Text('Upload Image')),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _image = null;
                                  });
                                },
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 20)),
                                    backgroundColor:
                                        MaterialStateProperty.all(blackColor)),
                                child: const Text('Cancel')))
                      ],
                    ),
        ],
      ),
    );
  }
}
