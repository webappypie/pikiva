import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pikiva/features/samples/sample_repository.dart';

class JsonBundle extends CachingAssetBundle {
  JsonBundle(this.json);
  final String json;
  @override
  Future<String> loadString(String key, {bool cache = true}) async => json;
  @override
  Future<ByteData> load(String key) => throw UnimplementedError();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('bundled fixture is valid and every photo asset is available', () async {
    final photos = await BundledSampleRepository().load();
    expect(photos.length, 2);
    for (final photo in photos) {
      expect(
        (await rootBundle.load(photo.asset)).lengthInBytes,
        greaterThan(0),
      );
    }
    expect(() => photos.clear(), throwsUnsupportedError);
  });
  for (final invalid in [
    '{',
    '{"version":2,"photos":[]}',
    '{"version":1,"photos":[{"id":"x","asset":"https://example.com/private.jpg","group":"best"}]}',
    '{"version":1,"photos":[{"id":"x","asset":"assets/samples/coast.png","group":"unknown"}]}',
    '{"version":1,"photos":[{"id":"x","asset":"assets/samples/coast.png","group":"best"},{"id":"x","asset":"assets/samples/coast.png","group":"best"}]}',
  ]) {
    test(
      'rejects malformed, unknown or non-local sample data: $invalid',
      () async {
        await expectLater(
          BundledSampleRepository(bundle: JsonBundle(invalid)).load(),
          throwsFormatException,
        );
      },
    );
  }
}
