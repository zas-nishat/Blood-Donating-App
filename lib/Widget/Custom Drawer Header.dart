import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../Function/UserProfileModel.dart';
import '../Screens/Find Donor Dire/DonorRegisterForm_Screen.dart';
import '../Screens/Find Donor Dire/FindDonor_Page.dart';
import '../Screens/My Blood Request Dire/BloodRequestForm.dart';
import '../Screens/Profile_Screen.dart';

class CustomDrawerHeader extends StatefulWidget {
  const CustomDrawerHeader({Key? key}) : super(key: key);

  @override
  State<CustomDrawerHeader> createState() => _CustomDrawerHeaderState();
}

class _CustomDrawerHeaderState extends State<CustomDrawerHeader> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: usersCollection.doc(currentUser.uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text('Loading...'));
              }

              final userProfile =
                  UserProfile.fromDocumentSnapshot(snapshot.data!);

              return UserAccountsDrawerHeader(
                currentAccountPicture: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: userProfile.profileImageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: userProfile.profileImageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )
                        : Image.asset(
                            'Assets/profile.png', // Replace with the path to your placeholder image asset
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                decoration: const BoxDecoration(
                  color: Colors.red, // Replace with the desired color
                ),
                accountName: Text(userProfile.name ?? 'John Doe'),
                accountEmail: Text(
                  currentUser.email![0].toUpperCase() +
                      currentUser.email!.substring(1),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.app_registration),
            title: const Text('Donor Registration'),
            onTap: () {
              Get.to(const DonorRegisterFormScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_add_rounded),
            title: const Text('Find Donor'),
            onTap: () {
              Get.to(const FindDonorPage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.bloodtype),
            title: const Text('Blood Request'),
            onTap: () {
              Get.to(const BloodRequestForm());
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Get.to(ProfileScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
