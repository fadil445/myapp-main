import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Kategoribarang extends StatefulWidget {
  @override
  _KategoribarangState createState() => _KategoribarangState();
}

class _KategoribarangState extends State<Kategoribarang> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedKategori;
  String? _selectedKategoriId;
  String? _selectedStatus;
  File? _image;
  final _judulBarangController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _qtyController = TextEditingController();
  final _hargaController = TextEditingController();

  List<String> _kategoriList = [];
  List<String> _kategoriIdList = [];
  final List<String> _statusList = ['Tersedia', 'Habis'];

  @override
  void initState() {
    super.initState();
    _fetchKategori();
  }

  Future<void> _fetchKategori() async {
    final response = await http.post(
      Uri.parse('${dotenv.env['ENDPOINT']}/'),
      body: {
        'action': 'kategori'
      }
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      setState(() {
        _kategoriList = data.map((item) => item['nama_kategori']).toList().cast<String>();
        _kategoriIdList = data.map((item) => item['kategori_id']).toList().cast<String>();
      });
    } else {
      print('Failed to load kategori');
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  String msg = "";
  Future<bool> _submitData(File file) async {
    if (!_formKey.currentState!.validate() || _selectedKategoriId == null) return false;
  final prefs = await SharedPreferences.getInstance();
  String id_user = prefs.getString('user') ?? '';

  try {
    var request = http.MultipartRequest('POST', Uri.parse("${dotenv.env["ENDPOINT"]}/"));
    request.fields['action'] = 'insert_barang';
    request.fields['nama_barang'] = _judulBarangController.text;
    request.fields['deskripsi'] = _deskripsiController.text;
    request.fields['id_kategori'] = _selectedKategoriId ?? '';
    request.fields['qty'] = _qtyController.text;
    request.fields['status'] = _selectedStatus?.toLowerCase() ?? 'tersedia';
    request.fields['harga_barang'] = _hargaController.text;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Barang & Kategori', style: TextStyle(color: Colors.white)),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedKategori,
                      hint: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Pilih Kategori', style: TextStyle(color: Colors.white)),
                      ),
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedKategori = newValue;
                          int index = _kategoriList.indexOf(newValue!);
                          _selectedKategoriId = _kategoriIdList[index];
                        });
                      },
                      items: _kategoriList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(value, style: TextStyle(color: Colors.white)),
                          ),
                        );
                      }).toList(),
                      dropdownColor: Colors.grey[500],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _judulBarangController,
                  decoration: InputDecoration(
                    labelText: 'Judul Barang',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Judul barang tidak boleh kosong'
                      : null,
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  controller: _qtyController,
                  decoration: InputDecoration(
                    labelText: 'QTY',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty
                      ? 'QTY tidak boleh kosong'
                      : null,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _hargaController,
                  decoration: InputDecoration(
                    labelText: 'Harga',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Harga tidak boleh kosong'
                      : null,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _deskripsiController,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  maxLines: 4,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Deskripsi tidak boleh kosong'
                      : null,
                ),
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedStatus,
                      hint: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Status', style: TextStyle(color: Colors.white)),
                      ),
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedStatus = newValue;
                        });
                      },
                      items: _statusList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(value, style: TextStyle(color: Colors.white)),
                          ),
                        );
                      }).toList(),
                      dropdownColor: Colors.grey[500],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                _image == null
                    ? Text('Tidak ada gambar yang dipilih.', style: TextStyle(color: Colors.white))
                    : Image.file(_image!),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(218, 251, 138, 0),
                      ),
                      onPressed: _pickImage,
                      child: Text('Upload Gambar', style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(width: 16.0), // Jarak antara tombol
                    ElevatedButton(
                      onPressed: () async {
                        if(_image != null){

                        final res = await _submitData(_image!);
                        if(res){
                          ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sukses')),
      );
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('gagal $msg')),
      );
                        }
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gambarnya ')),
      );
                        }
                        
                      },
                      child: Text('Kirim'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
