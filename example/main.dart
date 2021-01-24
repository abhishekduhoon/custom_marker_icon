import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_marker_icon/custom_marker_icon.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CustomMarkerIconExample(),
    );
  }
}

class CustomMarkerIconExample extends StatefulWidget {
  @override
  _CustomMarkerIconExampleState createState() =>
      _CustomMarkerIconExampleState();
}

class _CustomMarkerIconExampleState extends State<CustomMarkerIconExample> {
  final LatLng _latLng = LatLng(28.7041, 77.1025);
  final double _zoom = 15.0;

  Set<Marker> _markers = {};

  void _addMarkers() async {
    BitmapDescriptor markerIcon = await CustomMarkerIcon.fromIcon(
      Icons.directions_walk,
      Colors.blue,
      100,
    );
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("marker_id"),
          position: _latLng,
          icon: markerIcon,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Marker Icon Example'),
        backgroundColor: Colors.red,
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _addMarkers();
        },
        markers: _markers,
        initialCameraPosition: CameraPosition(
          target: _latLng,
          zoom: _zoom,
        ),
      ),
    );
  }
}
