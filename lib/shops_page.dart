import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'EditShopForm.dart';
import 'AddShopForm.dart';

class ShopsPage extends StatefulWidget {
  @override
  _ShopsPageState createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<Map<String, dynamic>>> _shopsData;

  Future<List<Map<String, dynamic>>> _fetchShopsData() async {
    final response = await http
        .get(Uri.parse('http://localhost:81/API_mn/select_shops.php'));

    if (response.statusCode == 200) {
      final List<dynamic> parsed = json.decode(response.body);
      return parsed.cast<Map<String, dynamic>>();
    } else {
      throw Exception('ไม่สามารถเชื่อมต่อข้อมูลได้ กรุณาตรวจสอบ');
    }
  }

  Future<void> _deleteShop(String shopCode) async {
    String apiUrl =
        'http://localhost:81/API_mn/delete_shops.php'; // Update the URL
    Map<String, dynamic> requestBody = {'shop_code': shopCode};

    try {
      var response = await http.post(Uri.parse(apiUrl), body: requestBody);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          _showSnackBar('ลบร้านค้าสำเร็จ');
          _refreshShopsData();
        } else {
          _showSnackBar('ไม่สามารถลบร้านค้าได้: ${responseData['message']}');
        }
      } else {
        _showSnackBar('ไม่สามารถลบร้านค้าได้: ${response.body}');
      }
    } catch (error) {
      _showSnackBar('เกิดข้อผิดพลาดในการเชื่อมต่อ: $error');
    }
  }

  void _refreshShopsData() {
    setState(() {
      _shopsData = _fetchShopsData();
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();
    _shopsData = _fetchShopsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('ร้านค้า'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _shopsData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('ไม่พบข้อมูลร้านค้า'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var shop = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(shop['shop_name'],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('รหัสร้าน: ${shop['shop_code']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditShopForm(shopData: shop),
                              ),
                            ).then((_) {
                              _refreshShopsData();
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('ยืนยันการลบ'),
                                  content:
                                      Text('คุณต้องการลบร้านค้านี้หรือไม่?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('ยกเลิก'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('ลบ'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        _deleteShop(shop['shop_code']);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddShopForm()),
          ).then((_) {
            _refreshShopsData();
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
