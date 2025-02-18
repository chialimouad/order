import 'dart:convert';

import 'package:femina/screens/test.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Form Key for validation
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberMe = false;
  bool isPasswordVisible = false;
  bool isLoading = false; // To show loading indicator

Future<void> _loginUser() async {
  if (!_formKey.currentState!.validate()) {
    return; // Stop if the form is invalid
  }

  setState(() {
    isLoading = true;
  });

  final String apiUrl = "https://orderburger.onrender.com/api/users/login";

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": _emailController.text.trim(),
        "password": _passwordController.text.trim(),
      }),
    );

    setState(() {
      isLoading = false;
    });

    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);

      if (responseData["success"] == true && responseData.containsKey("token")) {
        String token = responseData["token"];
        print("User Token: $token");

        // ✅ Store token in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("auth_token", token);

        // ✅ Navigate to the dashboard or next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BurgerOrderApp()),
        );
      } else {
        _showErrorDialog(responseData["message"] ?? "Login failed!");
      }
    } else {
      final errorData = jsonDecode(response.body);
      _showErrorDialog(errorData["message"] ?? "Login failed!");
    }
  } catch (error) {
    print("Login Error: $error");
    setState(() {
      isLoading = false;
    });
    _showErrorDialog("An error occurred. Please try again later.");
  }
}


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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey, // Assign form key
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.08),

                  // Logo
                  Image.asset('images/orderlogo.png', height: 150), // Remplace avec ton logo
                  SizedBox(height: 10),
           

                  _buildSocialButtongoogle("Continue with Google", FontAwesomeIcons.google),
                  SizedBox(height: 10),
                  _buildSocialButtonapple("Continue with Apple", FontAwesomeIcons.apple),

                  SizedBox(height: 20),
                  _buildDivider(),
                  SizedBox(height: 20),

                  // Champs Email et Mot de passe
                  _buildTextField(
                    hintText: "Email address",
                    icon: Icons.email_outlined,
                    isPassword: false,
                    controller: _emailController,
                  ),
                  SizedBox(height: 10),
                  _buildTextField(
                    hintText: "Password",
                    icon: Icons.lock_outline,
                    isPassword: true,
                    controller: _passwordController,
                  ),

                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        activeColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value!;
                          });
                        },
                      ),
                      Text("Remember me", style: TextStyle(fontSize: 14)),
                    ],
                  ),

                  SizedBox(height: 10),

                  // Bouton Sign In avec Validation
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
_loginUser();                      
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: Size(double.infinity, 55),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Sign in", style: TextStyle(fontSize: 18,color: Colors.white)),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward, size: 20,color: Colors.white,),
                      ],
                    ),
                  ),

                  SizedBox(height: 15),

                  TextButton(
                    onPressed: () {
                      print("Forgot Password clicked!");
                    },
                    child: Text(
                      "Forgot password ??",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Champ de texte avec validation
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
          return "This field is required"; // Message d'erreur si vide
        }
        if (hintText == "Email address" && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return "Enter a valid email"; // Validation email
        }
        if (hintText == "Password" && value.length < 6) {
          return "Password must be at least 6 characters"; // Validation mot de passe
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
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.black12),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }
  Widget _buildSocialButtonapple(String text, IconData icon) {
    return OutlinedButton(
      onPressed: () {
        print("$text clicked!");
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.black54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
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
  Widget _buildSocialButtongoogle(String text, IconData icon) {
    return OutlinedButton(
      onPressed: () {
        print("$text clicked!");
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.black54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
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
        Expanded(
          child: Divider(
            thickness: 1,
            color: Colors.black26,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text("or", style: TextStyle(fontSize: 16, color: Colors.black54)),
        ),
        Expanded(
          child: Divider(
            thickness: 1,
            color: Colors.black26,
          ),
        ),
      ],
    );
  }
}
