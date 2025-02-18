import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Settings", style: TextStyle(color: Colors.black, fontSize: 20)),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            
            // Avatar
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.deepPurple.shade900,
                  child: Text("SA", style: TextStyle(color: Colors.white, fontSize: 24)),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.camera_alt, size: 15, color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            
            // Nom d'utilisateur
            Text(
              "Sayah abdel-ilah",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            
            // Icône de modification
            IconButton(
              icon: Icon(Icons.edit, size: 18, color: Colors.black),
              onPressed: () {},
            ),
            
            SizedBox(height: 20),
            
            // Liste des paramètres
            SettingOption(icon: Icons.person, title: "Profile"),
            SettingOption(icon: Icons.info, title: "Terms and policy"),
            SettingOption(icon: Icons.call, title: "Service Center"),
            
            Spacer(),
            
            // Bouton Logout
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text("Log-out", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingOption extends StatelessWidget {
  final IconData icon;
  final String title;

  SettingOption({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          child: Icon(icon, color: Colors.black),
        ),
        title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
        onTap: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
