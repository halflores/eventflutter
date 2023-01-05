part of 'video_bloc.dart';

@immutable
abstract class VideoEvent {}

class ResetVideo extends VideoEvent {}

class SetVideo extends VideoEvent {
  final String localPathVideo;
  SetVideo(this.localPathVideo);
}
