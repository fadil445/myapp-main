// lib/daftartransaksi.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myapp/ADMIN/page/TransaksiDetail.dart';
import 'package:http/http.dart' as http;


class Transaksi extends StatefulWidget {
  @override
  _TransaksiState createState() => _TransaksiState();
}

class _TransaksiState extends State<Transaksi> {
  List<Map<String, dynamic>> transaksiList = [];
  List<Map<String, dynamic>> filteredTransaksiList = [];
  bool isLoading = true;
  String _searchQuery = '';


  // final List<Map<String, dynamic>> _transaksiList = List.generate(20, (index) => {
  //   'id': index + 1,
  //   'tanggal': DateTime.now().subtract(Duration(days: index)),
  //   'jumlah': 'Rp.${index * 12000}', // Mengganti format dolar dengan rupiah
  //   'deskripsi': 'Deskripsi detail transaksi #$index',
  //   'akun': 'Akun ${index % 20 + 1}', // ID Akun, contoh Akun 1, Akun 2, Akun 3
  // });
  
  Future<void> _fetchTransaksi() async {
    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['ENDPOINT']}/'),
        body: {"action": "all_transaksi"},
      );
      
      if (response.statusCode == 200) {
        setState(() {
          transaksiList = List<Map<String, dynamic>>.from(jsonDecode(response.body));
          filteredTransaksiList = transaksiList
        .where((transaksi) => transaksi['transaksi_id'].toString().contains(_searchQuery))
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
    _fetchTransaksi();
  }

  @override
  Widget build(BuildContext context) {
   

    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Transaksi', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          iconSize: 20,
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Color.fromARGB(255, 46, 38, 95),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
                filteredTransaksiList = transaksiList
                .where((transaksi) => transaksi['transaksi_id'].toString().contains(_searchQuery))
                .toList();
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.white),
                hintText: 'Cari Transaksi',
                hintStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Color.fromARGB(218, 251, 138, 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: filteredTransaksiList.length,
              itemBuilder: (context, index) {
                final transaksiItem = filteredTransaksiList[index];
                return Card(
                  color: Colors.grey[500],
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: Icon(Icons.money_off, color: const Color.fromARGB(255, 194, 55, 13)),
                    title: Text('Transaksi #${transaksiItem['transaksi_id']}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailTransaksi(transaksi: transaksiItem),
                        ),
                      );
                    },
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
