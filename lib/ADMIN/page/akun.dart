import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myapp/ADMIN/page/AkunDetail.dart';
import 'package:http/http.dart' as http;

class AkunPage extends StatefulWidget {
  const AkunPage({Key? key}) : super(key: key);

  @override
  _AkunPageState createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  List<Map<String, dynamic>> akunList = [];
  List<Map<String, dynamic>> filteredAkunList = [];
  bool isLoading = true;
  String _searchQuery = '';

  final List<Map<String, dynamic>> akun = [
    {
      'nama': 'Bagio',
      'No Hp': '089111221221',
      'alamat': 'Tegalsari',
      'email': 'Bagio211@gmail.com',
    },
    {
      'nama': 'Ardi',
      'No Hp': '089333223223',
      'alamat': 'Tegalrejo',
      'email': 'Ardi233@gmail.com',
    },
    {
      'nama': 'Sapardi',
      'No Hp': '089444224224',
      'alamat': 'Magetan',
      'email': 'Sapardi244@gmail.com',
    },
    // Tambahkan akun lainnya di sini
  ];


  Future<void> _fetchAkun() async {
    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['ENDPOINT']}/'),
        body: {"action": "pelanggan"},
      );
      
      if (response.statusCode == 200) {
        setState(() {
          akunList = List<Map<String, dynamic>>.from(jsonDecode(response.body));
          filteredAkunList = akunList
        .where((transaksi) => transaksi['nama_user'].toString().contains(_searchQuery))
        .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load transaksi');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAkun();
  }

  void updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      filteredAkunList = akunList
          .where((akunItem) => akunItem['nama_user']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();
    });
  }

  void cetakAkun() {
    for (var akunItem in filteredAkunList) {
      print('Nama: ${akunItem['nama_user']}');
      print('No HP: ${akunItem['no_handphone']}');
      print('Alamat: ${akunItem['alamat']}');
      print('Email: ${akunItem['username']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Akun', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          iconSize: 24,
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xff19143b),
      body: Column(
        children: [
//pencarian
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: updateSearchQuery,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.white),
                hintText: 'cari akun pelanggan',
                hintStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color.fromARGB(218, 251, 138, 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),

//tabel akun
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: filteredAkunList.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> akunItem = filteredAkunList[index];
                return Card(
                  color: Colors.grey[500], // Warna background card
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ExpansionTile(
                    backgroundColor:
                        Colors.white70, // Warna background tile yang diexpand
                    leading: const Icon(Icons.person,
                        color: Colors.deepOrangeAccent), // Warna icon
                    title: Text(akunItem['nama_user']),
                    children: <Widget>[
                      ListTile(
                        title: Text('No HP: ${akunItem['no_handphone']}'),
                      ),
                      ListTile(
                        title: Text('Alamat: ${akunItem['alamat']}'),
                      ),
                      ListTile(
                        title: Text('Email: ${akunItem['username']}'),
                      ),
                      ListTile(
                        title: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AkunDetail(akun: akunItem),
                              ),
                            );
                          },
                          child: const Text(
                            'Selengkapnya',
                            style: TextStyle(color: Colors.deepOrangeAccent),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
