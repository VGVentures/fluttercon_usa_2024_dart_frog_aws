import 'package:flutter/material.dart';

class TalkCard extends StatelessWidget {
  const TalkCard({
    required this.title,
    required this.speakerNames,
    required this.room,
    required this.onFavoriteTap,
    this.isFavorite = false,
    super.key,
  });

  final String title;
  final List<String> speakerNames;
  final String room;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(flex: 4, child: Text(title)),
                Flexible(
                  child: IconButton(
                    onPressed: onFavoriteTap,
                    icon: isFavorite
                        ? const Icon(Icons.favorite)
                        : const Icon(Icons.favorite_border),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    speakerNames.join(', '),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    room,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
