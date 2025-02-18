import 'dart:async';
import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  int _orderStatus = 0; // 0: Confirmation, 1: Preparing, 2: Delivery
  bool _isLoading = true; // Pour afficher le progress indicator au début

  @override
  void initState() {
    super.initState();
    _startOrderProcess();
  }

  void _startOrderProcess() {
    Timer(Duration(seconds: 5), () {
      setState(() {
        _isLoading = false;
        _orderStatus = 1;
      });

      Timer(Duration(seconds: 5), () {
        setState(() {
          _orderStatus = 2;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Color cardColor = _orderStatus == 0
        ? Colors.amber.shade100
        : _orderStatus == 1
            ? Colors.green.shade100
            : Colors.white;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),

              // Header avec profil et icône panier
              Row(
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.08,
                    backgroundColor: Colors.black,
                    child: Text(
                      "SA",
                      style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.05),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sayah Abdel-Ilah",
                        style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "10 000 Points",
                        style: TextStyle(color: Colors.grey, fontSize: screenWidth * 0.035),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.shopping_cart, color: Colors.red, size: screenWidth * 0.07),
                ],
              ),

              SizedBox(height: screenHeight * 0.03),

              // Carte de suivi de commande
              Container(
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Aujourd'hui",
                        style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold)),
                    SizedBox(height: screenHeight * 0.015),

                    // Order Confirmation
                    ListTile(
                      leading: Icon(
                        _orderStatus >= 0 ? Icons.check_circle : Icons.circle_outlined,
                        color: Colors.green,
                        size: screenWidth * 0.07,
                      ),
                      title: Text(
                        "Order confirmation",
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      trailing: _isLoading
                          ? SizedBox(
                              width: screenWidth * 0.05,
                              height: screenWidth * 0.05,
                              child: CircularProgressIndicator(strokeWidth: 1),
                            )
                          : null,
                    ),

                    // Order Preparing
                    ListTile(
                      leading: Icon(
                        _orderStatus >= 1 ? Icons.check_circle : Icons.circle_outlined,
                        color: Colors.green,
                        size: screenWidth * 0.07,
                      ),
                      title: Text("Order preparing"),
                    ),

                    // Order in Delivery
                    ListTile(
                      leading: Icon(
                        _orderStatus >= 2 ? Icons.check_circle : Icons.circle_outlined,
                        color: Colors.green,
                        size: screenWidth * 0.07,
                      ),
                      title: Text("Order in delivery"),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // Liste des commandes (avec scroll)
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Order N-434523045",
                                style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "12/02/2024",
                                style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.grey),
                              ),
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios, color: Colors.red, size: screenWidth * 0.05),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
