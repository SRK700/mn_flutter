import 'package:flutter/material.dart';
import 'railway_page.dart';
import 'products_page.dart';
import 'shops_page.dart';
import 'tourist_places.dart';
import 'route_page.dart';
import 'mn_location.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เมนู'),
        backgroundColor: Colors.deepPurple, // ปรับเปลี่ยนสีของ AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // เพิ่ม padding รอบ body
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            childAspectRatio:
                0.85, // ปรับ childAspectRatio เพื่อควบคุมขนาดของแต่ละ item
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Card(
              // ใช้ Card แทน Container เพื่อให้มีลักษณะนูน
              shape: RoundedRectangleBorder(
                // กำหนดรูปแบบขอบของ Card
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 5.0, // เพิ่มเงาให้ Card
              child: InkWell(
                // ใช้ InkWell แทน GestureDetector เพื่อให้มี effect ที่สวยงามเมื่อกด
                onTap: () {
                  // Handle icon tap and navigate to the respective screens
                  switch (index) {
                    case 0:
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RailwayPage()));
                      break;
                    case 1:
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TouristPlacesPage()));
                      break;
                    case 2:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RoutePage()),
                      );
                      break;
                    case 3:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShopsPage()),
                      );
                      break;
                    case 4:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductsPage()),
                      );
                      break;
                    case 5:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GPSTracking()),
                      );
                      break;
                    default:
                      break;

                    // สามารถเพิ่มการนำทางไปยังหน้าอื่นๆ ตาม index ได้ที่นี่
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'Images/icon${index + 1}.png',
                      width: 80.0, // ปรับขนาดของรูปภาพ
                      height: 80.0,
                    ),
                    SizedBox(height: 12.0), // ปรับขนาดของช่องว่าง
                    Text(
                      getMenuTitle(index),
                      style: TextStyle(
                        color: Colors.deepPurple, // ปรับสีของข้อความ
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0, // ปรับขนาดของข้อความ
                      ),
                      textAlign: TextAlign.center, // จัดข้อความให้อยู่ตรงกลาง
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String getMenuTitle(int index) {
    switch (index) {
      case 0:
        return 'รถราง';
      case 1:
        return 'สถานที่ท่องเที่ยว';
      case 2:
        return 'เส้นทางเดินรถ';
      case 3:
        return 'ร้านค้า';
      case 4:
        return 'สินค้า';
      case 5:
        return 'จุดท่องเที่ยวและตำแหน่ง GPS'; // สมมติว่าเป็นเมนูสำหรับแสดงจุดท่องเที่ยวต่างๆ
      default:
        return '';
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: MenuScreen(),
    theme: ThemeData(
      primarySwatch: Colors.deepPurple, // กำหนดธีมหลักของแอปพลิเคชัน
    ),
  ));
}
