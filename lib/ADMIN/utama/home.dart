import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myapp/ADMIN/utama/sidemenu_list.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:http/http.dart' as http;

class HomeAdm extends StatefulWidget {
  const HomeAdm({super.key});

  @override
  State<HomeAdm> createState() => _HomeAdmState();
}

class _HomeAdmState extends State<HomeAdm> {
  final GlobalKey<SideMenuState> sideMenuKey = GlobalKey<SideMenuState>();
  final List<String> dates = ['2024-08-20', '2024-08-21', '2024-08-22', '2024-08-23'];
  String selectedDate = '2024-08-20';

  List<Map<String, dynamic>> salesData = [
    {
      'title': 'Kategori & Barang',
      'details': [
        'Jml Kategori: ...',
        'Jml Barang: ...'
      ]
    },
    {
      'title': 'Transaksi',
      'details': [
        'Omset: Rp. ...',
        'Jml Transaksi: ...'
      ]
    },
    {
      'title': 'User',
      'details': [
        'Jml user: ...'
      ]
    },
    {
      'title': 'Promo',
      'details': [
        'Jml Promo: ...'
      ]
    },
  ];

  Future<void> _fetchSales() async {
    final response = await http.post(
      Uri.parse('${dotenv.env['ENDPOINT']}/'),
      body: {
        'action':'sales',
        'tanggal_laporan': selectedDate
      } 
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(response.body);
      if(data['status']){
        setState(() {
          salesData = List<Map<String, dynamic>>.from(jsonDecode(response.body)['data']);
        });
      }
    } else {
      
      print('Failed to load');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchSales();
  }

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      key: sideMenuKey,
      background: Color(0xff19143b),
      menu: SidemenuList(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            iconSize: 32,
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              if (sideMenuKey.currentState!.isOpened) {
                sideMenuKey.currentState!.closeSideMenu();
              } else {
                sideMenuKey.currentState!.openSideMenu();
              }
            },
          ),
          title: const Text('Admin', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        backgroundColor: Color.fromARGB(255, 46, 38, 95),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Laporan penjualan tanggal',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  DropdownButton<String>(
                    value: selectedDate,
                    dropdownColor: Color.fromARGB(255, 64, 52, 125),
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    underline: Container(
                      height: 2,
                      color: Colors.white,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDate = newValue!;
                      });
                    },
                    items: dates.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 3 / 3.7,
                        ),
                        itemCount: salesData.length,
                        itemBuilder: (context, index) {
                          final sale = salesData[index];
                          return Card(
                            color: Color.fromARGB(255, 64, 52, 125),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      sale['title'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 18),
                                    for (var detail in sale['details'])
                                      Text(
                                        detail,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
