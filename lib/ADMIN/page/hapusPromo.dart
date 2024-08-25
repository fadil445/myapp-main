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
  String? _selectedPromoId;
  List<String> _promoList = [];
  List<String> _promoIdList = [];
  List<dynamic> _promo = [];

  @override
  void initState() {
    super.initState();
    _fetchPromo();
  }

  Future<void> _fetchPromo() async {
    final response = await http.post(
      Uri.parse('${dotenv.env['ENDPOINT']}/'),
      body: {'action': 'get_promo'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];

      setState(() {
        _promo = data;
        _promoList = data.map((item) => item['judul_promo']).toList().cast<String>();
        _promoIdList = data.map((item) => item['promo_id']).toList().cast<String>();
      });
    } else {
      print('Failed to load promo');
    }
  }

  Future<void> _hapusPromo() async {
    final response = await http.post(
      Uri.parse('${dotenv.env['ENDPOINT']}/'),
      body: {'action': 'delete_promo', 'id_promo': _selectedPromoId},
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Promo berhasil dihapus')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus promo')),
        );
      }
    } else {
      print('Failed to delete promo');
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
                value: _selectedPromoId,
                hint: Text('Pilih Promo'),
                style: TextStyle(color: Colors.white),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPromoId = newValue;
                  });
                },
                items: _promo.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value['promo_id'],
                    child: Text(value['judul_promo'] ?? ''),
                  );
                }).toList(),
                validator: (value) => value == null ? 'Pilih promo yang ingin dihapus' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _hapusPromo();
                  }
                },
                child: Text('Hapus Promo'),
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
