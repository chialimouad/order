import 'package:femina/screens/continueorder.dart';
import 'package:femina/screens/test.dart';
import 'package:flutter/material.dart';

class ContinueOrder extends StatefulWidget {
  @override
  _ContinueOrderState createState() => _ContinueOrderState();
}

class _ContinueOrderState extends State<ContinueOrder> {
  String? selectedDepartment;
  String? selectedCoupon;

  final List<String> departments = [
    "FSE - Informatique", "Mathématiques", "Médecine", "Génie Civil",
    "Génie Électrique", "Génie Mécanique", "Économie", "Droit",
    "Lettres", "Philosophie", "Psychologie", "Biologie",
    "Physique", "Chimie"
  ];
  final List<String> coupons = ["0%", "10%", "20%", "30%", "50%"];

  bool isFormFilled() {
    return selectedDepartment != null && selectedCoupon != null;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fontSize = screenWidth < 350 ? 14 : 16; // Adjust font size based on screen width

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView( // Wrap the entire body in a scroll view
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.05), // Adjust spacing based on screen height
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.black,
                  child: Text("SA", style: TextStyle(color: Colors.white, fontSize: fontSize)),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sayah Abdel-Ilah", style: TextStyle(fontSize: fontSize + 2, fontWeight: FontWeight.bold)),
                    Text("10 000 Points", style: TextStyle(color: Colors.grey, fontSize: fontSize)),
                  ],
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.05),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "images/imagechef.png", // Replace with your image
                  height: screenHeight * 0.2,
                ),
                SizedBox(height: screenHeight * 0.05),
              ],
            ),

            Column(
              children: [
                // Department Dropdown
                Row(
                  children: [
                    Icon(Icons.school, color: Colors.black),
                    SizedBox(width: 10),
                    Text("Campus universitaire", style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    underline: SizedBox(),
                    hint: Text("Sélectionner un département", style: TextStyle(fontSize: fontSize)),
                    value: selectedDepartment,
                    onChanged: (value) {
                      setState(() {
                        selectedDepartment = value;
                      });
                    },
                    items: departments.map((dept) {
                      return DropdownMenuItem<String>(
                        value: dept,
                        child: Text(dept, style: TextStyle(fontSize: fontSize)),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16),

                // Coupon Dropdown
                Row(
                  children: [
                    Icon(Icons.local_offer, color: Colors.black),
                    SizedBox(width: 10),
                    Text("Coupon", style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    underline: SizedBox(),
                    hint: Text("Sélectionner un coupon", style: TextStyle(fontSize: fontSize)),
                    value: selectedCoupon,
                    onChanged: (value) {
                      setState(() {
                        selectedCoupon = value;
                      });
                    },
                    items: coupons.map((coupon) {
                      return DropdownMenuItem<String>(
                        value: coupon,
                        child: Text(coupon, style: TextStyle(fontSize: fontSize)),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16),

                // Total Price Text
                Text(
                  "Total : 1200DA ou 250 000 Points",
                  style: TextStyle(fontSize: fontSize + 2, fontWeight: FontWeight.bold, color: Colors.red),
                ),
                SizedBox(height: 10),
              ],
            ),

            // Confirm Button
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: ElevatedButton(
                onPressed: isFormFilled()
                    ? () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => BurgerOrderApp()),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFormFilled() ? Colors.red : Colors.grey,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  "Confirm",
                  style: TextStyle(color: Colors.white, fontSize: fontSize),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
