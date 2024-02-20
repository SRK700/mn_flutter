import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditRoute extends StatefulWidget {
  final int sequenceNumber;

  EditRoute({required this.sequenceNumber});

  @override
  _EditRouteState createState() => _EditRouteState();
}

class _EditRouteState extends State<EditRoute> {
  TextEditingController _placeCodeController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch data for the specific sequence number
    _fetchRouteData();
  }

  Future<void> _fetchRouteData() async {
    String apiUrl = 'http://localhost:81//API_mn/select_route.php';
    // You may need to modify the API to support fetching a specific route by sequence number
    // Modify the API accordingly to fetch a specific route based on the sequence number.
    try {
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> parsed = json.decode(response.body);
        // Find the route data for the specific sequence number
        Map<String, dynamic>? routeData = parsed.firstWhere(
          (data) =>
              int.parse(data['sequence_number'].toString()) ==
              widget.sequenceNumber,
          orElse: () => null,
        );

        if (routeData != null) {
          // Populate the controllers with fetched data
          _placeCodeController.text = routeData['place_code'].toString();
          _timeController.text = routeData['time'].toString();
        } else {
          // Handle case where route data is not found
          print(
              'Route data not found for sequence number ${widget.sequenceNumber}');
        }
      } else {
        print('Failed to fetch route data. ${response.body}');
      }
    } catch (error) {
      print('Error connecting to the server: $error');
    }
  }

  Future<void> _updateRoute() async {
    String apiUrl = 'http://localhost:81//API_mn/update_route.php';
    Map<String, dynamic> requestBody = {
      'sequence_number': widget.sequenceNumber.toString(),
      'place_code': _placeCodeController.text,
      'time': _timeController.text,
    };

    try {
      var response = await http.post(Uri.parse(apiUrl), body: requestBody);

      if (response.statusCode == 200) {
        print('Route updated successfully');
        // Navigate back to RoutePage after updating
        Navigator.pop(context);
      } else {
        print('Failed to update route. ${response.body}');
      }
    } catch (error) {
      print('Error connecting to the server: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Route'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _placeCodeController,
              decoration: InputDecoration(labelText: 'Place Code'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(labelText: 'Time'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateRoute,
              child: Text('Update Route'),
            ),
          ],
        ),
      ),
    );
  }
}
