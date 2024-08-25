import 'package:flutter/material.dart';
import '../all page/detailPage.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class BarangList extends StatefulWidget {
  final String id_kategori;
  final String kategori;

  const BarangList({required this.id_kategori, required this.kategori});

  @override
  State<BarangList> createState() => _BarangListState();
}

class _BarangListState extends State<BarangList> {
  Future<List<dynamic>> _fetchBarangList() async {
    final response = await http.post(
      Uri.parse('${dotenv.env['ENDPOINT']}/'),
      body: {"action": "barang", "id_kategori": widget.id_kategori},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(206, 197, 197, 197),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(243, 162, 11, 1),
          centerTitle: true,
          title: Text(
            widget.kategori,
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black54,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          leadingWidth: 70,
        ),
        body: FutureBuilder<List<dynamic>>(
          future: _fetchBarangList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('No Data'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No items found'));
            } else {
              List<dynamic> list_barang = snapshot.data!;
              // debugPrint(list_barang.toString());

              return ListView(
                children: list_barang.map((item) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            id:  item['barang_id'] ?? "",
                            title: item['nama_barang'] ?? "",
                            price: item['harga_barang'] ?? "",
                            description: item['create_barang'] ?? "",
                            image: item['image'] ?? "",
                            category: '${widget.kategori}',
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.all(7),
                      title: Text(item['nama_barang'] ?? ""),
                      subtitle: Text(item['harga_barang'] ?? ""),
                      leading: item['image'] != ''
                          ? Image.memory(base64Decode(item['image']))
                          : null,
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
