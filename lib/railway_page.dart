import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'AddRailwayForm.dart';
import 'EditRailway.dart';

class RailwayPage extends StatefulWidget {
  @override
  _RailwayPageState createState() => _RailwayPageState();
}

class _RailwayPageState extends State<RailwayPage> {
  late Future<List<Map<String, dynamic>>> _railwayData;

  Future<List<Map<String, dynamic>>> _fetchRailwayData() async {
    final response = await http
        .get(Uri.parse('http://localhost:81//API_mn/selectRailway.php'));
    if (response.statusCode == 200) {
      final List<dynamic> parsed = json.decode(response.body);
      return parsed.cast<Map<String, dynamic>>();
    } else {
      throw Exception('ไม่สามารถเชื่อมต่อข้อมูลได้ กรุณาตรวจสอบ');
    }
  }

  Future<void> _deleteRailway(String code) async {
    final response = await http.post(
      Uri.parse('http://localhost:81//API_mn/deleteRailway.php'),
      body: {'code': code},
    );

    if (response.statusCode == 200) {
      setState(() {
        _railwayData = _fetchRailwayData();
      });
    } else {
      print('การลบข้อมูลล้มเหลว. ${response.body}');
    }
  }

  @override
  void initState() {
    super.initState();
    _railwayData = _fetchRailwayData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รถราง', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade400,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _railwayData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('ไม่พบข้อมูล'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var data = snapshot.data![index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: Icon(Icons.train, color: Colors.blue.shade400),
                    title: Text('หมายเลขรถ: ${data['car_number']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditRailwayPage(data: data),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _deleteRailway(data['code'].toString()),
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
            MaterialPageRoute(builder: (context) => AddRailwayForm()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue.shade400,
      ),
    );
  }
}
