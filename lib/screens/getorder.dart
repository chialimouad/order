import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrdersListScreen extends StatefulWidget {
  @override
  _OrdersListScreenState createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  bool isLoading = true;
  bool hasError = false;
  List<Map<String, dynamic>> orders = []; // To store the list of orders

  // Function to fetch all orders
  Future<void> fetchAllOrders() async {
    try {
      // Replace with your API URL to fetch all orders
      final response = await http.get(
        Uri.parse('https://orderburger.onrender.com/orders'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Successfully fetched the orders
        setState(() {
          orders = List<Map<String, dynamic>>.from(json.decode(response.body));
          isLoading = false;
        });
      } else {
        // Handle server error
        setState(() {
          hasError = true;
          isLoading = false;
        });
        print('Failed to fetch orders: ${response.body}');
      }
    } catch (e) {
      // Handle network error
      setState(() {
        hasError = true;
        isLoading = false;
      });
      print('Error fetching orders: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAllOrders(); // Fetch all orders when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Orders"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator()) // Show loading indicator
            : hasError
                ? Center(child: Text('Failed to load orders. Please try again later.')) // Show error message
                : orders.isEmpty
                    ? Center(child: Text('No orders found.')) // No orders available
                    : ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          var order = orders[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              title: Text("Order ID: ${order['orderId']}"),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Restaurant: ${order['restaurant']}"),
                                  Text("Price: ${order['price']} DA"),
                                  Text("Date: ${order['orderDate']}"),
                                  if (order['product'] != null)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(
                                        order['product'].length,
                                        (productIndex) {
                                          var product = order['product']
                                              [productIndex];
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                                "Product: ${product['productId']} - ${product['productName']}"),
                                          );
                                        },
                                      ),
                                    ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.arrow_forward),
                                onPressed: () {
                                  // Navigate to order details screen if needed
                                  // Navigator.push(...);
                                },
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
