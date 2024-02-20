import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GPSTracking extends StatefulWidget {
  @override
  _GPSTrackingState createState() => _GPSTrackingState();
}

class _GPSTrackingState extends State<GPSTracking> {
  GoogleMapController? mapController;
  List<Marker> markers = [];
  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:81/API_mn/getlocation.php'));

      if (response.statusCode == 200) {
        List<dynamic> locations = json.decode(response.body);
        _updateMarkersAndPolyline(locations);
      } else {
        throw Exception('Failed to load locations');
      }
    } catch (e) {
      print('Error fetching locations: $e');
    }
  }

  void _updateMarkersAndPolyline(List<dynamic> locations) {
    List<LatLng> polylineCoordinates = [];

    setState(() {
      markers.clear();
      polylines.clear();

      for (var location in locations) {
        final latLng = LatLng(double.parse(location['latitude']),
            double.parse(location['longitude']));
        markers.add(
          Marker(
            markerId: MarkerId(location['place_code'].toString()),
            position: latLng,
            infoWindow: InfoWindow(
              title: location['place_name'],
            ),
          ),
        );
        polylineCoordinates.add(latLng);
      }

      if (polylineCoordinates.length >= 2) {
        polylines.add(
          Polyline(
            polylineId: PolylineId("route"),
            color: Colors.blue,
            points: polylineCoordinates,
            width: 5,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GPS และสถานที่ท่องเที่ยวทั้งหมด'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(19.923251, 99.839061), // Adjust as needed
          zoom: 12,
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        markers: Set<Marker>.of(markers),
        polylines: polylines,
      ),
    );
  }
}
