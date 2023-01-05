import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'video_event.dart';
part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoBloc() : super(VideoState()) {
    on<ResetVideo>((event, emit) {
      try {
        emit(state.resetVideo());
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    on<SetVideo>((event, emit) {
      try {
        emit(_setVideo(event.localPathVideo));
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  _setVideo(String localPathVideo) {
    return VideoState(path: localPathVideo);
  }
}
