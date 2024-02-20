import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'AddTouristPlaceForm.dart';
import 'EditTouristPlaceForm.dart';

class TouristPlacesPage extends StatefulWidget {
  @override
  _TouristPlacesPageState createState() => _TouristPlacesPageState();
}

class _TouristPlacesPageState extends State<TouristPlacesPage> {
  late Future<List<Map<String, dynamic>>> _placesData;

  Future<List<Map<String, dynamic>>> _fetchPlacesData() async {
    final response = await http.get(
        Uri.parse('http://localhost:81//API_mn/select_tourist_places.php'));

    if (response.statusCode == 200) {
      final List<dynamic> parsed = json.decode(response.body);
      return parsed.cast<Map<String, dynamic>>();
    } else {
      throw Exception('ไม่สามารถโหลดข้อมูลสถานที่ท่องเที่ยวได้');
    }
  }

  Future<void> _deletePlace(int placeCode) async {
    String apiUrl = 'http://localhost:81//API_mn/delete_tourist_places.php';
    Map<String, dynamic> requestBody = {'place_code': placeCode.toString()};

    try {
      var response = await http.post(Uri.parse(apiUrl), body: requestBody);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ลบสถานที่ท่องเที่ยวสำเร็จ')),
        );
        _refreshPlacesData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ไม่สามารถลบสถานที่ท่องเที่ยวได้')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์')),
      );
    }
  }

  void _refreshPlacesData() {
    setState(() {
      _placesData = _fetchPlacesData();
    });
  }

  @override
  void initState() {
    super.initState();
    _placesData = _fetchPlacesData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สถานที่ท่องเที่ยว'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _placesData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('ไม่พบสถานที่ท่องเที่ยว'));
          } else {
            return RefreshIndicator(
              onRefresh: _fetchPlacesData,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var place = snapshot.data![index];
                  return Card(
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      leading: Icon(Icons.place),
                      title: Text(place['place_name']),
                      subtitle: Text(
                          'ละติจูด: ${place['latitude']}, ลองจิจูด: ${place['longitude']}'),
                      trailing: Wrap(
                        spacing: 12,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditTouristPlaceForm(data: place),
                                ),
                              ).then((_) => _refreshPlacesData());
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
                                    content: Text(
                                        'คุณต้องการลบสถานที่ท่องเที่ยวนี้หรือไม่?'),
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
                                          _deletePlace(
                                              int.parse(place['place_code']));
                                          Navigator.of(context).pop();
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
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTouristPlaceForm()),
          ).then((_) => _refreshPlacesData());
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
