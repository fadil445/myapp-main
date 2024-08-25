import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:myapp/USER/primary/barang.dart';

class SearchPage extends StatefulWidget {
  final List<Map<String, dynamic>> kategori;

  const SearchPage({required this.kategori});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  TextEditingController textController = TextEditingController();
  List<Map<String, dynamic>> filteredKategori = [];

  @override
  void initState() {
    super.initState();
    print(widget.kategori);
    filteredKategori = widget.kategori;
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<Map<String, dynamic>> dummyListData = [];
      widget.kategori.forEach((item) {
        if (item['nama_kategori']!.toLowerCase().contains(query.toLowerCase()) ||
            item['deskripsi']!.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        filteredKategori = dummyListData;
      });
    } else {
      setState(() {
        filteredKategori = widget.kategori;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(206, 197, 197, 197),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        leadingWidth: 70,
        title: Text(
          "Pencarian",
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: Color.fromARGB(206, 197, 197, 197),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            AnimSearchBar(
              width: 400,
              textController: textController,
              onSuffixTap: () {
                setState(() {
                  textController.clear();
                  filterSearchResults('');
                });
              },
              color: Color.fromARGB(255, 251, 130, 0),
              helpText: "Cari apa bun...",
              autoFocus: false,
              closeSearchOnSuffixTap: false,
              animationDurationInMilli: 1500,
              rtl: true,
              onSubmitted: (String query) {
                filterSearchResults(query);
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                childAspectRatio: (120 / 160),
                children: [
                  for (int i = 0; i < filteredKategori.length; i++)
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BarangList(
                              kategori: filteredKategori[i]['nama_kategori']!,
                              id_kategori: filteredKategori[i]['kategori_id']!,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 13),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromARGB(125, 155, 153, 153),
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              child: Image.network(
                                filteredKategori[i]['image']!,
                                width: 120,
                                height: 120,
                              ),
                            ),
                            Text(
                              filteredKategori[i]['nama_kategori']!,
                              style: TextStyle(
                                color: Color.fromRGBO(138, 96, 6, 1),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
