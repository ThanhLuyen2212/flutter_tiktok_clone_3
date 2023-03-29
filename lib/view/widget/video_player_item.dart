import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;

  VideoPlayerItem({super.key, required this.videoUrl});

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _controller;

  bool? isplaying;

  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = VideoPlayerController.network(widget.videoUrl);

    _initializeVideoPlayerFuture = _controller.initialize();

    _controller.setLooping(true);
    _controller.setVolume(1);
    _controller.play();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        body: InkWell(
      onTap: (() {
        setState(() {
          if (_controller.value.isPlaying) {
            _controller.pause();
            showIconsPause();
          } else {
            _controller.play();
            _controller.setVolume(1);
            _controller.setLooping(true);
          }
        });
      }),
      child: Stack(children: [
        FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ]),
    ));
  }

  Widget showIconsPause() {
    return Center(child: Icon(Icons.pause, size: 80, color: Colors.white));
  }

  Widget ShowIconPlay() {
    return Center(
      child: Icon(
        Icons.play_arrow,
        size: 80,
        color: Colors.white,
      ),
    );
  }
}
