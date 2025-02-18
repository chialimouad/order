  import 'dart:async';

  import 'package:femina/screens/old/loginscreen.dart';
import 'package:femina/screens/welcomeScreen.dart';
  import 'package:flutter/material.dart';
  import 'package:google_fonts/google_fonts.dart';
  import 'package:flutter_animate/flutter_animate.dart';
  class Spalshscreen extends StatefulWidget {
  const Spalshscreen({super.key});

  @override
  State<Spalshscreen> createState() => _SpalshscreenState();
  }

  class _SpalshscreenState extends State<Spalshscreen> with SingleTickerProviderStateMixin{
  late AnimationController _controller;

  @override
  void initState() {
  // TODO: implement initState
  super.initState();
  _controller = AnimationController(
  vsync: this,
  duration: const Duration(seconds: 1), // Adjust duration as needed
  );
  _controller.addStatusListener((status) {
  if (status == AnimationStatus.completed) {
  // Navigate to the next page when the animation finishes
  Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => WelcomeScreen()),
  );
  }
  });
  _controller.forward();

  }
  @override
  void dispose() {
  super.dispose();
  _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
  return Scaffold(
  body: Container(
  child: Center(
  child:  Image.asset('images/order1.jpg')

  ),
  ),
  );
  }
  }