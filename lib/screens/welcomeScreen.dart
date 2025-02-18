import 'package:flutter/material.dart';
import 'loginscreen1.dart';
import 'signup.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Récupérer la taille de l'écran
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFF1A0A29), // Couleur de fond sombre
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
          children: [
            SizedBox(height: screenHeight * 0.05), // Espacement du haut

            // Image responsive
            Center(
              child: Container(
                width: screenWidth * 0.8,  // 80% de la largeur de l'écran
                height: screenHeight * 0.35, // 35% de la hauteur de l'écran
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  image: DecorationImage(
                    image: AssetImage('images/orderpiceat.png'),
                    fit: BoxFit.cover, 
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.04),

            // Titre Bienvenue
            Text(
              "Bienvenue",
              style: TextStyle(
                fontSize: screenWidth * 0.09,  // Taille dynamique du texte
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),

            SizedBox(height: screenHeight * 0.015),

            // Texte de description responsive
            Text(
              "There are many variations of passages of Lorem Ipsum available, "
              "but the majority have suffered alteration in some form",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white70,
                fontSize: screenWidth * 0.045,
              ),
            ),

            Spacer(),

            // Boutons Responsifs
            Column(
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.redAccent, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: Size(double.infinity, screenHeight * 0.07),
                  ),
                  child: Text(
                    "Se connecter",
                    style: TextStyle(color: Colors.redAccent, fontSize: screenWidth * 0.05),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: Size(double.infinity, screenHeight * 0.07),
                  ),
                  child: Text(
                    "Créer votre compte",
                    style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.05),
                  ),
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.03),
          ],
        ),
      ),
    );
  }
}
