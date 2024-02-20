import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTouristPlaceForm extends StatefulWidget {
  @override
  _AddTouristPlaceFormState createState() => _AddTouristPlaceFormState();
}

class _AddTouristPlaceFormState extends State<AddTouristPlaceForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _placeNameController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  Future<void> _addTouristPlace() async {
    if (_formKey.currentState!.validate()) {
      String apiUrl = 'http://localhost:81/API_mn/add_tourist_places.php';
      Map<String, dynamic> requestBody = {
        'place_name': _placeNameController.text,
        'latitude': _latitudeController.text,
        'longitude': _longitudeController.text,
      };

      try {
        var response = await http.post(Uri.parse(apiUrl), body: requestBody);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('เพิ่มสถานที่ท่องเที่ยวสำเร็จ')),
          );
          Navigator.pop(context); // ปิดฟอร์มหลังจากเพิ่มสำเร็จ
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ไม่สามารถเพิ่มสถานที่ท่องเที่ยวได้')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มสถานที่ท่องเที่ยว'),
        backgroundColor: Colors.teal, // สีสันที่เข้ากับธีม
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _placeNameController,
                decoration: InputDecoration(labelText: 'ชื่อสถานที่'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'โปรดระบุชื่อสถานที่';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _latitudeController,
                decoration: InputDecoration(labelText: 'ละติจูด'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'โปรดระบุละติจูด';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _longitudeController,
                decoration: InputDecoration(labelText: 'ลองจิจูด'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'โปรดระบุลองจิจูด';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addTouristPlace,
                child: Text('เพิ่มสถานที่'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal, // สีปุ่มที่เข้ากับธีม
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
