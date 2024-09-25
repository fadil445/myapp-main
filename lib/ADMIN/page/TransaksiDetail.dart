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
              pw.Text('------------------------------------'),
              pw.SizedBox(height: 4),
              pw.Text('ID User: ${widget.transaksi['id_user']}'),
              pw.Text('ID Transaksi: ${widget.transaksi['transaksi_id']}'),
              pw.SizedBox(height: 4),
              pw.Text('------------------------------------'),
              pw.SizedBox(height: 4),
              pw.Text('Nama: ${widget.transaksi['nama_user']}'),
              pw.SizedBox(height: 2),
              pw.Text('Tanggal: ${widget.transaksi['create_transaksi']}'),
              pw.SizedBox(height: 2),
              pw.Text('Jumlah Barang: ${widget.transaksi['qty']}'),
              pw.SizedBox(height: 2),
              pw.Text('Jumlah Transaksi: ${widget.transaksi['total_transaksi']}'),
              pw.SizedBox(height: 2),
              pw.Text('Metode Pembayaran: ${widget.transaksi['metode_pembayaran']}'),
              pw.SizedBox(height: 2),
              pw.Text('Status: ${widget.transaksi['qty'] == 0 ? 'Belum diproses' : 'Selesai'}',),
              pw.SizedBox(height: 9),
              pw.Text('*Nb. Pengiriman diluar kota surakarta dikenakan\npembayaran ongkir secara Cash On Delivery'),
              pw.SizedBox(height: 2),
            ],
          );
        },
      ),
    );

    final outputFile = await _savePdfToFile(pdf);

    if (outputFile != null) {
      Printing.sharePdf(
        bytes: outputFile.readAsBytesSync(),
        filename: 'Transaksi ${widget.transaksi['nama_user']}.pdf',
      );
    }
  }

  Future<File?> _savePdfToFile(pw.Document pdf) async {
    try {
      final outputFile = File(
          '${(await getTemporaryDirectory()).path}/Transaksi ${widget.transaksi['nama_user']}.pdf');
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
        title: Text('Detail Transaksi'),
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
            Text('ID User: ${widget.transaksi['id_user']}',
              style: TextStyle(fontSize: 15, color: Colors.white),),
            SizedBox(height: 10),
            Text('ID Transaksi: ${widget.transaksi['transaksi_id']}',
              style: TextStyle(fontSize: 15, color: Colors.white),),
            SizedBox(height: 5),
            Text('----------------------------------------------------------',
              style: TextStyle(fontSize: 15, color: Colors.white),),
            SizedBox(height: 25),
            Text('Nama: ${widget.transaksi['nama_user']}',
              style: TextStyle(fontSize: 15, color: Colors.white),),
            SizedBox(height: 10),
            Text('Jumlah Barang: ${widget.transaksi['qty']}',
                style: TextStyle(fontSize: 15, color: Colors.white)),
            SizedBox(height: 10),
            Text('Jumlah Transaksi: Rp.${widget.transaksi['total_transaksi']}',
                style: TextStyle(fontSize: 15, color: Colors.white)),
            SizedBox(height: 10),
            Text('Metode Pembayaran: ${widget.transaksi['metode_pembayaran']}',
                style: TextStyle(fontSize: 15, color: Colors.white)),
            SizedBox(height: 10),
            Text('Tanggal: ${DateTime.parse(widget.transaksi['create_transaksi']).toString()}',
                style: TextStyle(fontSize: 15, color: Colors.white)),
            SizedBox(height: 10),
            Text('Status Pembayaran: ${widget.transaksi['qty'] == 0 ? 'Belum diproses' : 'Selesai'}',
                style: TextStyle(fontSize: 15, color: Colors.white)),
            SizedBox(height: 40),
            Text('*Nb. Pengiriman diluar kota surakarta dikenakan pembayaran ongkir secara Cash On Delivery',
                style: TextStyle(fontSize: 15, color: Colors.white)),
            SizedBox(height: 50),
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
