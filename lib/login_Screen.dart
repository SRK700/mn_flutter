import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463023/main.dart';
import 'package:mn_641463023/register.dart';
import 'package:mn_641463023/menu_Screen.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void submitLogin(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    String apiUrl = 'http://localhost:81//API_mn/checklogin.php';

    Map<String, dynamic> requestBody = {
      'email': email,
      'password': password,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        showSuccessDialog(context);
      } else {
        showLoginErrorDialog(context);
      }
    } catch (error) {
      showNotConnectDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เข้าสู่ระบบ'),
        backgroundColor: Colors.blue, // เปลี่ยนสี AppBar
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage('images/sp.png'),
                width: 150.0,
                height: 150.0,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'ชื่อผู้ใช้:',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'รหัสผ่าน',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  submitLogin(context);
                },
                child: Text('เข้าสู่ระบบ'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // เปลี่ยนสีปุ่ม
                  onPrimary: Colors.white, // เปลี่ยนสีข้อความปุ่ม
                ),
              ),
              SizedBox(height: 8.0),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => RegisterUserForm(),
                    ),
                  );
                },
                child: Text('ลงทะเบียน!'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showNotConnectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ข้อผิดพลาดในการเชื่อมต่อ'),
          content: Text('ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิดป๊อปอัพ
              },
              child: Text('ย้อนกลับ'),
            ),
          ],
        );
      },
    );
  }

  void showLoginErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ข้อผิดพลาดในการเข้าสู่ระบบ'),
          content: Text('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิดป๊อปอัพ
              },
              child: Text('ตกลง'),
            ),
          ],
        );
      },
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('เข้าสู่ระบบสำเร็จ'),
          content: Text('ข้อมูลของคุณถูกบันทึกเรียบร้อยแล้ว'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => MenuScreen(),
                  ),
                );
              },
              child: Text('ไปที่เมนู'),
            ),
          ],
        );
      },
    );
  }
}
