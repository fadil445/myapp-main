import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AkunDetail extends StatefulWidget {
  final Map<String, dynamic> akun;

  AkunDetail({required this.akun});

  @override
  State<AkunDetail> createState() => _AkunDetailState();
}

class _AkunDetailState extends State<AkunDetail> {
  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Detail Akun', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Text('------------------------------------'),
              pw.SizedBox(height: 4),
              pw.Text('Username: ${widget.akun['username']}'),
              pw.SizedBox(height: 2),
              pw.Text('ID User: ${widget.akun['user_id']}'),
              pw.SizedBox(height: 4),
              pw.Text('------------------------------------'),
              pw.SizedBox(height: 4),
              pw.Text('Nama: ${widget.akun['nama_user']}'),
              pw.SizedBox(height: 2),
              pw.Text('No HP: ${widget.akun['no_handphone']}'),
              pw.SizedBox(height: 2),
              pw.Text('Alamat: ${widget.akun['alamat']}'),
              pw.SizedBox(height: 2),
              pw.Text('E-mail: ${widget.akun['gmail']}'),
            ],
          );
        },
      ),
    );

    final outputFile = await _savePdfToFile(pdf);

    if (outputFile != null) {
      Printing.sharePdf(
          bytes: outputFile.readAsBytesSync(),
          filename: 'Akun ${widget.akun['nama_user']}.pdf');
    }
  }

  Future<File?> _savePdfToFile(pw.Document pdf) async {
    try {
      final outputFile = File('${(await getTemporaryDirectory()).path}/Akun${widget.akun['nama_user']}.pdf');
      await outputFile.writeAsBytes(await pdf.save());
      return outputFile;
    } catch (e) {
      print('Error saving PDF file: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Akun'),
        leading: IconButton(
          iconSize: 20,
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Color.fromARGB(255, 46, 38, 95),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('----------------------------------------------------------',
            style: TextStyle(fontSize: 15, color: Colors.white),),
            SizedBox(height: 5),
            Text('Username: ${widget.akun['username']}', 
            style: TextStyle(fontSize: 15, color: Colors.white)),
            SizedBox(height: 10),
            Text('ID User: ${widget.akun['user_id']}', 
            style: TextStyle(fontSize: 15, color: Colors.white)),
            SizedBox(height: 5),
            Text('----------------------------------------------------------',
            style: TextStyle(fontSize: 15, color: Colors.white),),
            SizedBox(height: 25),
            Text('Nama      :  ${widget.akun['nama_user']}', 
            style: TextStyle(fontSize: 15, color: Colors.white)),
            SizedBox(height: 10),
            Text('No Hp     :  ${widget.akun['no_handphone']}', 
            style: TextStyle(fontSize: 15, color: Colors.white)),
            SizedBox(height: 10),
            Text('Alamat   :  ${widget.akun['alamat']}', 
            style: TextStyle(fontSize: 15, color: Colors.white)),
            SizedBox(height: 10),
            Text('E-mail     :  ${widget.akun['gmail']}', 
            style: TextStyle(fontSize: 15, color: Colors.white)),
            SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(218, 251, 138, 0),
                ),
                onPressed: _generatePdf,
                child: Text('Download Detail Akun', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
