import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myapp/USER/all%20page/webViewScreen.dart';
import 'package:provider/provider.dart';
import 'package:myapp/USER/all%20page/cartmodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// MidtransFlutter({required String clientKey}) {}

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String token = '';

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
        setState(() {
          token = data['data'];
        }); 
          return true;
        }else{
          return false;
        }
      }
    }

    return false;
  }
   


  @override
  Widget build(BuildContext context) {
       final cart = Provider.of<CartModel>(context);

    void _proceedToPayment() async {
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user');
      bool pending = await fetchTransaction(userId ?? '');
      prefs.setBool('pending', pending);
            // debugPrint(pending!.toString());
      try {
        final response = await http.post(
          Uri.parse('${dotenv.env['ENDPOINT']}/'), 
          body: {
            'cart': cart.all_items, 
            'payment_type': 'credit_card', // ini bisa dipilih nanti ada dropdown ui / semacamnya
            'user_id': userId ?? '',
            'gross_amount': cart.total.toString(),
            'total' : cart.total_qty.toString(),
            'action' : !pending! ? 'midtrans_create' : 'midtrans_berjalan'
          }
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if(!pending){
            final transactionToken = data['token'] ?? '';
            debugPrint(transactionToken);
            if(transactionToken != '' && this.mounted){
              await prefs.setBool('pending', true);
              setState(() {
                token = transactionToken;
              }); 
            }
          }else{
            final dataPending = data['data'];

            if(data['status'] && this.mounted){
              setState(() {
                token = dataPending;
              });
              debugPrint(token);
            }else{
              setState(() {
                pending == false;
                prefs.setBool('pending', false);
              });
            }
          }
            Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewScreen(url: "https://app.sandbox.midtrans.com/snap/v4/redirection/${token}", userId: userId ?? '',),));

          
        } else {
          print('Failed to create transaction');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal membuat transaksi!')),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan!')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Keranjang',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        leadingWidth: 70,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Color.fromARGB(206, 197, 197, 197),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Card(
                    elevation: 4,
                    shadowColor: Colors.black12,
                    child: ListTile(
                      leading: Image.memory(base64Decode(item.image), width: 50, height: 50),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Text untuk item price
                          Text(
                            'Rp ${(item.price * item.quantity)}',
                            style: TextStyle(fontSize: 16),
                          ),
                          // Row untuk qty dan tombol - +
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () async {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  final res =prefs.getBool('pending');
                                  if(!res!){
                                    cart.decreaseQuantity(item);
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Selesaikan Transaksi Berjalan Dahulu!')),
                                  );
                                  }
                                },
                              ),
                              Text('${item.quantity}'),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () async {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  final res =prefs.getBool('pending');
                                  if(!res!){cart.increaseQuantity(item);}else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Selesaikan Transaksi Berjalan Dahulu!')),
                                  );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Box total dan checkout
          SizedBox(
            height: 130, // Total height for both Text and ElevatedButton
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Column(
                children: [
                  Container(
                    height: 50, // tinggi box Text
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Total Pembayaran : Rp.${(cart.total)}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 10), // Space antara Text and Button
                  Container(
                    height: 40, // tinggi ElevatedButton
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(243, 162, 11, 1),
                      ),
                      onPressed: () {
                        if(cart.items.isNotEmpty){
                        _proceedToPayment();
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Cari Barang Dahulu!')),
                                  );
                        }
                      },
                      child: const Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
