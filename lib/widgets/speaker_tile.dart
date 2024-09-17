import 'package:flutter/material.dart';

class SpeakerTile extends StatelessWidget {
  const SpeakerTile({
    required this.name,
    required this.title,
    required this.imageUrl,
    required this.onTap,
    super.key,
  });

  final String name;
  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(name),
        subtitle: Text(title),
        onTap: onTap,
      ),
    );
  }
}
