import 'dart:io';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class EditVideoController extends GetxController {
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

  void _extractAudio(String inputPath, String outputPath) async {
    // inputPath = '/path/to/video.mp4';
    // outputPath = '/path/to/audio.mp3';

    final arguments = '-i $inputPath -vn -acodec copy $outputPath';

    final int rc = await _flutterFFmpeg.execute(arguments);
    if (rc == 0) {
      print('Audio extraction completed successfully');
      final outputFile = File(outputPath);
      if (await outputFile.exists()) {
        // Do something with the extracted audio file
      }
    } else {
      print('Audio extraction failed with rc=$rc.');
    }
  }
}

class MergeVideoWithAudio extends GetxController {
  bool loading = false, isPlaying = false;
  dynamic limit = 20;
  late double startTime = 0, endTime = 20;

  void setTimeLimit(dynamic value) async {
    limit = value;
  }

  Future<String> mergeIntoVideo(String VIDEO_PATH, String AUDIO_PATH) async {
    final String OUTPUT_PATH = '/storage/emulated/0/Download/output.mp4';
    final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
    loading = true;
    String timeLimit = '00:00:';

    if (await Permission.storage.request().isGranted) {
      if (limit.toInt() < 10)
        timeLimit = timeLimit + '0' + limit.toString();
      else
        timeLimit = timeLimit + limit.toString();

      /// To combine audio with video
      ///
      /// Merging video and audio, with audio re-encoding
      /// -c:v copy -c:a aac
      ///
      /// Copying the audio without re-encoding
      /// -c copy
      ///
      /// Replacing audio stream
      /// -c:v copy -c:a aac -map 0:v:0 -map 1:a:0
      String commandToExecute =
          '-r 15 -f mp4 -i ${VIDEO_PATH} -f mp3 -i ${AUDIO_PATH} -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -t $timeLimit -y ${OUTPUT_PATH}';

      /// To combine audio with image
      // String commandToExecute =
      //     '-r 15 -f mp3 -i ${Constants.AUDIO_PATH} -f image2 -i ${Constants.IMAGE_PATH} -pix_fmt yuv420p -t $timeLimit -y ${Constants.OUTPUT_PATH}';

      /// To combine audio with gif
      // String commandToExecute = '-r 15 -f mp3 -i ${Constants
      //     .AUDIO_PATH} -f gif -re -stream_loop 5 -i ${Constants.GIF_PATH} -y ${Constants
      //     .OUTPUT_PATH}';

      /// To combine audio with sequence of images
      // String commandToExecute = '-r 30 -pattern_type sequence -start_number 01 -f image2 -i ${Constants
      //     .IMAGES_PATH} -f mp3 -i ${Constants.AUDIO_PATH} -y ${Constants
      //     .OUTPUT_PATH}';

      await _flutterFFmpeg.execute(commandToExecute).then((rc) {
        loading = false;
        print('FFmpeg process exited with rc: $rc');
        // controller = VideoPlayerController.asset(Constants.OUTPUT_PATH)
        //   ..initialize().then((_) {
        //     notifyListeners();
        //   });
      });

      await _flutterFFmpeg.execute(commandToExecute).then((value) async {});
    } else if (await Permission.storage.isPermanentlyDenied) {
      loading = false;
    }
    return OUTPUT_PATH;
  }
}
