import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditTouristPlaceForm extends StatefulWidget {
  final Map<String, dynamic> data;

  EditTouristPlaceForm({required this.data});

  @override
  _EditTouristPlaceFormState createState() => _EditTouristPlaceFormState();
}

class _EditTouristPlaceFormState extends State<EditTouristPlaceForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _placeNameController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;

  @override
  void initState() {
    super.initState();
    _placeNameController =
        TextEditingController(text: widget.data['place_name']);
    _latitudeController =
        TextEditingController(text: widget.data['latitude'].toString());
    _longitudeController =
        TextEditingController(text: widget.data['longitude'].toString());
  }

  Future<void> _updateTouristPlace() async {
    final String apiUrl =
        'http://localhost:81//API_mn/update_tourist_place.php';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "place_code": widget.data['code'].toString(),
        "place_name": _placeNameController.text,
        "latitude": _latitudeController.text,
        "longitude": _longitudeController.text,
      },
    );

    if (response.statusCode == 200) {
      Navigator.pop(context); // Go back to the previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update tourist place')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขสถานที่ท่องเที่ยว'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _placeNameController,
                decoration: InputDecoration(labelText: 'ชื่อสถานที่'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อสถานที่';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _latitudeController,
                decoration: InputDecoration(labelText: 'ละติจูด'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกละติจูด';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _longitudeController,
                decoration: InputDecoration(labelText: 'ลองจิจูด'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกลองจิจูด';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateTouristPlace,
                child: Text('อัปเดต'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
