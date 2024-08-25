import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:myapp/USER/all%20page/searchPage.dart';
import 'package:myapp/USER/primary/barang.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Map<String, dynamic>> kategoriList = [];
  bool isLoading = true;

  List<Map<String, String>> diskonImages = [
    {"image": "assets/DiskonKopi.png"},
    {"image": "assets/DiskonTepung.png"},
    {"image": "assets/DiskonSusu.png"},
  ];

  Future<void> _fetchKategori() async {
    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['ENDPOINT']}/'),
        body: {"action": "kategori"},
      );

      if (response.statusCode == 200) {
        setState(() {
          kategoriList = List<Map<String, dynamic>>.from(jsonDecode(response.body));
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load kategori');
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
    _fetchKategori();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sembako",
      home: Scaffold(
        backgroundColor: Color.fromARGB(206, 197, 197, 197),
        appBar: AppBar(
          title: Text(
            "Dashboard",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    )
                  : Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(243, 162, 11, 1),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.search, color: Colors.black, size: 20),
                        onPressed: kategoriList.isNotEmpty
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchPage(
                                      kategori: kategoriList,
                                    ),
                                  ),
                                );
                              }
                            : null, // Disable button if the list is empty
                      ),
                    ),
            ),
          ],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  //Diskon
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: diskonImages.map((diskon) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Image.asset(
                            diskon['image']!,
                            width: 300,
                            height: 120,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  //Kategori & Barang
                  if (kategoriList.isNotEmpty)
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        childAspectRatio: (120 / 160),
                        children: kategoriList.map((kategori) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BarangList(
                                    id_kategori: kategori['kategori_id']!,
                                    kategori: kategori['nama_kategori']!,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 13),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color.fromARGB(125, 155, 153, 153),
                              ),
                              child: Column(
                                children: [
                                  if (kategori['image'] != null)
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      child: Image.network(
                                        kategori['image']!,
                                        width: 120,
                                        height: 120,
                                      ),
                                    ),
                                  Text(
                                    kategori['nama_kategori'] ?? "-",
                                    style: TextStyle(
                                      color: Color.fromRGBO(138, 96, 6, 1),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    kategori['deskripsi'] ?? "-",
                                    style: TextStyle(fontSize: 10),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
