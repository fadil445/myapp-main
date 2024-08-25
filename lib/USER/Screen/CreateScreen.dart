import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myapp/ADMIN/utama/home.dart';
import 'package:myapp/USER/Screen/LoginScreen.dart';
import 'package:myapp/USER/all%20page/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Createscreen extends StatefulWidget {
  @override
  State<Createscreen> createState() => _CreatescreenState();
}

class _CreatescreenState extends State<Createscreen> {
//Sign Up
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _no_hpController = TextEditingController();

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
Future<void> _register() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showDialog('Pemberitahuan !!!', 'Akun data tidak benar!');
      return;
    }
    
    
      final response = await http.post(
        Uri.parse('${dotenv.env['ENDPOINT']}/'),  
        body: {
          "username": _emailController.text,
          "password": _passwordController.text,
          "password2" :_passwordConController.text,
          "nama_user" : _nameController.text,
          "alamat": _alamatController.text,
          "no_handphone": _no_hpController.text,
          "action": "pendaftaran",
        },
      );
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // debugPrint(data);
        if (data['status']) { 
_showDialog('Pemberitahuan !!!', 'BERHASIL silahkan login!');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          
        }else{
          _showDialog('Pemberitahuan !!!', 'User Sudah Terdaftar!');
        }
      } else {
        _showDialog('Error', 'Terjadi kesalahan, silakan coba lagi.');
      }

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
              stops: [0.0, 1.0],
            ),
          ),

//create account
          child: const Padding(
            padding: EdgeInsets.only(top: 60.0, left: 22),
            child: Text(
              'Create Your\nAccount',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),

//box putih
        Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), 
                  topRight: Radius.circular(40)),
              color: Colors.white,
            ),
            height: double.infinity,
            width: double.infinity,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),  //jarak kanan kiri tulisan
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
//kolom nama
                      
                 TextField(
                  controller: _nameController,
                        decoration: InputDecoration(
                            label: Text(      
                          'Full Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffB81736),
                          ),
                        )),
                      ),
                 TextField(

                  controller: _emailController,
                        decoration: InputDecoration(
                            label: Text(
                          'Gmail',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffB81736),
                          ),
                        )),
                      ),
                 TextField(
                  controller: _passwordController,
                        decoration: InputDecoration(
                            label: Text(
                          'Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffB81736),
                          ),
                        )),
                      ),
                 TextField(
                   controller: _passwordConController,
                        decoration: InputDecoration(
                            label: Text(
                          'Confirm Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffB81736),
                          ),
                        )),
                      ),
                 TextField(
                   controller: _alamatController,
                        decoration: InputDecoration(
                            label: Text(
                          'Alamat',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffB81736),
                          ),
                        )),
                      ),
                 TextField(
                   controller: _no_hpController,
                        decoration: InputDecoration(
                            label: Text(
                          'No. Hp',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffB81736),
                          ),
                        )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      
                
                      GestureDetector(
                        onTap: () async {
                         await  _register();
                        },
                        child: Container(
                          height: 55,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(colors: [
                              Color.fromRGBO(243, 162, 11, 1),
                              Color.fromARGB(255, 19, 16, 21),
                              ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),                  
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
