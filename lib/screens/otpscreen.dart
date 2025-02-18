import 'package:femina/screens/test.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  
  OTPVerificationScreen({required this.phoneNumber});

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  List<String> otp = ["", "", "", ""]; // Store the 4-digit OTP
  bool isLoading = false; // Loading state

  // Verify OTP function
  Future<void> _verifyOTP() async {
    String enteredOTP = otp.join(); // Convert list to string
    if (enteredOTP.length != 4) {
      _showErrorDialog("Please enter a valid 4-digit OTP.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("https://orderburger.onrender.com/api/users/phoneVerifyOtp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "phoneNumber": widget.phoneNumber,
          "otp": enteredOTP,
        }),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        // OTP is valid, navigate to the main app
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BurgerOrderApp()),
        );
      } else {
        // OTP is invalid, show an error message
        final errorMessage = jsonDecode(response.body)["message"] ?? "Invalid OTP!";
        _showErrorDialog(errorMessage);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog("Network error. Please try again.");
    }
  }

  // Show error dialog
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
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08, vertical: screenHeight * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

              SizedBox(height: screenHeight * 0.02),

              // Title
              Text(
                "Enter Verification Code",
                style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: screenHeight * 0.01),

              // Description
              Text(
                "Enter the code sent to your number",
                style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.grey),
              ),
              Text(
                widget.phoneNumber.replaceRange(4, widget.phoneNumber.length - 3, "*****"),
                style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: screenHeight * 0.05),

              // OTP Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    width: screenWidth * 0.15,
                    height: screenWidth * 0.15,
                    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: TextStyle(fontSize: screenWidth * 0.08, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        counterText: "",
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          FocusScope.of(context).nextFocus();
                        }
                        setState(() {
                          otp[index] = value;
                        });
                      },
                    ),
                  );
                }),
              ),

              SizedBox(height: screenHeight * 0.05),

              // Verify Button
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.07,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: isLoading ? null : _verifyOTP, // Disable button if loading
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Verify", style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.white)),
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // Resend OTP
              Center(
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Code renvoyé !")));
                  },
                  child: Text("Didn't receive the code? Resend",
                      style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
