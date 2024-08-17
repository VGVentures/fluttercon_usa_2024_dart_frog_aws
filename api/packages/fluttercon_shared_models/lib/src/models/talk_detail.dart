import 'package:equatable/equatable.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';

class TalkDetail extends Equatable {
  const TalkDetail({
    required this.id,
    required this.title,
    required this.room,
    required this.startTime,
    required this.speakers,
    required this.description,
  });

  final DateTime startTime;
  final List<SpeakerPreview> speakers;
  final String description;
  final String id;
  final String room;
  final String title;

  @override
  List<Object?> get props => [
        id,
        title,
        room,
        startTime,
        speakers,
        description,
      ];
}
