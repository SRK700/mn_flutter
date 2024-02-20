import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Shop {
  final String shopCode;
  final String shopName;

  Shop({required this.shopCode, required this.shopName});

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      shopCode: json['shop_code'],
      shopName: json['shop_name'],
    );
  }
}

class AddProductForm extends StatefulWidget {
  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _selectedShopCode;
  List<Shop> _shops = [];

  @override
  void initState() {
    super.initState();
    _fetchShopData();
  }

  Future<void> _fetchShopData() async {
    const url =
        'http://localhost:81//API_mn/select_shops.php'; // เปลี่ยนเป็น API endpoint ของคุณ
    try {
      final response = await http.get(Uri.parse(url));
      final List<dynamic> shopList = json.decode(response.body);
      setState(() {
        _shops = shopList.map((shop) => Shop.fromJson(shop)).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการดึงข้อมูลร้านค้า: $e')),
      );
    }
  }

  Future<void> _addProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedShopCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณาเลือกร้านค้า')),
      );
      return;
    }

    const url =
        'http://localhost:81//API_mn/crud_product.php'; // เปลี่ยนเป็น API endpoint ของคุณ
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'shop_code': _selectedShopCode,
          'product_name': _productNameController.text,
          'unit_of_measure': _unitController.text,
          'selling_price': _priceController.text,
        }),
      );

      final result = json.decode(response.body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เพิ่มสินค้าสำเร็จ'),
            action: SnackBarAction(
              label: 'กลับไปยังรายการสินค้า',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        );
        _formKey.currentState!.reset();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('เกิดข้อผิดพลาดจาก API: ${result['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการเพิ่มสินค้า: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เพิ่มสินค้าใหม่')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('เลือกร้านค้า',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                value: _selectedShopCode,
                onChanged: (value) => setState(() => _selectedShopCode = value),
                items: _shops
                    .map((Shop shop) => DropdownMenuItem(
                          value: shop.shopCode,
                          child: Text(shop.shopName),
                        ))
                    .toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
                validator: (value) =>
                    value == null ? 'กรุณาเลือกร้านค้า' : null,
              ),
              SizedBox(height: 20),
              Text('หน่วยนับ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _unitController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'กรุณากรอกหน่วยนับ' : null,
              ),
              SizedBox(height: 20),
              Text('ชื่อสินค้า',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'กรุณากรอกชื่อสินค้า'
                    : null,
              ),
              SizedBox(height: 20),
              Text('ราคาขาย',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกราคาขาย';
                  }
                  if (double.tryParse(value) == null) {
                    return 'กรุณากรอกข้อมูลเป็นตัวเลข';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _addProduct,
                  child: Text('บันทึก'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: AddProductForm()));
