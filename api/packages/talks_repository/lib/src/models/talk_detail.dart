import 'package:equatable/equatable.dart';

class TalkPreview extends Equatable {
  const TalkPreview({
    required this.id,
    required this.title,
    required this.room,
    required this.startTime,
    required this.speakers,
  });

  final String id;
  final String title;
  final String room;
  final DateTime startTime;
  final List<String> speakers;

  @override
  List<Object?> get props => [id, title, room, startTime, speakers];
}
