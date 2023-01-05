import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:eventflutter/bloc/video/video_bloc.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:eventflutter/theme/color.dart' as color;
import 'package:uuid/uuid.dart';

class TrimmerView extends StatefulWidget {
  final File file;

  const TrimmerView(this.file, {Key? key}) : super(key: key);
  @override
  _TrimmerViewState createState() => _TrimmerViewState();
}

class _TrimmerViewState extends State<TrimmerView> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool _progressVisibility = false;
  bool _isInAsyncCall = false;
  @override
  void initState() {
    super.initState();

    _loadVideo();
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  _saveVideo() {
    setState(() {
      _progressVisibility = true;
    });
    var uuid = const Uuid();
    var nameVideo = uuid.v1();

    _trimmer.saveTrimmedVideo(
      startValue: _startValue,
      endValue: _endValue,
      videoFileName: nameVideo,
      onSave: (outputPath) {
        setState(() {
          _progressVisibility = false;
        });
        debugPrint('OUTPUT PATH: $outputPath');
        //registrar en el blocVideo
        final videoBloc = BlocProvider.of<VideoBloc>(context);
        videoBloc.add(SetVideo(outputPath!));
        Navigator.of(context).pop();
/*         Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Preview(outputPath),
          ),
        ); */
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          return true;
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.black,
            body: ModalProgressHUD(
              inAsyncCall: _isInAsyncCall,
              opacity: 0.5,
              progressIndicator: const Center(
                  child: CircularProgressIndicator(
                      color: color.primary,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(color.inActiveColor),
                      backgroundColor: color.shadowColor)),
              child: Stack(
                children: [
                  Builder(
                    builder: (context) => Center(
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Visibility(
                              visible: _progressVisibility,
                              child: const LinearProgressIndicator(
                                backgroundColor: Colors.red,
                              ),
                            ),
                            /*             ElevatedButton(
                              onPressed: _progressVisibility ? null : () => _saveVideo(),
                              child: const Text("SAVE"),
                            ), */
                            Expanded(
                              child: VideoViewer(trimmer: _trimmer),
                            ),
                            Center(
                              child: TrimViewer(
                                trimmer: _trimmer,
                                viewerHeight: 50.0,
                                viewerWidth: MediaQuery.of(context).size.width,
                                maxVideoLength: const Duration(seconds: 40),
                                onChangeStart: (value) {
                                  _startValue = value;
                                },
                                onChangeEnd: (value) {
                                  _endValue = value;
                                },
                                onChangePlaybackState: (value) {
                                  setState(() {
                                    _isPlaying = value;
                                  });
                                },
                              ),
                            ),
                            TextButton(
                              child: _isPlaying
                                  ? const Icon(
                                      Icons.pause,
                                      size: 80.0,
                                      color: Colors.white,
                                    )
                                  : const Icon(
                                      Icons.play_arrow,
                                      size: 80.0,
                                      color: Colors.white,
                                    ),
                              onPressed: () async {
                                bool playbackState =
                                    await _trimmer.videoPlaybackControl(
                                  startValue: _startValue,
                                  endValue: _endValue,
                                );
                                setState(() {
                                  _isPlaying = playbackState;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10.0,
                    left: 10.0,
                    child: FloatingActionButton(
                      heroTag: Icons.arrow_back.codePoint,
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: color.appBgColor,
                      child:
                          const Icon(Icons.arrow_back, color: color.mainColor),
                    ),
                  ),
                  Positioned(
                    top: 10.0,
                    right: 10.0,
                    //left: 100.0,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                        backgroundColor: color.appBarColor,
                        //onPrimary: Colors.white,
                        side: const BorderSide(
                            color: color.orangeDark, width: 2.0),
                      ),
                      onPressed:
                          _progressVisibility ? null : () => _saveVideo(),
                      child: const Text(
                        'Aceptar video',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: color.mainColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
