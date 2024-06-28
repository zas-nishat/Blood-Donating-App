import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User currentUser;
  DocumentSnapshot? userSnapshot; // Declare as nullable

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser!;
    getUserData(); // Call getUserData on initialization
  }

  Future<void> getUserData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
      setState(() {
        userSnapshot = documentSnapshot;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: userSnapshot != null
          ? ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: userSnapshot!['profile_picture'] != null
                  ? NetworkImage(userSnapshot!['profile_picture'])
                  : AssetImage("Assets/profile.png") as ImageProvider,
            ),
          ),
          SizedBox(height: 20),
          Text("Name: ${userSnapshot!['name'] ?? 'Not provided'}"),
          SizedBox(height: 10),
          Text("Email: ${userSnapshot!['email'] ?? 'Not provided'}"),
          SizedBox(height: 10),
          Text("Phone Number: ${userSnapshot!['phone_number'] ?? 'Not provided'}"),
          SizedBox(height: 10),
          Text("Location: ${userSnapshot!['location'] ?? 'Not provided'}"),
          SizedBox(height: 10),
          Text("Gender: ${userSnapshot!['gender'] ?? 'Not provided'}"),
          SizedBox(height: 10),
          Text("Blood Group: ${userSnapshot!['blood_group'] ?? 'Not provided'}"),
        ],
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
