import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  final double latitude;
  final double longitude;

  const MapScreen({required this.latitude, required this.longitude, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Location on Map")),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(latitude, longitude),
          zoom: 14.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 100.0,
                height: 100.0,
                point: LatLng(latitude, longitude),
                child: _customMarkerWidget(),
              ),
            ],
          )

        ],
      ),
    );
  }
}
Widget _customMarkerWidget() {
  return Column(
    children: [
      Icon(Icons.location_pin, color: Colors.red, size: 40),
      Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          "Here!",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}

