import 'package:fluttercon_data_source/fluttercon_data_source.dart';

/// Helper method to de-serialize [Favorites] entity.
/// Used as a replacement since the built-in
/// [Favorites.fromJson] method does not return talk data.
Favorites favoritesFromJson(Map<String, dynamic> json) {
  return Favorites(
    id: json['id'] as String?,
    userId: json['userId'] as String?,
    talks: (json['talks'] as List?)
        ?.map((e) => FavoritesTalk.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
