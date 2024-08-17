import 'package:equatable/equatable.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';

class SpeakerDetail extends Equatable {
  const SpeakerDetail({
    required this.id,
    required this.name,
    required this.title,
    required this.imageUrl,
    required this.bio,
    required this.links,
    required this.talks,
  });

  final String id;
  final String name;
  final String title;
  final String imageUrl;
  final String bio;
  final List<Link> links;
  final List<TalkPreview> talks;

  @override
  List<Object?> get props => [id, name, title, imageUrl, bio, links, talks];
}
