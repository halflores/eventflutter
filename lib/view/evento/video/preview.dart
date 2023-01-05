import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Preview extends StatefulWidget {
  final String? outputVideoPath;

  const Preview(this.outputVideoPath, {Key? key}) : super(key: key);

  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  late VideoPlayerController _controller;
  bool isInicialized = false;

  @override
  void initState() {
    super.initState();
    debugPrint(
        'OUTPUT PATH PREVIEW: ${widget.outputVideoPath!.replaceAll(',', '')}');
    _controller = VideoPlayerController.network(
        widget.outputVideoPath!.replaceAll(',', ''))
      ..addListener(() {})
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {});
        isInicialized = true;
        _controller.play();
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
/*       appBar: AppBar(
        title: const Text("Preview"),
      ), */
        body: isInicialized
            ? Center(
                child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: _controller.value.isInitialized
                        ? VideoPlayer(_controller)
                        : const Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                          )),
              )
            : const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              ));
  }
}
