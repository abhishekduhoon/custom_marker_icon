library custom_marker_icon;

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
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

  static Future<BitmapDescriptor> fromAssetImage(String path, int size) async {
    ByteData data = await rootBundle.load(path);
    Uint8List resizedImageBytes = await _resize(
      data.buffer.asUint8List(),
      size,
    );
    return BitmapDescriptor.fromBytes(resizedImageBytes);
  }

  static Future<BitmapDescriptor> fromNetworkImage(String url, int size) async {
    File markerImageFile = await DefaultCacheManager().getSingleFile(url);
    Uint8List markerImageBytes = await markerImageFile.readAsBytes();
    Uint8List resizedImageBytes = await _resize(
      markerImageBytes,
      size,
    );
    return BitmapDescriptor.fromBytes(resizedImageBytes);
  }
}
