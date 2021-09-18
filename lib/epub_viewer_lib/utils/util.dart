import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

enum EpubScrollDirection { HORIZONTAL, VERTICAL, ALLDIRECTIONS }

class Util {
  /// Get HEX code from [Colors], [MaterialColor],
  /// [Color] and [MaterialAccentColor]
  static String getHexFromColor(Color color) {
    return '#${color.toString().replaceAll('ColorSwatch(', '').replaceAll('Color(0xff', '').replaceAll('MaterialColor(', '').replaceAll('MaterialAccentColor(', '').replaceAll('primary value: Color(0xff', '').replaceAll('primary', '').replaceAll('value:', '').replaceAll(')', '').trim()}';
  }

  /// Convert [EpubScrollDirection] to FolioReader reader String
  static String getDirection(EpubScrollDirection direction) {
    switch (direction) {
      case EpubScrollDirection.VERTICAL:
        return 'vertical';
      case EpubScrollDirection.HORIZONTAL:
        return 'horizontal';
      case EpubScrollDirection.ALLDIRECTIONS:
        return 'alldirections';
      default:
        return 'alldirections';
    }
  }

  /// Create a temporary [File] from an asset epub
  /// to be opened by [EpubViewer]
  static Future<File> getFileFromAsset(String asset) async {
    ByteData data = await rootBundle.load(asset);
    Directory tempDir = await getTemporaryDirectory();
    String path = '${tempDir.path}/${basename(asset)}';
    final buffer = data.buffer;
    return File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
}
