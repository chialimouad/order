import 'package:femina/screens/otpscreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  ProfileScreen({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  final picker = ImagePicker();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController studentCardController = TextEditingController();

  String initialCountry = 'DZ';
  PhoneNumber number = PhoneNumber(isoCode: 'DZ');
  bool _isChecked = false;
  bool isLoading = false;

  // 📌 Pick an image from the gallery
  Future<void> _pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showErrorDialog("Erreur lors du choix de l'image.");
    }
  }



Future<void> _submitData() async {
  if (!_isChecked) {
    _showErrorDialog("Veuillez accepter les conditions.");
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    final response = await http.post(
      Uri.parse('https://orderburger.onrender.com/api/users/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "firstName": widget.firstName,
        "lastName": widget.lastName,
        "email": widget.email,
        "password": widget.password,
        "phoneNumber": number.phoneNumber,
        "cartEtudiant": studentCardController.text,
      }),
    ).timeout(Duration(seconds: 10)); // ✅ Add timeout to avoid infinite waiting

    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse.containsKey('token')) {
        String token = jsonResponse['token'];
        print("User Token: $token");

        // ✅ Store token in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token);

        // ✅ Navigate to OTP screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerificationScreen(
              phoneNumber: number.phoneNumber!,
            ),
          ),
        );
      } else {
        _showErrorDialog("Token non reçu. Vérifiez la réponse du serveur.");
      }
    } else {
      var jsonResponse = jsonDecode(response.body);
      _showErrorDialog(jsonResponse['message'] ?? "Erreur lors de l'inscription.");
    }
  } catch (e) {
    print("Erreur: $e"); // ✅ Print the error for debugging
    _showErrorDialog("Une erreur s'est produite. Vérifiez votre connexion.");
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}



  // 📌 Show error message
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Erreur"),
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
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 📌 Profile Picture
            Stack(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.black,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Text("SA", style: TextStyle(color: Colors.white, fontSize: 30))
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.camera_alt, size: 18, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            // 📌 Phone Number Input
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number1) {
                setState(() {
                  number = number1;
                });
              },
              initialValue: number,
              textFieldController: phoneController,
              inputDecoration: InputDecoration(
                hintText: 'Entrez votre numéro',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 20),

            // 📌 Étudiant Card Number Field
            TextFormField(
              controller: studentCardController,
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: InputDecoration(
                hintText: 'Numéro de carte étudiant',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Ce champ est obligatoire";
                } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                  return "Veuillez entrer uniquement des chiffres";
                }
                return null;
              },
            ),
            SizedBox(height: 20),

            // 📌 Terms & Conditions Checkbox
            CheckboxListTile(
              value: _isChecked,
              onChanged: (bool? value) => setState(() => _isChecked = value ?? false),
              title: Text("J'accepte les conditions"),
            ),
            Spacer(),

            // 📌 Submit Button
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _isChecked ? _submitData : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isChecked ? Colors.redAccent : Colors.grey,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Suivant →", style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
          ],
        ),
      ),
    );
  }
}
