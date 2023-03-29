import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone_3/controller/upload_video_player.dart';
import 'package:flutter_tiktok_clone_3/view/widget/text_input_field.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ConfirmVideoScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  ConfirmVideoScreen(
      {super.key, required this.videoFile, required this.videoPath});

  @override
  State<ConfirmVideoScreen> createState() => _ConfirmVideoScreenState();
}

class _ConfirmVideoScreenState extends State<ConfirmVideoScreen> {
  late VideoPlayerController controller;

  TextEditingController _songController = TextEditingController();
  TextEditingController _captionController = TextEditingController();

  UploadVideoController uploadVideoController =
      Get.put(UploadVideoController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videoFile);
      // ensure the first freame is shown after the video is initialized,
      // even before the play botton has been pressed

      controller.initialize();
      controller.play();
      controller.setVolume(1);
      controller.setLooping(true);
      //get video and initialize video to play
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
    // ensure remove all temperator storage when finish confirm video
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: (() {
              setState(() {
                if (controller.value.isPlaying) {
                  controller.pause();
                } else {
                  controller.play();
                }
              });
            }),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.5,
              child: VideoPlayer(controller),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInputField(
                      controller: _songController,
                      labelText: 'Song name',
                      icon: Icons.music_note,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInputField(
                      controller: _captionController,
                      labelText: 'Caption',
                      icon: Icons.closed_caption,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      padding: const EdgeInsets.only(
                          left: 50, right: 50, top: 10, bottom: 10),
                    ),
                    onPressed: (() {
                      uploadVideoController.uploadVideo(_songController.text,
                          _captionController.text, widget.videoPath);
                    }),
                    child: const Text(
                      'Share',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  )
                ]),
          )
        ],
      )),
    );
  }
}
