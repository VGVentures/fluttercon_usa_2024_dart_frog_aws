import 'package:amplify_core/amplify_core.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:test/test.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('paginatedResultFromJson', () {
    test('returns a PaginatedResult with the given type', () {
      final speakerJson = TestHelpers.speaker.toJson();

      final result = paginatedResultFromJson({
        'items': [speakerJson],
        'nextToken': 'nextToken',
      }, Speaker.classType);

      expect(result.items, equals([TestHelpers.speaker]));
      expect(result.nextToken, equals('nextToken'));
    });
  });
}
