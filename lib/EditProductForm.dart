import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditProductForm extends StatefulWidget {
  final Map<String, dynamic> data;

  EditProductForm({required this.data});

  @override
  _EditProductFormState createState() => _EditProductFormState();
}

class _EditProductFormState extends State<EditProductForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController productNameController = TextEditingController();
  TextEditingController unitOfMeasureController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // กำหนดค่าเริ่มต้นให้กับตัวควบคุมด้วยข้อมูลที่มีอยู่
    productNameController.text = widget.data['product_name'].toString();
    unitOfMeasureController.text = widget.data['unit_of_measure'].toString();
    sellingPriceController.text = widget.data['selling_price'].toString();
  }

  Future<void> updateProductData() async {
    String productCode = widget.data['product_code'].toString();
    String productName = productNameController.text;
    String unitOfMeasure = unitOfMeasureController.text;
    String sellingPrice = sellingPriceController.text;

    String apiUrl = 'http://localhost:81//API_mn/update_product.php';

    Map<String, dynamic> requestBody = {
      'product_code': productCode,
      'product_name': productName,
      'unit_of_measure': unitOfMeasure,
      'selling_price': sellingPrice,
    };

    try {
      var response = await http.post(Uri.parse(apiUrl), body: requestBody);

      if (response.statusCode == 200) {
        // แสดงข้อความแจ้งเตือนเมื่ออัปเดตสินค้าสำเร็จ
        print('อัปเดตสินค้าเรียบร้อยแล้ว');

        // หลังจากอัปเดตสำเร็จ กลับไปยังหน้าก่อนหน้า
        Navigator.pop(context);
      } else {
        // แสดงข้อความแจ้งเตือนเมื่อมีข้อผิดพลาด
        print('การอัปเดตสินค้าล้มเหลว. ${response.body}');
      }
    } catch (error) {
      // แสดงข้อความแจ้งเตือนเมื่อเกิดข้อผิดพลาดในการเชื่อมต่อ
      print('เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขสินค้า'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: productNameController,
                decoration: InputDecoration(
                  labelText: 'ชื่อสินค้า',
                  icon: Icon(Icons.shopping_bag),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อสินค้า';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: unitOfMeasureController,
                decoration: InputDecoration(
                  labelText: 'หน่วยวัด',
                  icon: Icon(Icons.straighten),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกหน่วยวัด';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: sellingPriceController,
                decoration: InputDecoration(
                  labelText: 'ราคาขาย',
                  icon: Icon(Icons.monetization_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกราคาขาย';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // หากฟอร์มถูกต้อง ให้เรียกฟังก์ชันเพื่ออัปเดตข้อมูลสินค้า
                    updateProductData();
                  }
                },
                child: Text('อัปเดต'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent,
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
