import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart'; // Import the user provider

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        automaticallyImplyLeading: true, // Back button
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            GestureDetector(
              onTap: () {
                userProvider.updateProfilePicture(
                  'assets/new_profile_picture.png',
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: 20),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(userProvider.profilePicture),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // User Name
            Text(
              userProvider.userName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            // Account Details Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_circle, color: Colors.grey),
                      SizedBox(width: 10),
                      Text(
                        'Account Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.blue),
                    title: Text('Edit Profile'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.email, color: Colors.blue),
                    title: Text('Change Email'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.lock, color: Colors.blue),
                    title: Text('Change Password'),
                    onTap: () {},
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text('Logout', style: TextStyle(color: Colors.red)),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
