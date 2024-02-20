import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditRailwayPage extends StatefulWidget {
  final Map<String, dynamic> data;

  EditRailwayPage({required this.data});

  @override
  _EditRailwayPageState createState() => _EditRailwayPageState();
}

class _EditRailwayPageState extends State<EditRailwayPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController carNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // กำหนดค่าเริ่มต้นให้กับตัวควบคุมด้วยข้อมูลที่ได้รับ
    carNumberController.text = widget.data['car_number'].toString();
  }

  Future<void> updateRailwayData() async {
    String apiUrl = 'http://localhost:81//API_mn/updateRailway.php';

    Map<String, dynamic> requestBody = {
      'code': widget.data['code'].toString(),
      'car_number': carNumberController.text,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // แสดงข้อความแจ้งเตือนเมื่ออัปเดตข้อมูลสำเร็จ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('อัปเดตข้อมูลรถรางสำเร็จ')),
        );

        // กลับไปยังหน้าก่อนหน้าหลังจากอัปเดตข้อมูลสำเร็จ
        Navigator.pop(context);
      } else {
        // แสดงข้อความแจ้งเตือนเมื่อมีข้อผิดพลาด
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ไม่สามารถอัปเดตข้อมูลได้')),
        );
      }
    } catch (error) {
      // แสดงข้อความแจ้งเตือนเมื่อเกิดข้อผิดพลาดในการเชื่อมต่อ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูลรถราง'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: carNumberController,
                decoration: InputDecoration(
                  labelText: 'หมายเลขรถราง',
                  icon: Icon(Icons.train),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกหมายเลขรถราง';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // หากฟอร์มถูกต้อง ให้เรียกฟังก์ชันอัปเดตข้อมูลรถราง
                    updateRailwayData();
                  }
                },
                child: Text('อัปเดต'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent, // สามารถปรับเปลี่ยนสีตามต้องการ
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EditRailwayPage(
        data: {'code': '001', 'car_number': '123'}), // ตัวอย่างข้อมูลเริ่มต้น
    theme: ThemeData(
      primarySwatch: Colors.blue, // ปรับเปลี่ยนธีมตามต้องการ
    ),
  ));
}
