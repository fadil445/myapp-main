import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HapusBeritaPromo extends StatefulWidget {
  @override
  _HapusBeritaPromoState createState() => _HapusBeritaPromoState();
}

class _HapusBeritaPromoState extends State<HapusBeritaPromo> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBeritaPromoId;
  List<String> _beritaPromoList = [];
  List<String> _beritaPromoIdList = [];

  @override
  void initState() {
    super.initState();
    _fetchBeritaPromo();
  }

  Future<void> _fetchBeritaPromo() async {
    final response = await http.post(
      Uri.parse('${dotenv.env['ENDPOINT']}/'),
      body: {'action': 'get_berita_promo'},
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      setState(() {
        _beritaPromoList = data.map((item) => item['judul_berita']).toList().cast<String>();
        _beritaPromoIdList = data.map((item) => item['id_berita']).toList().cast<String>();
      });
    } else {
      print('Failed to load berita promo');
    }
  }

  Future<void> _hapusBeritaPromo() async {
    final response = await http.post(
      Uri.parse('${dotenv.env['ENDPOINT']}/'),
      body: {'action': 'delete_berita_promo', 'id_berita': _selectedBeritaPromoId},
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berita Promo berhasil dihapus')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus berita promo')),
        );
      }
    } else {
      print('Failed to delete berita promo');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hapus Promo', style: TextStyle(color: Colors.white)),
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
                value: _selectedBeritaPromoId,
                hint: Text('Pilih Promo'),
                style: TextStyle(color: Colors.white),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedBeritaPromoId = newValue;
                  });
                },
                items: _beritaPromoList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) => value == null ? 'Pilih berita promo yang ingin dihapus' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _hapusBeritaPromo();
                  }
                },
                child: Text('Hapus Berita Promo'),
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
