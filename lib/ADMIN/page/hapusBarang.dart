import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HapusBarang extends StatefulWidget {
  @override
  _HapusBarangState createState() => _HapusBarangState();
}

class _HapusBarangState extends State<HapusBarang> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBarangId;
  List<String> _barangList = [];
  List<String> _barangIdList = [];
  List<dynamic> _barang = [];
  @override
  void initState() {
    super.initState();
    _fetchBarang();
  }

  Future<void> _fetchBarang() async {
    final response = await http.post(
      Uri.parse('${dotenv.env['ENDPOINT']}/'),
      body: {'action': 'get_barang'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];

      setState(() {
        _barang = data;
        _barangList = data.map((item) => item['nama_barang']).toList().cast<String>();
        _barangIdList = data.map((item) => item['barang_id']).toList().cast<String>();
      });
    } else {
      print('Failed to load barang');
    }
  }

  Future<void> _hapusBarang() async {
    final response = await http.post(
      Uri.parse('${dotenv.env['ENDPOINT']}/'),
      body: {'action': 'delete_barang', 'id_barang': _selectedBarangId},
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Barang berhasil dihapus')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus barang')),
        );
      }
    } else {
      print('Failed to delete barang');
    }
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => super.widget));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hapus Barang', style: TextStyle(color: Colors.white)),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedBarangId,
                hint: Text('Pilih Barang'),
                style: TextStyle(color: Colors.grey),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedBarangId = newValue;
                  });
                },
                items: _barang.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value['barang_id'],
                    child: Text(value['nama_barang'] ?? ''),
                  );
                }).toList(),
                validator: (value) => value == null ? 'Pilih barang yang ingin dihapus' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _hapusBarang();
                  }
                },
                child: Text('Hapus Barang'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(218, 251, 138, 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
