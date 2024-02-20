import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddRoutePage extends StatefulWidget {
  @override
  _AddRoutePageState createState() => _AddRoutePageState();
}

class _AddRoutePageState extends State<AddRoutePage> {
  String? _selectedPlaceCode;
  String? _selectedTime;

  List<String> _placeCodes = [];
  List<String> _times = ['08:00', '10:00', '12:00', '14:00', '16:00', '18:00'];

  @override
  void initState() {
    super.initState();
    _fetchPlaceCodes();
  }

  Future<void> _fetchPlaceCodes() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:81/API_mn/select_tourist_places.php'),
      );

      if (response.statusCode == 200) {
        List<dynamic> places = json.decode(response.body);
        setState(() {
          _placeCodes =
              places.map((place) => place['place_code'].toString()).toList();
        });
      } else {
        throw Exception('Failed to load place codes');
      }
    } catch (error) {
      print('Error fetching place codes: $error');
    }
  }

  Future<void> _addRoute() async {
    if (_selectedPlaceCode == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both a place code and a time.')),
      );
      return;
    }

    String apiUrl = 'http://localhost:81/API_mn/add_route.php';
    Map<String, String> requestBody = {
      'place_code': _selectedPlaceCode!,
      'time': _selectedTime!,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        if (result['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Route added successfully')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${result['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add the route')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while adding the route: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มเส้นทาง'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'รหัสสถานที่',
                border: OutlineInputBorder(),
              ),
              value: _selectedPlaceCode,
              onChanged: (newValue) {
                setState(() {
                  _selectedPlaceCode = newValue;
                });
              },
              items: _placeCodes.map((placeCode) {
                return DropdownMenuItem(
                  value: placeCode,
                  child: Text(placeCode),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'เวลา',
                border: OutlineInputBorder(),
              ),
              value: _selectedTime,
              onChanged: (newValue) {
                setState(() {
                  _selectedTime = newValue;
                });
              },
              items: _times.map((time) {
                return DropdownMenuItem(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _addRoute,
              child: Text('บันทึก'),
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
