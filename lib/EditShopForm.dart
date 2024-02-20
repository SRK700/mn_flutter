import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditShopForm extends StatefulWidget {
  final Map<String, dynamic> shopData;

  EditShopForm({required this.shopData});

  @override
  _EditShopFormState createState() => _EditShopFormState();
}

class _EditShopFormState extends State<EditShopForm> {
  late TextEditingController _shopNameController;

  @override
  void initState() {
    super.initState();
    // Initialize the text controller with the current shop name
    _shopNameController =
        TextEditingController(text: widget.shopData['shop_name']);
  }

  Future<void> _editShop() async {
    String apiUrl = 'http://localhost:81//API_mn/update_shops.php';
    Map<String, String> requestBody = {
      'shop_code': widget.shopData['shop_code'],
      'shop_name': _shopNameController.text,
    };

    try {
      var response = await http.post(Uri.parse(apiUrl), body: requestBody);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ร้านค้าถูกแก้ไขเรียบร้อยแล้ว')),
          );
          Navigator.pop(context); // Close the EditShopForm page
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('เกิดข้อผิดพลาด: ${responseData['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ไม่สามารถแก้ไขร้านค้าได้: ${response.body}')),
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
        title: Text('แก้ไขร้านค้า'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _shopNameController,
              decoration: InputDecoration(labelText: 'ชื่อร้านค้า'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _editShop,
              child: Text('บันทึกการแก้ไข'),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context)
                    .primaryColor, // Adjust button color to match the theme
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    super.dispose();
  }
}
