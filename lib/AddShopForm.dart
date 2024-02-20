import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddShopForm extends StatefulWidget {
  @override
  _AddShopFormState createState() => _AddShopFormState();
}

class _AddShopFormState extends State<AddShopForm> {
  final TextEditingController _shopNameController = TextEditingController();

  Future<void> _addShop() async {
    String apiUrl = 'http://localhost:81/API_mn/add_shops.php';
    Map<String, String> requestBody = {
      'shop_name': _shopNameController.text,
    };

    try {
      var response = await http.post(Uri.parse(apiUrl), body: requestBody);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ร้านค้าถูกเพิ่มเรียบร้อยแล้ว')),
          );
          Navigator.pop(context); // ปิดหน้า AddShopForm
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('เกิดข้อผิดพลาด: ${responseData['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ไม่สามารถเพิ่มร้านค้าได้: ${response.body}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มร้านค้า'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _shopNameController,
              decoration: InputDecoration(
                labelText: 'ชื่อร้านค้า',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _addShop,
              child: Text('บันทึก'),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                onPrimary: Colors.white, // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
