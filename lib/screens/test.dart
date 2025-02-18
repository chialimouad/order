import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:femina/screens/Continueorder1.dart';
import 'package:flutter/material.dart';

class BurgerOrderApp extends StatefulWidget {
  @override
  _BurgerOrderAppState createState() => _BurgerOrderAppState();
}

class _BurgerOrderAppState extends State<BurgerOrderApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    BurgerOrderScreen(),
    OrderHistoryScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}




class BurgerOrderScreen extends StatefulWidget {
  @override
  _BurgerOrderScreenState createState() => _BurgerOrderScreenState();
}

class _BurgerOrderScreenState extends State<BurgerOrderScreen> {
  List<Map<String, dynamic>> burgers = [];
  int totalPrice = 0;
  int totalPoints = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBurgers();
  }
Future<void> fetchBurgers() async {
  final url = Uri.parse('https://orderburger.onrender.com/api/products');
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print("Fetched Data: $data"); // Debugging: Print API response

      setState(() {
        burgers = data.map((item) => {
              'id': item['id'],
              'productName': item['productName'] ?? "No Name",
              'description': item['description'] ?? "No Description",
              'price': item['price'] ?? 0,
              'point': item['point'] ?? 0,
              'quantity': 0, 
              'image': item['image'] != null 
                  ? "https://orderburger.onrender.com/uploads/${item['image']}" 
                  : 'images/burger.png', // Default image
            }).toList();
        isLoading = false;
      });
    } else {
      print("Failed to load data: ${response.statusCode}");
    }
  } catch (e) {
    print("Error fetching burgers: $e");
  }
}


  void updateTotal() {
    totalPrice = burgers.fold<int>(0, (sum, item) => sum + ((item['quantity'] as int) * (item['price'] as int)));
    totalPoints = burgers.fold<int>(0, (sum, item) => sum + ((item['quantity'] as int) * (item['point'] as int)));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.black,
                          child: Text("SA", style: TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Sayah Abdel-Ilah",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                  
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.shopping_bag, color: Colors.red, size: 30),
                      ],
                    ),
                    SizedBox(height: 40),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        image: DecorationImage(
                          image: AssetImage('images/banner.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("Our Burgers", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),

                    // Display burgers dynamically
   isLoading
    ? Center(child: CircularProgressIndicator())
    : burgers.isEmpty
        ? Center(child: Text("No burgers available!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))) 
        : SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,  // Adjust height to prevent overflow
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: burgers.length,
              itemBuilder: (context, index) {
                final burger = burgers[index];

                return Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,  // Align text to left
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),  // Rounded image corners
                        child: Image.network(
                          burger['image'],
                          height: 120,  // Smaller image to prevent overflow
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset('images/burger.png', height: 120, fit: BoxFit.cover);  // Fallback image
                          },
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        burger['productName'] ?? "No Name",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFF44336)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,  // Prevents overflow
                      ),
                      SizedBox(height: 4),
                      Text(
                        burger['description'] ?? "No Description",
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,  // Prevents long text issues
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${burger['price']} DA / ${burger['point']} Points",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    if (burger['quantity'] > 0) burger['quantity']--;
                                    updateTotal();
                                  });
                                },
                              ),
                              Text("${burger['quantity']}", style: TextStyle(fontSize: 16)),
                              IconButton(
                                icon: Icon(Icons.add, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    burger['quantity']++;
                                    updateTotal();
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

                    SizedBox(height: 20),
                    Text("Total: ${totalPrice}DA or ${totalPoints} Points",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: totalPrice == 0 ? null : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ContinueOrder()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: totalPrice == 0 ? Colors.grey : Colors.red,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text("Order Now", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}




class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  int _orderStatus = 0;
  List<Map<String, dynamic>> orders = [];
  bool _isLoading = true;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchOrders();
    Timer.periodic(Duration(seconds: 10), (timer) {
      fetchOrders();
    });
  }

  Future<void> fetchOrders() async {
    try {
      final response = await http.get(Uri.parse('https://orender.render.com/remd/orders'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          orders = data.map((order) => {
                'id': order['id'],
                'date': order['date'],
              }).toList();
          _isLoading = false;
        });
      } else {
        print("Failed to load orders");
      }
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    // Récupération des tailles d'écran
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Color cardColor = Colors.grey[200]!;


    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        width: screenWidth * 0.75,
        child: OrderDetailsDrawer(screenWidth: screenWidth, screenHeight: screenHeight, orderId: '77',),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.05),

         Row(
  children: [
    CircleAvatar(
      radius: 30,
      backgroundColor: Colors.black,
      child: Text("SA", style: TextStyle(color: Colors.white, fontSize: 18)),
    ),
    SizedBox(width: 10),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Sayah Abdel-Ilah", 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),

      ],
    ),
    Spacer(),
    Icon(Icons.shopping_bag, color: Colors.red, size: 30),
  ],
),
            SizedBox(height: screenHeight * 0.03),

       
            SizedBox(height: screenHeight * 0.03),
            Container(child: OrderStatusContainer(orderId: "hh",),),


            // Liste des commandes
  Expanded(
  child: _isLoading
      ? Center(child: CircularProgressIndicator()) // Show loading spinner while fetching data
      : ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return TextButton(
              onPressed: _openDrawer,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                ),
                backgroundColor: Colors.white,
              ),
              child: ListTile(
                title: Text(
                  "Order N-${orders[index]['id']}", // Dynamic order ID
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.045),
                ),
                subtitle: Text(
                  orders[index]['date'], // Dynamic date from backend
                  style: TextStyle(fontSize: screenWidth * 0.035),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.red, size: screenWidth * 0.05),
              ),
            );
          },
        ),
),

          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String title, int statusIndex, double screenWidth) {
    return ListTile(
      leading: Icon(
        _orderStatus >= statusIndex ? Icons.check_circle : Icons.circle_outlined,
        color: _orderStatus >= statusIndex ? Colors.green : Colors.black,
        size: screenWidth * 0.06,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: _orderStatus >= statusIndex ? Colors.green : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: screenWidth * 0.045,
        ),
      ),
      trailing: _isLoading && statusIndex == 0 ? CircularProgressIndicator(strokeWidth: 1) : null,
    );
  }
}

class OrderStatusContainer extends StatefulWidget {
  final String orderId;

  OrderStatusContainer({required this.orderId});

  @override
  _OrderStatusContainerState createState() => _OrderStatusContainerState();
}

class _OrderStatusContainerState extends State<OrderStatusContainer> {
  int orderStatus = 0; // Default status: "Order Confirmation"
  final String apiUrl = "https://your-backend.com/api/orders/";

  @override
  void initState() {
    super.initState();
    fetchOrderStatus();
  }

  // Function to fetch order status from backend
  Future<void> fetchOrderStatus() async {
    try {
      final response = await http.get(Uri.parse("$apiUrl${widget.orderId}"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        int newStatus = data["status"];

        if (mounted && orderStatus != newStatus) {
          setState(() {
            orderStatus = newStatus;
          });
        }
      }
    } catch (e) {
      print("Error fetching order status: $e");
    }

    // Auto-refresh every 5 seconds
    Future.delayed(Duration(seconds: 5), fetchOrderStatus);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Color cardColor = Colors.grey[200]!;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Aujourd'hui",
            style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: screenHeight * 0.015),

          _buildStatusItem("Order Confirmation", 0, orderStatus, screenWidth),
          _buildStatusItem("Order Preparing", 1, orderStatus, screenWidth),
          _buildStatusItem("Order in Delivery", 2, orderStatus, screenWidth),
        ],
      ),
    );
  }

  // Function to build order status item
Widget _buildStatusItem(String title, int step, int currentStatus, double screenWidth) {
  bool isCompleted = step <= currentStatus; // Completed or current step

  return Row(
    children: [
      Icon(
        Icons.check_circle, // Always a check icon
        color: isCompleted ? Colors.green : Colors.grey, // Turns green when status >= step
        size: screenWidth * 0.06,
      ),
      SizedBox(width: screenWidth * 0.02),
      Text(
        title,
        style: TextStyle(
          fontSize: screenWidth * 0.045,
          fontWeight: FontWeight.bold,
          color: isCompleted ? Colors.green : Colors.black, // Turns green when status >= step
        ),
      ),
    ],
  );
}

}



class OrderStatusProvider with ChangeNotifier {
  int _orderStatus = 0; // Default to "Order Confirmation"
  int get orderStatus => _orderStatus;

  final String orderId;
  final String apiUrl = "https://your-backend.com/api/orders/";

  OrderStatusProvider(this.orderId) {
    fetchOrderStatus();
  }

  Future<void> fetchOrderStatus() async {
    try {
      final response = await http.get(Uri.parse("$apiUrl$orderId"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        int newStatus = data["status"];

        if (_orderStatus != newStatus) {
          _orderStatus = newStatus;
          notifyListeners(); // Notify UI of the change
        }
      }
    } catch (e) {
      print("Error fetching order status: $e");
    }
  }

  // Polling the server every 5 seconds for updates
  void startListening() {
    Future.delayed(Duration(seconds: 5), () async {
      await fetchOrderStatus();
      startListening(); // Recursive call to keep polling
    });
  }
}





class OrderDetailsDrawer extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final String orderId;

  OrderDetailsDrawer({
    required this.screenWidth,
    required this.screenHeight,
    required this.orderId,
  });

  @override
  _OrderDetailsDrawerState createState() => _OrderDetailsDrawerState();
}

class _OrderDetailsDrawerState extends State<OrderDetailsDrawer> {
  bool _isLoading = true;
  Map<String, dynamic>? orderDetails;
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  Future<void> _fetchOrderDetails() async {
    try {
      // Replace with your backend API URL
      final String apiUrl = "https://your-backend.com/api/orders/${widget.orderId}";
      
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          orderDetails = {
            "date": data["order_date"],
            "total": data["total_price"].toString() + "DA",
            "items": List<Map<String, dynamic>>.from(data["items"]),
          };
          products = orderDetails!["items"];
          _isLoading = false;
        });
      } else {
        throw Exception("Failed to load order details");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error fetching order details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(widget.screenWidth * 0.05),
      color: Colors.white,
      child: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Order N-${widget.orderId}",
                      style: TextStyle(fontSize: widget.screenWidth * 0.05, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red, size: widget.screenWidth * 0.06),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                Text(orderDetails?["date"] ?? "", style: TextStyle(color: Colors.grey, fontSize: widget.screenWidth * 0.04)),
                SizedBox(height: widget.screenHeight * 0.015),

                // If there are no products, show an image
                products.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Image.asset("images/no_orders.png", width: widget.screenWidth * 0.6),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            var item = products[index];
                            return OrderItem(
                              name: item["name"],
                              price: item["price"].toString() + "DA",
                              quantity: item["quantity"],
                              screenWidth: widget.screenWidth,
                            );
                          },
                        ),
                      ),

                SizedBox(height: widget.screenHeight * 0.015),

                // Total and Cancel Button
                Text(
                  "Total: ${orderDetails?["total"] ?? "0DA"}",
                  style: TextStyle(fontSize: widget.screenWidth * 0.05, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: widget.screenHeight * 0.015),

                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement cancel order API call
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(widget.screenWidth * 0.03),
                    ),
                    padding: EdgeInsets.symmetric(vertical: widget.screenHeight * 0.02),
                  ),
                  child: Center(
                    child: Text(
                      "Annuler la commande",
                      style: TextStyle(color: Colors.white, fontSize: widget.screenWidth * 0.045),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}



class OrderItem extends StatelessWidget {
  final String name;
  final String price;
  final int quantity;
  final double screenWidth;

  OrderItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage("images/burger.png"),
        radius: screenWidth * 0.06,
      ),
      title: Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.045)),
      subtitle: Text(price, style: TextStyle(fontSize: screenWidth * 0.04)),
      trailing: Text("x$quantity", style: TextStyle(color: Colors.red, fontSize: screenWidth * 0.045)),
    );
  }
}








class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data when the screen loads
  }

  Future<void> _fetchUserData() async {
    String apiUrl = "https://orderburger.onrender.com/api/users/profile";

    try {
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          nameController.text = data["firstName"] ?? "No Name";
          lastNameController.text = data["lastName"] ?? "No Last Name";
          phoneController.text = data["phoneNumber"] ?? "No Phone";
        });
      } else {
        print("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "First Name"),
              ),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: "Last Name"),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _updateProfile();
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _updateProfile() async {
    String apiUrl = "https://orderburger.onrender.com/api/users/profile";
    Map<String, String> body = {
      "firstName": nameController.text,
      "lastName": lastNameController.text,
      "phoneNumber": phoneController.text,
    };

    try {
      var response = await http.post(Uri.parse(apiUrl), body: body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update profile!")),
        );
      }
    } catch (e) {
      print("Error updating profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating profile!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: screenWidth * 0.06),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Settings",
            style: TextStyle(color: Colors.black, fontSize: screenWidth * 0.05)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.03),

              // Avatar
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.15,
                    backgroundColor: Colors.deepPurple.shade900,
                    child: Text(
                      "${nameController.text.isNotEmpty ? nameController.text[0] : 'S'}"
                      "${lastNameController.text.isNotEmpty ? lastNameController.text[0] : 'A'}",
                      style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.07),
                    ),
                  ),
                  Positioned(
                    bottom: screenWidth * 0.02,
                    right: screenWidth * 0.02,
                    child: CircleAvatar(
                      radius: screenWidth * 0.05,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.camera_alt, size: screenWidth * 0.05, color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.015),

              // User Name
              Text(
                "${nameController.text} ${lastNameController.text}",
                style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold, color: Colors.black),
              ),

              // Edit Icon
              IconButton(
                icon: Icon(Icons.edit, size: screenWidth * 0.05, color: Colors.black),
                onPressed: _showEditDialog,
              ),

              SizedBox(height: screenHeight * 0.03),

              // Settings List
              SettingOption(icon: Icons.person, title: "Profile", screenWidth: screenWidth),
              SettingOption(icon: Icons.info, title: "Terms and policy", screenWidth: screenWidth),
              SettingOption(icon: Icons.call, title: "Service Center", screenWidth: screenWidth),

              SizedBox(height: screenHeight * 0.05),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  ),
                  child: Text("Log-out",
                      style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.045)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}


class SettingOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final double screenWidth;

  SettingOption({required this.icon, required this.title, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.015),
      child: ListTile(
        leading: CircleAvatar(
          radius: screenWidth * 0.06,
          backgroundColor: Colors.grey.shade200,
          child: Icon(icon, color: Colors.black, size: screenWidth * 0.06),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: screenWidth * 0.04, color: Colors.black),
        onTap: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}




