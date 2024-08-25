import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:myapp/USER/Screen/LoginScreen.dart';
import 'package:myapp/USER/all%20page/profilesetting.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Profilepage extends StatefulWidget {
  const Profilepage();

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  Map<String,dynamic> akun = {};

  Future<void> fetchAkun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user');
    final response = await http.post(Uri.parse('${dotenv.env['ENDPOINT']}/'), body:{
      'action' : 'me',
      'user_id' : userId ?? ''
    });
    debugPrint(response.body.toString());
    if(response.statusCode == 200){
      var data = jsonDecode(response.body);

      if(data['status'] && mounted){
        setState(() {
          akun = data['data'];
        });
      }
    }

  }
  File? _profileImage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAkun();
  }
  void _handleTileTap(String title) async {
    switch (title) {
      case "Setting":
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Profilesetting()),
        );
        if (result != null && result is File) {
          setState(() {
            _profileImage = result;
          });
        }
        break;
      case "Logout":
        print("Logging out");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("Profil",
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        leadingWidth: 70,
      ),
      backgroundColor: Color.fromARGB(206, 197, 197, 197),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 50,
                child: akun['image'] != '' && akun['image'] != null
                    ? ClipRRect(borderRadius: BorderRadius.circular(999), 
                    child:  Image.memory(base64Decode(akun['image']),
                    gaplessPlayback: true,
                  fit: BoxFit.cover,))
                    : Image.asset('assets/fadli.png'),
              ),
              SizedBox(height: 10), 
              Text(
                akun['nama_user'] ?? '',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...List.generate(
            customListTiles.length,
            (index) {
              final tile = customListTiles[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Card(
                  elevation: 4,
                  shadowColor: Colors.black12,
                  child: ListTile(
                    title: Text(tile.title),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _handleTileTap(tile.title),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CustomListTile {
  final IconData icon;
  final String title;
  CustomListTile({
    required this.icon,
    required this.title,
  });
}

List<CustomListTile> customListTiles = [
  CustomListTile(
    icon: Icons.settings_accessibility_outlined,
    title: "Setting",
  ),
  CustomListTile(
    title: "Logout",
    icon: CupertinoIcons.power,
  ),
];
