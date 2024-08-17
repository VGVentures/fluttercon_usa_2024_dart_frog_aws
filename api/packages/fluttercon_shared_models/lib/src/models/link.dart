import 'package:equatable/equatable.dart';

enum LinkType {
  github,
  linkedIn,
  twitter,
  other,
}

class Link extends Equatable {
  const Link({
    required this.id,
    required this.url,
    required this.type,
    this.description,
  });

  final String id;
  final String url;
  final LinkType type;
  final String? description;

  @override
  List<Object?> get props => [id, url, type, description];
}
