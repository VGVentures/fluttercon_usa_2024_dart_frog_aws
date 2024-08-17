import 'package:equatable/equatable.dart';

enum SpeakerLinkType {
  github,
  linkedIn,
  twitter,
  other,
}

class SpeakerLink extends Equatable {
  const SpeakerLink({
    required this.id,
    required this.url,
    required this.type,
    this.description,
  });

  final String id;
  final String url;
  final SpeakerLinkType type;
  final String? description;

  @override
  List<Object?> get props => [id, url, type, description];
}
