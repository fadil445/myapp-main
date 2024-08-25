import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myapp/USER/all%20page/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class WebViewScreen extends StatefulWidget {
  final String userId;
  final String url;
  const WebViewScreen({super.key, required this.url, required this.userId});
  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}
class _WebViewScreenState extends State<WebViewScreen> {

  Future<bool> fetchTransaction(String userId) async {

    final response = await http.post(
        Uri.parse('${dotenv.env['ENDPOINT']}/'),  
        body: {
          "user_id": userId,
          "action": "midtrans_berjalan",
        },
      );
    
    if(response.statusCode==200){
      var data = jsonDecode(response.body);
      if(data['status'] && mounted){
        if(data != null){
          return true;
        }else{
          return false;
        }
      }
    }

    return false;
  }

  late WebViewController controller;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(widget.url),
      );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Payment!'),
        leading: TextButton(onPressed: () async {
          bool res = await fetchTransaction(widget.userId);
          if(!res){
            SharedPreferences pend = await SharedPreferences.getInstance();
            pend.setBool('pending', false);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            );
          }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Selesaikan Transaksi!')),
          );
          }
        }, child: Icon(Icons.done)),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}