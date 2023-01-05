part of 'video_bloc.dart';

class VideoState {
  final String? path;

  VideoState({
    this.path,
  });

  VideoState copyVideo({
    String? path,
  }) =>
      VideoState(
        path: path ?? this.path,
      );

  VideoState resetVideo() {
    return VideoState(
      path: null,
    );
  }
}
