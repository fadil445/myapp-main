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
              pw.Text('Nama: ${widget.akun['nama_user']}'),
              pw.Text('No HP: ${widget.akun['no_handphone']}'),
              pw.Text('Alamat: ${widget.akun['alamat']}'),
              pw.Text('Email: ${widget.akun['username']}'),
            ],
          );
        },
      ),
    );

    final outputFile = await _savePdfToFile(pdf);

    if (outputFile != null) {
      Printing.sharePdf(
          bytes: outputFile.readAsBytesSync(),
          filename: 'detail_akun_${widget.akun['nama_user']}.pdf');
    }
  }

  Future<File?> _savePdfToFile(pw.Document pdf) async {
    try {
      final outputFile = File('${(await getTemporaryDirectory()).path}/detail_akun_${widget.akun['nama_user']}.pdf');
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
        title: Text('Detail Akun ${widget.akun['nama_user']}'),
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
            Text('Nama: ${widget.akun['nama_user']}', style: TextStyle(fontSize: 18, color: Colors.white)),
            SizedBox(height: 10),
            Text('No HP: ${widget.akun['no_handphone']}', style: TextStyle(fontSize: 18, color: Colors.white)),
            SizedBox(height: 10),
            Text('Alamat: ${widget.akun['alamat']}', style: TextStyle(fontSize: 18, color: Colors.white)),
            SizedBox(height: 10),
            Text('Email: ${widget.akun['username']}', style: TextStyle(fontSize: 18, color: Colors.white)),
            SizedBox(height: 20),
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
