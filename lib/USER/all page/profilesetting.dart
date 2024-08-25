import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Profilesetting extends StatefulWidget {
  const Profilesetting({super.key});

  @override
  State<Profilesetting> createState() => _ProfilesettingState();
}

class _ProfilesettingState extends State<Profilesetting> {
  File? _image;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      pickBefore();
    }
  }
  void pickBefore(){
    _decodeBase64ToImageFile(akun['image'] ?? '').then((file) {
        setState(() {
          _image = file;
        });
      }).catchError((e) {
        print('Error decoding base64: $e');
      });
  }
  Future<File> _decodeBase64ToImageFile(String base64String) async {
    try {
      Uint8List imageBytes = base64.decode(base64String);
      final directory = await getTemporaryDirectory(); // Use a temporary directory to save the image
      final filePath = '${directory.path}/decoded_image.png';
      final file = File(filePath);
      return file.writeAsBytes(imageBytes);
    } catch (e) {
      throw Exception('Failed to decode base64 string: $e');
    }
  }

  Future<void> _showSaveDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Data Disimpan'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Perubahan profil Anda telah disimpan.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pop(
                    context, _image); // Return to ProfilePage with the image
              },
            ),
          ],
        );
      },
    );
  }

  Map<String,dynamic> akun = {};
  String msg = "";

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
      final file = File('');
  
      if(data['status'] && mounted){
        setState(() {
          akun = data['data'];
          _usernameController.text = akun['username'];
          _passwordController.text = akun['password'];
          _addressController.text = akun['alamat'];
          _emailController.text = 'tidak ada email';
          _phoneController.text = akun['no_handphone'];
          _nameController.text = akun['nama_user'];
        });
      }
    }

  }

  Future<bool> update(File file) async {
  final prefs = await SharedPreferences.getInstance();
  String id_user = prefs.getString('user') ?? '';

  try {
    var request = http.MultipartRequest('POST', Uri.parse("${dotenv.env["ENDPOINT"]}/"));
    request.fields['action'] = 'update_profil';
    request.fields['id_user'] = id_user;
    request.fields['username'] = _usernameController.text;
    // request.fields['password'] = _passwordController.text;
    request.fields['no_handphone'] = _phoneController.text;
    request.fields['alamat'] = _addressController.text;
    request.fields['nama_user'] = _nameController.text;
    

    request.files.add(await http.MultipartFile.fromPath('image', file.path));

    final response = await request.send();
      debugPrint(response.statusCode.toString());

    if (response.statusCode == 200) {
      var responseBody = await http.Response.fromStream(response);
      var jsonResponse = jsonDecode(responseBody.body);
      debugPrint(jsonResponse.toString()); 
      if (jsonResponse['status']) {
        return true;
      }else{
        if(mounted){setState(() {
          msg = jsonResponse['data']['message'] ?? '';
        });}
      }
    }
  } catch (e) {
    debugPrint('Error: $e');
  }

  return false;
}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAkun();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        leadingWidth: 70,
        title: const Text("Edit Profil",
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(206, 197, 197, 197),
      body: Stack(
        children: [
          ListView(
            children: [
              ListTile(
                contentPadding: EdgeInsets.all(20),
                title: Text("Foto"),
                subtitle: Column(
                  children: [
                    _image != null
                        ? Image.file(
                            _image!,
                            height: 100,
                            width: 170,
                          )
                        : Image.asset(
                            "assets/editAkun.png",
                            height: 100,
                            width: 170,
                          ),
                    SizedBox(height: 10), // Jarak antara gambar dan tombol
                    ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        fixedSize: Size(double.infinity, 40),
                      ),
                      child: const Text(
                        "Upload Image",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(20),
                title: Text("Username :"),
                subtitle: TextField(
                  controller: _usernameController,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(20),
                title: Text("Password :"),
                subtitle: TextField(
                  controller: _passwordController,
                  obscureText: true, // Hide password
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(20),
                title: Text("Nama :"),
                subtitle: TextField(
                  controller: _nameController,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(20),
                title: Text("No HP :"),
                subtitle: TextField(
                  controller: _phoneController,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(20),
                title: Text("Alamat :"),
                subtitle: TextField(
                  controller: _addressController,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(20),
                title: Text("Email :"),
                subtitle: TextField(
                  controller: _emailController,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () async {
                  if(_image == null) {
                    _pickImage();
                    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pilih Gambar atau SIlang untuk menggukana gambar sebelumnya')),
      );
                  }else{

                  final res = await update(_image!);
                  res ? _showSaveDialog() : ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengunggah $msg')),
      );}}, // Panggil fungsi dialog saat tombol diklik
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(243, 162, 11, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  fixedSize: Size(double.infinity, 50),
                ),
                child: const Text(
                  "Simpan Perubahan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
