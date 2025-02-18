import 'package:femina/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final String restaurantId;
  final List<Map<String, dynamic>> selectedProducts;
  final List<Map<String, dynamic>> selectedSupplements;
  final double totalPrice;

  OrderConfirmationScreen({
    required this.restaurantId,
    required this.selectedProducts,
    required this.selectedSupplements, required this.totalPrice,
  });

  @override
  _OrderConfirmationScreenState createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String initialCountry = 'DZ';
  PhoneNumber number = PhoneNumber(isoCode: 'DZ');
  bool isLoading = false;





  bool isPhoneNumberValid(String phone) {
    return phone.isNotEmpty && phone.length >= 10;
  }

  Future<void> submitOrder() async {
    if (!isPhoneNumberValid(phoneController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please enter a valid phone number"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    if (widget.selectedProducts.isEmpty) {
      print("❌ ERROR: No products selected!");
      return;
    }

    setState(() {
      isLoading = true;
    });();

Map<String, dynamic> orderData = {
  "products": widget.selectedProducts.map((product) {
    String? productId = product["productId"]?.toString();
    if (productId == null || productId.isEmpty) {
      print("❌ Invalid product ID: $product");
      return null;
    }

    List<String> supplementIds = [];
    if (product["selectedSupplements"] != null && product["selectedSupplements"] is List) {
      supplementIds = (product["selectedSupplements"] as List)
          .where((supplement) => supplement is Map<String, dynamic> && supplement["_id"] != null)
          .map((supplement) => supplement["_id"].toString())
          .toList();
    }

    return {
      "productId": productId,
      "SupplementId": supplementIds,
      "Quantity": product["quantity"] ?? 1,
    };
  }).where((element) => element != null).toList(),

  "location": "User location here",
  "restaurent": widget.restaurantId,
  "price": widget.totalPrice, // Use double for price
  "phoneNumber": phoneController.text,
  "user": "67b11a4a7e7eb7bce2cd705c", // Adjust this to reflect the actual user ID
  "status": 0,
};


    print("📝 JSON Payload Sent: ${jsonEncode(orderData)}");

    try {
      final response = await http.post(
        Uri.parse("https://orderburger.onrender.com/api/order"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(orderData),
      );

      print("📩 Server Response: ${response.body}");

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          headerAnimationLoop: false,
          animType: AnimType.topSlide,
          title: 'Order Sent',
          desc: 'Your order has been successfully placed.',
          btnOkOnPress: () {
            Future.delayed(Duration(milliseconds: 300), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BurgerOrderScreen(isCartVisible: false),
                ),
              );
            });
          },
          btnOkText: 'Okay',
        ).show();
      } else {
        print("❌ Failed to submit order: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to submit order: ${response.body}"),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print("⚠️ Error occurred: $e");

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error occurred: $e"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Confirmation",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Color(0xffFF5152)
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
         color:  Colors.white
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Confirm Your Order",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),

                // Phone Number Field
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Phone Number",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber number1) {
                            setState(() {
                              number = number1;
                            });
                          },
                          initialValue: number,
                          textFieldController: phoneController,
                          inputDecoration: InputDecoration(
                            hintText: 'Enter your phone number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Description Field
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: descriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "Add any special instructions...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Total Price
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "${widget.totalPrice} DA",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Confirm Button
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: submitOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffFF5152),
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          "Confirm Order",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}