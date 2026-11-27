import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedstyle/core/utils/mock_data.dart';

void main() {
  test('All asset images exist on disk and in assets directory', () {
    final missing = <String>[];

    for (final p in MockData.products) {
      for (final img in p.images) {
        if (img.startsWith('assets/') && !File(img).existsSync()) {
          missing.add('Product ${p.id} (${p.name}): $img');
        }
      }
    }

    for (final c in MockData.categories) {
      if (c.imageUrl != null &&
          c.imageUrl!.startsWith('assets/') &&
          !File(c.imageUrl!).existsSync()) {
        missing.add('Category ${c.id}: ${c.imageUrl}');
      }
    }

    for (final h in MockData.sampleTryOnHistory) {
      if (h.resultImageUrl != null &&
          h.resultImageUrl!.startsWith('assets/') &&
          !File(h.resultImageUrl!).existsSync()) {
        missing.add('History ${h.id} result: ${h.resultImageUrl}');
      }
      if (h.userPhotoUrl.startsWith('assets/') &&
          !File(h.userPhotoUrl).existsSync()) {
        missing.add('History ${h.id} user: ${h.userPhotoUrl}');
      }
    }

    expect(missing, isEmpty, reason: 'Found missing assets: ${missing.join(", ")}');
  });
}
