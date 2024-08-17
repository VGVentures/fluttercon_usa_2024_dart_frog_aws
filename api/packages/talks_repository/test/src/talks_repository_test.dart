// ignore_for_file: prefer_const_constructors
import 'package:talks_repository/talks_repository.dart';
import 'package:test/test.dart';

void main() {
  group('TalksRepository', () {
    test('can be instantiated', () {
      expect(TalksRepository(), isNotNull);
    });
  });
}
