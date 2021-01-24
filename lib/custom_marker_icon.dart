/// A package to use local image, network image and icons as google_maps_flutter's marker icon.
library custom_marker_icon;

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarkerIcon {
  static Future<Uint8List> _resize(Uint8List markerImageBytes, int size) async {
    Codec codec = await instantiateImageCodec(
      markerImageBytes,
      targetWidth: size,
    );
    FrameInfo frameInfo = await codec.getNextFrame();
    ByteData byteData = await frameInfo.image.toByteData(
      format: ImageByteFormat.png,
    );
    return byteData.buffer.asUint8List();
  }

  /// Create marker's icon from locally saved image.
  static Future<BitmapDescriptor> fromAssetImage(String path, int size) async {
    ByteData data = await rootBundle.load(path);
    Uint8List resizedImageBytes = await _resize(
      data.buffer.asUint8List(),
      size,
    );
    return BitmapDescriptor.fromBytes(resizedImageBytes);
  }

  /// Create marker's icon from remotely available image.
  static Future<BitmapDescriptor> fromNetworkImage(String url, int size) async {
    File markerImageFile = await DefaultCacheManager().getSingleFile(url);
    Uint8List markerImageBytes = await markerImageFile.readAsBytes();
    Uint8List resizedImageBytes = await _resize(
      markerImageBytes,
      size,
    );
    return BitmapDescriptor.fromBytes(resizedImageBytes);
  }

  /// Create marker's icon from material icons or font awesome icons.
  static Future<BitmapDescriptor> fromIcon(
      IconData icon, Color color, double size) async {
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          letterSpacing: 0.0,
          fontSize: size,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: color,
        ));
    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(size.round(), size.round());
    final bytes = await image.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
  }
}
