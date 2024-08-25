import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:myapp/USER/all%20page/cartPage.dart';
import 'package:myapp/USER/all%20page/profilePage.dart';
import 'package:myapp/USER/primary/dashboard.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _pageIndex = 0;

  // Daftar halaman untuk ditampilkan
  final List<Widget> _pages = [
    Dashboard(),
    CartPage(),
    Profilepage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_pageIndex], // Menampilkan halaman sesuai indeks
      bottomNavigationBar: CurvedNavigationBar(
        color: Color.fromRGBO(243, 162, 11, 1),
        backgroundColor: Color.fromARGB(206, 197, 197, 197),
        height: 45,
        items: [
          Icon(Icons.home, size: 20),
          Icon(Icons.shop, size: 20),
          Icon(Icons.person, size: 20),
        ],
        onTap: (index) {
          setState(() {
            _pageIndex = index; // Mengubah halaman sesuai indeks yang dipilih
          });
        },
      ),
    );
  }
}
