import 'package:flutter/material.dart';
import 'CreateScreen.dart';
import 'LoginScreen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity, //full atas bawah
        width: double.infinity, //full samping
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
//gradasi warna
            Color.fromRGBO(243, 162, 11, 1),
            Color.fromARGB(255, 19, 16, 21),
          ],
          begin: Alignment.bottomLeft, //arah gradasi warna
          end: Alignment.topRight, //arah gradasi warna
          stops: [0.0, 1.0],
        )),

//logo
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.only(top: 90.0),
            child: Image(image: AssetImage('assets/LogoBagio.png')),
          ),

//sepasi
          const SizedBox(
            height: 50,
          ),

//sepasi
          const SizedBox(
            height: 30,
          ),

//perintah jika di click
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },

//tombol Sign In
            child: Container(
              height: 53,
              width: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
              ),
              child: const Center(
                child: Text(
                  'SIGN IN',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),

//sepasi
          const SizedBox(
            height: 20,
          ),

//perintah jika di click
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Createscreen()));
            },

//tombol Sign Up
            child: Container(
              height: 53,
              width: 320,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
              ),
              child: const Center(
                child: Text(
                  'SIGN UP',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
