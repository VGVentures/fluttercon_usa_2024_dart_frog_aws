import 'package:equatable/equatable.dart';

class SpeakerPreview extends Equatable {
  const SpeakerPreview({
    required this.id,
    required this.name,
    required this.title,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final String title;
  final String imageUrl;

  @override
  List<Object?> get props => [id, name, title, imageUrl];
}
