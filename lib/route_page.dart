import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'addRoute.dart'; // ตรวจสอบให้แน่ใจว่าได้เชื่อมโยงกับหน้าเพิ่มเส้นทาง
import 'editRoute.dart'; // ตรวจสอบให้แน่ใจว่าได้เชื่อมโยงกับหน้าแก้ไขเส้นทาง

class RoutePage extends StatefulWidget {
  @override
  _RoutePageState createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  late Future<List<Map<String, dynamic>>> _routeData;

  Future<List<Map<String, dynamic>>> _fetchRouteData() async {
    final response = await http
        .get(Uri.parse('http://localhost:81/API_mn/select_route.php'));
    if (response.statusCode == 200) {
      final List<dynamic> parsed = json.decode(response.body);
      return parsed.cast<Map<String, dynamic>>();
    } else {
      throw Exception('ไม่สามารถโหลดข้อมูลเส้นทางได้');
    }
  }

  void _addRoute() {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddRoutePage()))
        .then((_) => setState(() => _routeData = _fetchRouteData()));
  }

  void _editRoute(int sequenceNumber) {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    EditRoute(sequenceNumber: sequenceNumber)))
        .then((_) => setState(() => _routeData = _fetchRouteData()));
  }

  void _deleteRoute(int sequenceNumber) async {
    final isConfirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ยืนยันการลบ'),
        content: Text('คุณแน่ใจหรือไม่ที่จะลบเส้นทางนี้?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('ยกเลิก')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('ลบ')),
        ],
      ),
    );

    if (isConfirmed ?? false) {
      String apiUrl = 'http://localhost:81/API_mn/delete_route.php';
      Map<String, dynamic> requestBody = {
        'sequence_number': sequenceNumber.toString()
      };
      try {
        var response = await http.post(Uri.parse(apiUrl), body: requestBody);
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('ลบเส้นทางสำเร็จ')));
          setState(() => _routeData = _fetchRouteData());
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('ไม่สามารถลบเส้นทางได้')));
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์: $error')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _routeData = _fetchRouteData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลเส้นทาง'),
        backgroundColor: Colors.teal, // เพิ่มสีสันให้กับแอพ
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: _addRoute,
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _routeData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('ไม่พบข้อมูลเส้นทาง'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var data = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.directions, color: Colors.teal),
                    title: Text('ลำดับที่: ${data['sequence_number']}'),
                    subtitle: Text(
                        'รหัสสถานที่: ${data['place_code']}, เวลา: ${data['time']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () =>
                              _editRoute(int.parse(data['sequence_number'])),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _deleteRoute(int.parse(data['sequence_number'])),
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
        onPressed: _addRoute,
        child: Icon(Icons.add),
        backgroundColor: Colors.teal, // เพิ่มสีสันให้กับปุ่ม
      ),
    );
  }
}
