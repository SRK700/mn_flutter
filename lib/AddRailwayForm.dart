import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddRailwayForm extends StatefulWidget {
  @override
  _AddRailwayFormState createState() => _AddRailwayFormState();
}

class _AddRailwayFormState extends State<AddRailwayForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _carNumberController = TextEditingController();

  Future<void> _addRailway() async {
    final String apiUrl = 'http://localhost:81//API_mn/add_railway.php';

    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "code": _codeController.text,
          "car_number": _carNumberController.text,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เพิ่มข้อมูลรถรางสำเร็จ')),
        );

        // เมื่อเพิ่มข้อมูลสำเร็จให้กลับไปที่ RailwayPage
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('การเพิ่มข้อมูลล้มเหลว')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลรถราง'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(labelText: 'รหัสรถราง'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกรหัสรถราง';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _carNumberController,
                decoration: InputDecoration(labelText: 'หมายเลขรถราง'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกหมายเลขรถราง';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _addRailway,
                child: Text('เพิ่มรถราง'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
