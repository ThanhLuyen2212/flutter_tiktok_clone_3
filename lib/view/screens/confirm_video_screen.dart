import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone_3/controller/upload_video_player.dart';
import 'package:flutter_tiktok_clone_3/view/widget/text_input_field.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_tiktok_clone_3/controller/edit_video_controller.dart';

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
  bool editAudio = false;
  bool reset = false;

  final MergeVideoWithAudio mergeVideoWithAudio =
      Get.put(MergeVideoWithAudio());
  late String output_video_path;

  TextEditingController _songController = TextEditingController();
  TextEditingController _captionController = TextEditingController();

  UploadVideoController uploadVideoController =
      Get.put(UploadVideoController());

  playVideo(File videoFile) {
    setState(() {
      controller = VideoPlayerController.file(videoFile);
      // ensure the first freame is shown after the video is initialized,
      // even before the play botton has been pressed

      controller.initialize();
      controller.play();
      controller.setVolume(1);
      controller.setLooping(true);
      //get video and initialize video to play
    });
  }

  String AUDIO_PATH = '';
  pickAudio(ImageSource src, BuildContext context) async {
    // final audio = await ImagePicker().pickVideo(source: src);
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      AUDIO_PATH = result.paths[0]!;
      File file = File(result.files.single.path!);
      Get.snackbar('Notification', 'you have picked a video');
    } else {
      Get.snackbar('Notification', 'you cant picked a video');
      // User canceled the picker
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playVideo(widget.videoFile);
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
            height: 50,
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
              height: MediaQuery.of(context).size.height / 1.1,
              child: VideoPlayer(controller),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Visibility(
            visible: !editAudio,
            child: SingleChildScrollView(
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
            ),
          ),
          Visibility(
            visible: editAudio,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('You want to replace audio of this video'),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          reset = !reset;
                        });
                        pickAudio(ImageSource.gallery, context);
                      },
                      child: Text('Choose audio file'),
                    ),
                    ElevatedButton(
                      onPressed: reset ? () {} : null,
                      child: Text('Merge'),
                    ),

                    // merge video with audio
                    GetBuilder<MergeVideoWithAudio>(
                      init: MergeVideoWithAudio(),
                      builder: (controller) {
                        if (controller.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ElevatedButton(
                          onPressed: (widget.videoPath != '' ||
                                  AUDIO_PATH != '')
                              ? () async {
                                  output_video_path =
                                      await mergeVideoWithAudio.mergeIntoVideo(
                                          widget.videoPath, AUDIO_PATH);
                                  if (output_video_path.isNotEmpty) {
                                    Get.snackbar('Notification', 'Conguratly');

                                    playVideo(File(output_video_path));
                                  }
                                }
                              : null,
                          child: Text('Reload'),
                        );
                      },
                    )
                  ]),
            ),
          ),
        ],
      )),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     setState(() {
      //       editAudio = !editAudio;
      //     });
      //   },
      //   label: Text(!editAudio ? 'Edit audio' : 'Save'),
      // ),
    );
  }
}
