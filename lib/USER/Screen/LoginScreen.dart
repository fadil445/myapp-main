import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myapp/ADMIN/utama/home.dart';
import 'package:myapp/USER/all%20page/homePage.dart';
import 'package:myapp/USER/Screen/CreateScreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/USER/all%20page/webViewScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
    String token = '';

  Future<void> _login() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showDialog('Pemberitahuan !!!', 'Akun data tidak benar!');
      return;
    }
    
    try {
      
      final response = await http.post(
        Uri.parse('${dotenv.env['ENDPOINT']}/'),  
        body: {
          "username": _emailController.text,
          "password": _passwordController.text,
          "action": "login",
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        
        if (data['status']) { 
          var userId = data['data']['user_id'];
          prefs.setString('user', userId);
          bool pending = await fetchTransaction(userId);
          prefs.setBool('pending', pending);
          if(pending) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewScreen(url: "https://app.sandbox.midtrans.com/snap/v4/redirection/${token}", userId: userId ?? '',),));
            return;
          }
          var roll = data['data']['roll'];

          if (roll == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeAdm()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            );
          }
        }else{
          _showDialog('Pemberitahuan !!!', 'Akun anda tidak terdaftar!');
        }
      } else {
        _showDialog('Error', 'Terjadi kesalahan, silakan coba lagi.');
      }
    } catch (e) {
      debugPrint(e.toString());
      _showDialog('Error', 'Terjadi kesalahan, silakan coba lagi.');
    }
  }
  Future<bool> fetchTransaction(String userId) async {

    final response = await http.post(
        Uri.parse('${dotenv.env['ENDPOINT']}/'),  
        body: {
          "user_id": userId,
          "action": "midtrans_berjalan",
        },
      );
    
    if(response.statusCode==200){
      var data = jsonDecode(response.body);
      if(data['status'] && mounted){
        if(data != null){
        setState(() {
          token = data['data'];
        }); 
          return true;
        }else{
          return false;
        }
      }
    }

    return false;
  }
  void _showDialog(String title, String content) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text("Tutup"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(243, 162, 11, 1),
                  Color.fromARGB(255, 19, 16, 21),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Hello\nSign In!',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Gmail',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(182, 179, 90, 17),
                            ),
                          ),
                        ),
                        TextField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(182, 179, 90, 17),
                            ),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        const SizedBox(height: 70),
                        GestureDetector(
                          onTap: _login,
                          child: Container(
                            height: 55,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromRGBO(243, 162, 11, 1),
                                  Color.fromARGB(255, 19, 16, 21),
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'SIGN IN',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Createscreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Sign up",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class User {
    String userId;
    String username;
    String password;
    DateTime createUser;
    String namaUser;
    String noHandphone;
    String alamat;
    String roll;

    User({
        required this.userId,
        required this.username,
        required this.password,
        required this.createUser,
        required this.namaUser,
        required this.noHandphone,
        required this.alamat,
        required this.roll,
    });

}

