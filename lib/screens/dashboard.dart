import 'package:femina/screens/test3.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
class BurgerOrderScreen extends StatefulWidget {
   final bool isCartVisible;

  BurgerOrderScreen({required this.isCartVisible});
  @override
  _BurgerOrderScreenState createState() => _BurgerOrderScreenState();
}

class _BurgerOrderScreenState extends State<BurgerOrderScreen> {
 

  int _selectedIndex = 0;
  bool isOrdering = false; // Determines position of navbar & button
 List<String> images = [];
  PageController _pageController = PageController();
  int _currentIndex = 0;
    bool isLoading = true;
List<Map<String, dynamic>> supplements = [];
bool isLoadingSupplements = false;
  int selectedIndex = -1; // Track selected card index
  List<dynamic> products = [];

Future<void> _fetchSupplements(String rsup) async {
  setState(() {
    isLoadingSupplements = true;
  });

  final url = Uri.parse("https://orderburger.onrender.com/api/restaurant/$rsup"); // Remplace par ton URL réelle

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        supplements = data.map<Map<String, dynamic>>((item) => {
          "name": item["name"],
          "price": item["price"],
        }).toList();
        isLoadingSupplements = false;
      });
    } else {
      throw Exception("Erreur de chargement des suppléments");
    }
  } catch (e) {
    print("Erreur: $e");
    setState(() {
      isLoadingSupplements = false;
    });
  }
}

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  void _startAutoScroll() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentIndex < images.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }
  List<Map<String, dynamic>> restaurants = [];
  bool isLoadingRestaurants = true;
  @override
  void initState() {
    super.initState();
    _fetchImages(); // Fetch images from API
    fetchRestaurants();
  }
Future<void> fetchProducts(String rid) async {
  final url = Uri.parse("https://orderburger.onrender.com/api/restaurant/$rid");

  try {
    final response = await http.get(url);
    print("📡 Fetching products for restaurant ID: $rid");
    print("📥 Response Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      print("📥 Response Body: $jsonResponse");

      // ✅ Ensure keys exist before using them
      List<dynamic> fetchedProducts = jsonResponse["product"] ?? [];
      List<dynamic> fetchedSupplements = jsonResponse["SupplementId"] ?? [];
    print("fetched products: $fetchedProducts");
      setState(() {
        products = fetchedProducts.map((product) {
          return {
            "id": product["_id"]?.toString() ?? "No ID", // Product ID
            "productName": product["productName"]?.toString() ?? "No Name",
            "description": product["description"]?.toString() ?? "No Description",
            "price": double.tryParse(product["price"].toString()) ?? 0.0, // Convert price to double
            "image": product["image"]?.toString() ?? "", // Product Image URL
            "SupplementId": (product["SupplementId"] as List?)?.map((s) => s.toString()).toList() ?? [],
          };
        }).toList();

        supplements = fetchedSupplements.map((supplement) {
          return {
            "id": supplement["_id"]?.toString() ?? "No ID", // Supplement ID
            "supplementName": supplement["supplementName"]?.toString() ?? "No Name",
            "description": supplement["description"]?.toString() ?? "No Description",
            "price": double.tryParse(supplement["price"].toString()) ?? 0.0, // Ensure price is double
          };
        }).toList();

        isLoading = false;
      });

      print("✅ Successfully loaded ${products.length} products and ${supplements.length} supplements.");
    } else {
      print("❌ Failed to fetch data: ${response.statusCode}");
      setState(() => isLoading = false);
    }
  } catch (e) {
    print("❌ Error fetching data: $e");
    setState(() => isLoading = false);
  }
}







Future<void> fetchRestaurants() async {
  final url = Uri.parse("https://orderburger.onrender.com/api/restaurant");

  try {
    final response = await http.get(url);
    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse["success"] == true && jsonResponse["data"] is List) {
        List<dynamic> dataList = jsonResponse["data"];

        setState(() {
          restaurants = dataList.map((restaurant) {
            return {
              "id": restaurant["_id"]?.toString() ?? "No ID", // Extracting ID
              "name": restaurant["name"]?.toString() ?? "No Name",
              "image": restaurant["image"]?.toString() ?? "", // Extracting Image URL
              "SupplementId": restaurant["SupplementId"]?.toString() ?? "No SupplementId",
            };
          }).toList();
          isLoading = false;
        });

        print("Extracted Restaurants: $restaurants");
      } else {
        print("Invalid response format: 'data' key is missing or not a list");
      }
    } else {
      print("Failed to load restaurant: ${response.statusCode}");
    }
  } catch (e) {
    print("Error: $e");
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}


Future<void> _fetchImages() async {
  final url = Uri.parse("https://orderburger.onrender.com/api/pubs"); // API URL
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse["success"] == true) {
        List<dynamic> pubs = jsonResponse["data"]["pubs"]; // Extract the correct list

        setState(() {
          images = pubs.map<String>((item) => "https://orderburger.onrender.com/uploads/" + item["image"]).toList(); // Full URL for images
          isLoading = false;
        });

        _startAutoScroll(); // Start scrolling after fetching
      } else {
        throw Exception("API response is unsuccessful");
      }
    } else {
      throw Exception("Failed to load images");
    }
  } catch (e) {
    print("Error fetching images: $e");
    setState(() {
      isLoading = false;
    });
  }
}


Widget _buildRestaurantList() {
  return Container(
    color: Colors.white,
    height: 200, // Adjust as needed
    child: isLoading
        ? Center(child: CircularProgressIndicator()) // Show loader while fetching
        : (restaurants.isEmpty
            ? Center(child: Text("No restaurants available"))
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  return _buildRestaurantCard(restaurants[index], index); // ✅ No extra loop
                },
              )),
  );
}

String? selectedRestaurantId;

Widget _buildRestaurantCard(Map<String, dynamic> restaurant, int index) {
  bool isSelected = selectedIndex == index;
  String imageUrl = restaurant["image"] ?? "";

  return GestureDetector(
    onTap: () {
      setState(() {
        selectedIndex = index; // Update selected index
        selectedRestaurantId = restaurant["id"]; // Store selected restaurant ID
      });
      fetchProducts(restaurant["id"]); // Fetch products for selected restaurant
    },
    child: Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: isSelected ? 5 : 3,
          child: Container(
            width: 360,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color.fromARGB(255, 245, 244, 247),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          "https://orderburger.onrender.com/uploads/$imageUrl",
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        )
                      : Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.grey[300],
                          child: Icon(Icons.fastfood, size: 50, color: Colors.grey),
                        ),
                ),
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isSelected)
          Container(
            width: 50,
            height: 5,
            margin: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
      ],
    ),
  );
}

// void _showProductsBottomSheet() {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.white,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (context) {
//       return FutureBuilder<List<dynamic>>(
//         future: fetchprod(), // Fetching data from API
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text("No products available"));
//           } else {
//             var products = snapshot.data!;
//             return Container(
//               padding: EdgeInsets.all(16),
//               height: MediaQuery.of(context).size.height * 0.6,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Container(
//                       width: 50,
//                       height: 5,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[300],
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     "Products",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 10),
//                   Expanded(
//                     child: ListView.builder(
//   itemCount: products.length,
//   itemBuilder: (context, index) {
//     var product = products[index];

//     // Extract properties safely
//     String imageUrl = product["image"] ?? "";
//     String productName = product["productName"] ?? "Unknown Product";
//     String ingredients = product["description"] ?? "No ingredient info";
//     String price = product["price"] != null ? "${product["price"]} DA" : "N/A";

//     return ListTile(
//       leading: ClipRRect(
//         borderRadius: BorderRadius.circular(8), // Rounded corners for the image
//         child: imageUrl.isNotEmpty
//             ? Image.network(
//                 imageUrl,
//                 width: 50,
//                 height: 50,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) =>
//                     Icon(Icons.broken_image, size: 50, color: Colors.grey),
//               )
//             : Icon(Icons.fastfood, size: 50, color: Colors.grey), // Placeholder
//       ),
//       title: Text(productName, style: TextStyle(fontWeight: FontWeight.bold)),
//       subtitle: Text(ingredients),
//       trailing: Text(price, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
//       onTap: () {
//         // Handle product click
//       },
//     );
//   },
// )

//                   ),
//                 ],
//               ),
//             );
//           }
//         },
//       );
//     },
//   );
// }
bool showCartButton = false; // Track if the cart button is visible


List<Map<String, dynamic>> selectedProducts = [];

  bool isNavShifted = false; // Controls navbar animation
  List<String> selectedSupplements = []; // Store selected supplements

Widget _buildBurgerCard() {
  return isLoading
      ? Center(child: CircularProgressIndicator())
      : products.isEmpty
          ? Center(
              child: Text(
                "No products available",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                physics: BouncingScrollPhysics(), // Smooth scrolling effect
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.72, // Adjusted for better balance
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  var product = products[index];

                  // Handling potential null values
                  String imageUrl = product["image"] ?? "";
                  String productName = product["productName"] ?? "No Name";
                  String description = product["description"] ?? "No Description";
                  String price = product["price"] != null ? "${product["price"]} DA" : "N/A";

                  return Card(
                    
                    color: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ), // **Fixed the parenthesis here**
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Image
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                                  "https://orderburger.onrender.com/uploads/$imageUrl", // Full image URL
                                  width: double.infinity,
                                  height: 260,
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                )
                              : Container(
                                  width: double.infinity,
                                  height: 130,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.fastfood, size: 50, color: Colors.grey),
                                ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    productName,
                                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    description,
                                    style: TextStyle(color: Colors.grey, fontSize: 19),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Spacer(), // **Fixed the Spacer() issue**
                                Text(
                                  price,
                                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold,fontSize: 20),
                                ),
                                SizedBox(height: 5),
                                // "Ajouter" Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(15, 50),
                                      backgroundColor: Color(0xFFFF5152),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
 _showBottomSheet1(
  context,
  product,
  supplements, // ✅ Pass supplements separately
);


                                      Future.delayed(Duration(milliseconds: 500), () {
                                        setState(() {
                                          showCartButton = true;
                                        });
                                      });
                                    },
                                    child: Text(
                                      "Ajouter",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
}


void _showBottomSheet1(BuildContext context, Map<String, dynamic> product, List<dynamic>? supplements) {
  List<String> selectedSupplements = []; // Store selected supplement IDs

  showModalBottomSheet(
    context: context,
    isDismissible: true,
    enableDrag: true,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final screenHeight = MediaQuery.of(context).size.height;
          final screenWidth = MediaQuery.of(context).size.width;
          return Container(
            width: screenWidth,
            height: screenHeight * 0.8,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "🛒 Select Supplements",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Divider(),
                SizedBox(height: 10),

                // Supplements List
                if (supplements == null || supplements.isEmpty)
                  Center(child: Text("No supplements available"))
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: supplements.length,
                      itemBuilder: (context, index) {
                        var supplement = supplements[index];
                        String supplementId = supplement["id"]?.toString() ?? "";

                        bool isSelected = selectedSupplements.contains(supplementId);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedSupplements.remove(supplementId);
                              } else {
                                selectedSupplements.add(supplementId);
                              }
                            });
                          },
                          child: Card(
                            color: isSelected ? Colors.green[300] : Colors.white,
                            child: ListTile(
                              title: Text(supplement["supplementName"] ?? "No Name",style: TextStyle(fontSize: 18),),
                              subtitle: Text(supplement["description"] ?? "",style: TextStyle(fontSize: 18)),
                              trailing: Text("${supplement["price"] ?? 0} DA",style: TextStyle(fontSize: 23)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                SizedBox(height: 10),

                // ✅ "Continuer" Button (Stores the Product + Supplements)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffFF5152),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    List<Map<String, dynamic>> finalSupplements = (supplements ?? [])
                        .where((s) => selectedSupplements.contains(s["id"]?.toString() ?? ""))
                        .map((s) => {
                              "supplementId": s["id"]?.toString() ?? "",
                              "supplementName": s["supplementName"] ?? "Unknown",
                              "price": s["price"] ?? 0
                            })
                        .toList();

                    double totalPrice = double.tryParse(product["price"].toString()) ?? 0.0;
                    for (var s in finalSupplements) {
                      totalPrice += (s["price"] as num?)?.toDouble() ?? 0;
                    }

                    selectedProducts.add({
                      "productId": product["id"]?.toString() ?? "",
                      "productName": product["productName"],
                      "image": product["image"],
                      "price": totalPrice,
                      "selectedSupplements": finalSupplements,
                      "restaurantId": selectedRestaurantId, // ✅ Add restaurantId here
                    });

                    print("✅ Final Selected Supplements: $finalSupplements");
                    print("🛒 Product Added to Cart: ${selectedProducts.last}");

                    Navigator.pop(context);
                    setState(() {
                      showCartButton = true;
                    });
                  },
                  child: Text(
                    "Continuer",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}




void _showCart(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isDismissible: true,
    enableDrag: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: 450,
            padding: EdgeInsets.all(16.0),
            child: Column(
  children: [
    Expanded(
      child: ListView.builder(
        itemCount: selectedProducts.length,
        itemBuilder: (context, index) {
          var product = selectedProducts[index];
                            String imageUrl = product["image"] ?? "";

          return Card(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: ListTile(
              leading:     ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: imageUrl.isNotEmpty
              ? Image.network(
                  "https://orderburger.onrender.com/uploads/$imageUrl", // Full image URL
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.broken_image, size: 50, color: Colors.grey),
                )
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: Icon(Icons.fastfood, size: 50, color: Colors.grey),
                ),
        ),
              title: Text(product["productName"], style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product["selectedSupplements"] != null &&
                      product["selectedSupplements"].isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Supplements:"),
                        ...product["selectedSupplements"].map<Widget>((s) => Text("- ${s["supplementName"]} (${s["price"]} DA)")).toList(),
                      ],
                    ),
                  Text("Total Price: ${product["price"]} DA", style: TextStyle(color: Colors.green)),
                ],
              ),
            ),
          );
        },
      ),
    ),
    if (selectedProducts.isNotEmpty)
      ElevatedButton(
        onPressed: () {
          setState(() {
            selectedProducts.clear(); // Clear the cart when pressed
          });
        },
        child: Text("Clear Cart"),
      ),
  ],
)

          );
        },
      );
    },
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: Colors.white,
  body: Stack(
    children: [
      Column(
        children: [
          Expanded(
            child: SingleChildScrollView( // ✅ Scrollable Content
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    _buildUserProfile(),
                    SizedBox(height: 40),

                    _buildScrollingImageWidget(),
                    SizedBox(height: 40),

                    Text("Our Restaurants", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    _buildRestaurantList(),
                    SizedBox(height: 40),

                    _buildBurgerCard(),

                    SizedBox(height: 120), // ✅ Extra space before navbar
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

// ✅ Fixed Bottom Navigation & Cart Button
Positioned(
  bottom: 20, // Keep it at the bottom
  left: 0,
  right: 0,
  child: SafeArea(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ✅ Conditionally Render Bottom Navigation
          Expanded(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home, "Home", 0),
                ],
              ),
            ),
          ),

          SizedBox(width: 10),

          // ✅ Floating Cart Button & Confirmation Text
          if (showCartButton)
            Row(
              children: [
               // Confirmation Text with Capsule Style
Container(
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.red.shade400, Colors.red.shade600], // Gradient effect
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(20), // Rounded edges
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 8,
        spreadRadius: 2,
        offset: Offset(2, 3), // Slight elevation for a floating effect
      ),
    ],
  ),
  child: Row(
    children: [
      Icon(Icons.shopping_bag, color: Colors.white, size: 18), // 🛍️ Icon for better UX
      SizedBox(width: 6),
      Text(
        "Confirm Your Cart",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.5, // Slight letter spacing for a premium look
        ),
      ),
    ],
  ),
),
SizedBox(width: 10),

                FloatingActionButton(
                  backgroundColor: Color(0xFFFF5152),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  onPressed: () {
                    if (selectedProducts.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Your cart is empty!")),
                      );
                      return;
                    }

                    // Show the cart modal
               showModalBottomSheet(
  context: context,
  isDismissible: true,
  enableDrag: true,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),
  backgroundColor: Colors.white,
  builder: (context) {
    return StatefulBuilder(
      builder: (context, setState) {
        // Calculate the total price
        double totalPrice = selectedProducts.fold(0.0, (total, product) {
          return total + (product["price"] ?? 0).toDouble();
        });

        return Container(
          padding: EdgeInsets.all(16.0),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("🛒 Your Cart", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Divider(),
              SizedBox(height: 10),
              selectedProducts.isEmpty
                  ? Center(child: Text("No products selected"))
                  : Expanded(
                      child: ListView.builder(
                        itemCount: selectedProducts.length,
                        itemBuilder: (context, index) {
                          var product = selectedProducts[index];
                          double productPrice = (product["price"] ?? 0).toDouble();
                          String imageUrl = product["image"] ?? "";

                          return Card(
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: imageUrl.isNotEmpty
                                    ? Image.network(
                                        "https://orderburger.onrender.com/uploads/$imageUrl",
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                      )
                                    : Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        color: Colors.grey[300],
                                        child: Icon(Icons.fastfood, size: 50, color: Colors.grey),
                                      ),
                              ),
                              title: Text(product["productName"], style: TextStyle(fontSize: 18)),
                              subtitle: Text(
                                "Supplements:${(product["selectedSupplements"] as List<dynamic>)
                                    .map((supplement) => supplement["supplementName"]) // Extract names
                                    .join(", ")}",
                                style: TextStyle(fontSize: 22),
                              ),
                              trailing: Text(
                                "${productPrice.toStringAsFixed(2)} DA",
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              SizedBox(height: 10),
              Text(
                "💰 Total Price: ${totalPrice.toStringAsFixed(2)} DA",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              SizedBox(height: 10),
              // Confirm & Clear Cart Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
         onPressed: () {
  if (selectedRestaurantId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please select a restaurant first!")),
    );
    return;
  }
  
  // Calculate totalPrice here before navigating
  double totalPrice = selectedProducts.fold(0.0, (total, product) {
    return total + (product["price"] ?? 0).toDouble();
  });

  List<Map<String, dynamic>> selectedSupplements = selectedProducts
      .expand((product) => (product["selectedSupplements"] ?? []) as List<Map<String, dynamic>>)
      .toList();

  print("🛒 Current Cart Items Before Opening Cart: $selectedProducts");

  // Now, pass the totalPrice to the OrderConfirmationScreen
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => OrderConfirmationScreen(
        restaurantId: selectedRestaurantId!,
        selectedProducts: List<Map<String, dynamic>>.from(selectedProducts),
        selectedSupplements: List<Map<String, dynamic>>.from(selectedSupplements),
        totalPrice: totalPrice, // Pass the totalPrice here
      ),
    ),
  );
},

                      child: Text(
                        "Confirm",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        // Handle cart clearing
                        setState(() {
                          selectedProducts.clear();
                          showCartButton = false; // Hide the cart button
                        });
                        Navigator.pop(context);
                        print("🗑️ Cart Cleared!");
                      },
                      child: Text(
                        "Clear Cart",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  },
);

                  },
                  child: Icon(Icons.shopping_cart, color: Colors.white),
                ),
              ],
            ),
        ],
      ),
    ),
  ),
),

    ],
  ),
);



  }

Future<void> navigateToOrderConfirmation(
  String restaurantId, List<Map<String, dynamic>> selectedSupplements) async {
  
  // 🔹 Filter selected products for the chosen restaurant only
  List<Map<String, dynamic>> filteredProducts = selectedProducts
      .where((product) => product["restaurantId"] == restaurantId)
      .toList();

  if (filteredProducts.isEmpty) {
    print("❌ No products selected for this restaurant!");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("No products selected for this restaurant"), backgroundColor: Colors.red),
    );
    return;
  }

  // Calculate totalPrice here
  double totalPrice = filteredProducts.fold(0.0, (total, product) {
    return total + (product["price"] ?? 0).toDouble();
  });

  // Push the OrderConfirmationScreen and pass totalPrice
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => OrderConfirmationScreen(
        restaurantId: restaurantId,
        selectedProducts: List<Map<String, dynamic>>.from(filteredProducts),
        selectedSupplements: List<Map<String, dynamic>>.from(selectedSupplements),
        totalPrice: totalPrice, // Pass the totalPrice here
      ),
    ),
  );

  if (result == false) {
    // Hide the cart button & clear only the ordered restaurant's products
    setState(() {
      showCartButton = false;
      selectedProducts.removeWhere((product) => product["restaurantId"] == restaurantId);
      selectedSupplements.clear();
    });
  }
}

void _showCartBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isDismissible: true,
    enableDrag: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (context) {
      return Container(
        padding: EdgeInsets.all(16),
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "🛒 My Order",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Divider(),
            SizedBox(height: 10),

            // ✅ Show selected products
            Expanded(
              child: selectedProducts.isEmpty
                  ? Center(child: Text("No products selected"))
                  : ListView.builder(
                      itemCount: selectedProducts.length,
                      itemBuilder: (context, index) {
                        var product = selectedProducts[index];

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ✅ Product Name & Image
                                Row(
                                  children: [
                                    Image.network(
                                      product["image"],
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      product["productName"],
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),

                                // ✅ Price
                                Text("${product["price"]} DA", style: TextStyle(color: Colors.red)),

                                // ✅ Selected Supplements
                                if (product["selectedSupplements"] != null && product["selectedSupplements"].isNotEmpty) ...[
                                  SizedBox(height: 5),
                                  Text(
                                    "Supplements:",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: List.generate(product["selectedSupplements"].length, (i) {
                                      var supplement = product["selectedSupplements"][i];
                                      return Text("- ${supplement["supplementName"]} (${supplement["price"]} DA)");
                                    }),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // ✅ Confirm Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffFF5152),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Confirmer",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    },
  );
}

  
 // **🔄 Auto-Scrolling API Image Widget**
Widget _buildScrollingImageWidget() {
  return Container(
    height: 200,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white, // Fond gris clair en attendant les images
    ),
    child: isLoading
        ? Center(child: CircularProgressIndicator()) // Affiche le loader tant que ça charge
        : (images.isEmpty
            ? Center(child: Text("Aucune image disponible", style: TextStyle(color: Colors.grey)))
            : PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(images[index]),
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                },
              )),
  );
}

  Widget _buildCategoryCard(String imagePath) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
    );
  }




  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = index == _selectedIndex;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.red : Colors.black54),
          Text(label, style: TextStyle(color: isSelected ? Colors.red : Colors.black54)),
        ],
      ),
    );
  }
}
  // **🔹 User Profile Widget**
  Widget _buildUserProfile() {
    return Row(
      children: [
        // Profile Avatar
        CircleAvatar(
          radius: 24,
          backgroundColor: Color(0XFFFF5152), // Dark Purple
          child: Text(
            "OJ",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 12),

        // User Info
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ORDER-JUMBO",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
           
          ],
        ),

        Spacer(), // Pushes icon to right

        // Shopping Bag Icon with Glow
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.redAccent.withOpacity(0.3), blurRadius: 8, spreadRadius: 3)],
          ),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.red,
            child: Icon(Icons.shopping_bag, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }