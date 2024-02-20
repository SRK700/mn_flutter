import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'AddProductForm.dart';
import 'EditProductForm.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late Future<List<Map<String, dynamic>>> _productsData;

  @override
  void initState() {
    super.initState();
    _productsData = _fetchProductsData();
  }

  Future<List<Map<String, dynamic>>> _fetchProductsData() async {
    final response = await http
        .get(Uri.parse('http://localhost:81/API_mn/select_product.php'));

    if (response.statusCode == 200) {
      final List<dynamic> parsed = json.decode(response.body);
      return parsed.cast<Map<String, dynamic>>();
    } else {
      throw Exception('ไม่สามารถเชื่อมต่อข้อมูลได้ กรุณาตรวจสอบ');
    }
  }

  Future<void> _deleteProduct(int productCode) async {
    String apiUrl = 'http://localhost:81/API_mn/delete_product.php';
    Map<String, dynamic> requestBody = {'product_code': productCode.toString()};

    try {
      var response = await http.post(Uri.parse(apiUrl), body: requestBody);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('ลบสินค้าเรียบร้อยแล้ว')));
        setState(() {
          _productsData = _fetchProductsData();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ไม่สามารถลบสินค้าได้. ${response.body}')));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการสินค้า'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _productsData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('ไม่พบข้อมูลสินค้า'));
          } else {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var data = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  elevation: 5,
                  child: ListTile(
                    leading: Icon(Icons.store, color: Colors.teal),
                    title: Text(data['product_name'].toString(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        'รหัส: ${data['product_code']} - ราคา: ${data['selling_price']} บาท ต่อ:  ${data['unit_of_measure']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditProductForm(data: data)),
                            ).then((_) {
                              setState(() {
                                _productsData = _fetchProductsData();
                              });
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _deleteProduct(int.parse(data['product_code'])),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductForm()),
          ).then((_) {
            setState(() {
              _productsData = _fetchProductsData();
            });
          });
        },
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
      ),
    );
  }
}
