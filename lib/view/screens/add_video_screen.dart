import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone_3/constants.dart';
import 'package:flutter_tiktok_clone_3/view/screens/confirm_video_screen.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddVideoScreen extends StatelessWidget {
  const AddVideoScreen({super.key});

  pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    Get.snackbar('Notification', 'you have picked a video');
    // get video from anywhere when you call
    if (video != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ConfirmVideoScreen(
                videoFile: File(video.path),
                videoPath: video.path,
              )));
    }
  }

  showOptionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              children: [
                SimpleDialogOption(
                  onPressed: () => pickVideo(ImageSource.gallery, context),
                  child: Row(
                    children: const [
                      Icon(Icons.image),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Gallery",
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () => pickVideo(ImageSource.camera, context),
                  child: Row(
                    children: const [
                      Icon(Icons.image),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Camera",
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Row(
                    children: const [
                      Icon(Icons.cancel),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => showOptionDialog(context),
        child: Container(
          width: 190,
          height: 50,
          decoration: BoxDecoration(color: buttonColor),
          child: const Center(
            child: Text(
              'Add video',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      )),
    );
  }
}
