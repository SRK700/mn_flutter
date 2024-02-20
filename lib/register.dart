import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463023/login_Screen.dart';

class RegisterUserForm extends StatefulWidget {
  @override
  _RegisterUserFormState createState() => _RegisterUserFormState();
}

class _RegisterUserFormState extends State<RegisterUserForm> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void registerUser() async {
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    // ตรวจสอบว่าข้อมูลไม่ควรเป็นค่าว่าง
    if (firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty) {
      // URL ของ API (saveregister.php)
      String apiUrl = 'http://localhost:81//tourism_API/saveregister.php';

      // สร้าง body ของ request เพื่อส่งข้อมูล
      Map<String, dynamic> requestBody = {
        'firstname': firstName,
        'lastname': lastName,
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
          print('ไม่สามารถสมัครสมาชิกได้');
        }
      } catch (error) {
        print('เกิดข้อผิดผลาดในการเชื่อมต่อ: $error');
      }
    } else {
      // แจ้งเตือนถ้าข้อมูลไม่ครบ
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ข้อมูลไม่ครบถ้วน'),
            content: Text('กรุณากรอกข้อมูลให้ครบทุกช่อง'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('ตกลง'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Form'),
        backgroundColor: Colors.green, // เปลี่ยนสี AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            TextFormField(
              controller: firstNameController,
              decoration: InputDecoration(
                labelText: 'Firstname',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: lastNameController,
              decoration: InputDecoration(
                labelText: 'Lastname',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: registerUser,
              child: Text('Register'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // เปลี่ยนสีปุ่ม
                onPrimary: Colors.white, // เปลี่ยนสีข้อความปุ่ม
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Successfully'),
        content: Text('Your information has been successfully saved..'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ));
            },
            child: Text('Go to Login Page'),
          ),
        ],
      );
    },
  );
}
