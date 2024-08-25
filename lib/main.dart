import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:myapp/USER/all%20page/cartmodel.dart';
import 'USER/Screen/WelcomeScreen.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async {

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  await dotenv.load();

  runApp(
    ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: const MyApp(),
    ),
  );
}
//
class MyApp extends StatelessWidget {
  const MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'inter',
        useMaterial3: true,
      ),
      home: const WelcomeScreen(), // Ganti dengan layar awal yang Anda inginkan
    );
  }
}
