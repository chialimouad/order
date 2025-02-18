import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'profilescreeen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false; // To show loading indicator



  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.08),

                  Image.asset(
                    'images/orderlogo.png',
                    height: screenHeight * 0.2,
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  _buildTextField(
                    hintText: "Firstname",
                    icon: Icons.person,
                    isPassword: false,
                    controller: firstnameController,
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  _buildTextField(
                    hintText: "Lastname",
                    icon: Icons.person,
                    isPassword: false,
                    controller: lastnameController,
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  _buildTextField(
                    hintText: "Email address",
                    icon: Icons.email_outlined,
                    isPassword: false,
                    controller: _emailController,
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  _buildTextField(
                    hintText: "Password",
                    icon: Icons.lock_outline,
                    isPassword: true,
                    controller: _passwordController,
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  _buildDivider(),
                  SizedBox(height: screenHeight * 0.02),

                  _buildSocialButton("Continue with Google", FontAwesomeIcons.google),
                  SizedBox(height: screenHeight * 0.015),
                  _buildSocialButton("Continue with Apple", FontAwesomeIcons.apple),

                  SizedBox(height: screenHeight * 0.06),

                  isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
  onPressed: () {
    if (_formKey.currentState!.validate()) { // Validate the form
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(
            firstName: firstnameController.text,
            lastName: lastnameController.text,
            email: _emailController.text,
            password: _passwordController.text,
          ),
        ),
      );
    } else {
      _showErrorDialog("Veuillez remplir tous les champs correctement.");
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.redAccent,
    minimumSize: Size(double.infinity, screenHeight * 0.07),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  child: Text(
    "Suivant →",
    style: TextStyle(
      color: Colors.white,
      fontSize: screenWidth * 0.05,
    ),
  ),
),


                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    required bool isPassword,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "This field is required";
        }
        if (hintText == "Email address" && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return "Enter a valid email";
        }
        if (hintText == "Password" && value.length < 6) {
          return "Password must be at least 6 characters";
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black54),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              )
            : null,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.black12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildSocialButton(String text, IconData icon) {
    return OutlinedButton(
      onPressed: () {
        print("$text clicked!");
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.black54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        minimumSize: Size(double.infinity, 55),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black, size: 18),
          SizedBox(width: 10),
          Text(text, style: TextStyle(color: Colors.black, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(thickness: 1, color: Colors.black26)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text("or", style: TextStyle(fontSize: 16, color: Colors.black54)),
        ),
        Expanded(child: Divider(thickness: 1, color: Colors.black26)),
      ],
    );
  }
}
