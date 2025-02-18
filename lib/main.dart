import 'package:femina/screens/dashboard.dart';
import 'package:femina/screens/spalshscreen.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  bool isTokenValid = token != null && !JwtDecoder.isExpired(token);

  runApp(MyApp(isTokenValid: isTokenValid));
}

class MyApp extends StatelessWidget {
  final bool isTokenValid;
  const MyApp({Key? key, required this.isTokenValid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      bool isCartVisible = true;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isTokenValid==false? BurgerOrderScreen(isCartVisible: false,) : Spalshscreen(),
    );
  }
}
