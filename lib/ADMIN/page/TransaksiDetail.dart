import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DetailTransaksi extends StatefulWidget {
  final Map<String, dynamic> transaksi;

  DetailTransaksi({required this.transaksi});

  @override
  State<DetailTransaksi> createState() => _DetailTransaksiState();
}

class _DetailTransaksiState extends State<DetailTransaksi> {
  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Detail Transaksi', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Text('Nama: ${widget.transaksi['nama_user']}'),
              pw.Text('Tanggal: ${widget.transaksi['create_transaksi']}'),
              pw.Text('Jumlah: ${widget.transaksi['qty']}'),
              pw.Text(
                'Status: ${widget.transaksi['qty'] == 0 ? 'Belum diproses' : 'Selesai'}',
              ),
            ],
          );
        },
      ),
    );

    final outputFile = await _savePdfToFile(pdf);

    if (outputFile != null) {
      Printing.sharePdf(
        bytes: outputFile.readAsBytesSync(),
        filename: 'detail_transaksi_${widget.transaksi['id']}.pdf',
      );
    }
  }

  Future<File?> _savePdfToFile(pw.Document pdf) async {
    try {
      final outputFile = File(
          '${(await getTemporaryDirectory()).path}/detail_transaksi_${widget.transaksi['id']}.pdf');
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
        title: Text('Detail Transaksi #${widget.transaksi['id']}'),
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
            Text(
              'Nama: ${widget.transaksi['nama_user']}',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text('Tanggal: ${DateTime.parse(widget.transaksi['create_transaksi']).toString()}',
                style: TextStyle(fontSize: 18, color: Colors.white)),
            SizedBox(height: 10),
            Text('Jumlah: ${widget.transaksi['qty']}',
                style: TextStyle(fontSize: 18, color: Colors.white)),
            SizedBox(height: 10),
            Text(
                'Status : ${widget.transaksi['qty'] == 0 ? 'Belum diproses' : 'Selesai'}',
                style: TextStyle(fontSize: 18, color: Colors.white)),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(218, 251, 138, 0),
                ),
                onPressed: _generatePdf,
                child: Text('Unduh Detail Transaksi',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
