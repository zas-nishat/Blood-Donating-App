import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../Function/UserProfileModel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  String? _downloadURL;
  String _timeLeftText = '';

  @override
  void initState() {
    super.initState();
    fetchLatestImageUrl(); // Fetch the latest image URL when the widget is initialized
    _calculateTimeLeft();
  }

  Future<void> fetchLatestImageUrl() async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref().child('profile');

      final ListResult result = await ref.list();

      final lastImageMetadata = result.items.last;

      _downloadURL = await lastImageMetadata.getDownloadURL();

      // Update the UI
      setState(() {});
    } catch (e) {
      print('Error fetching image URL: $e');
    }
  }

  Future<void> _calculateTimeLeft() async {
    final userDoc = usersCollection.doc(user.uid);
    final userSnapshot = await userDoc.get();
    if (userSnapshot.exists) {
      final lastDonation = userSnapshot['lastDonation']?.toDate();
      if (lastDonation != null) {
        final nextDonationDate = lastDonation.add(const Duration(days: 90));
        final now = DateTime.now();

        if (now.isBefore(nextDonationDate)) {
          final timeLeft = nextDonationDate.difference(now);
          setState(() {
            _timeLeftText = '${timeLeft.inDays} days ${timeLeft.inHours % 24} hours ${timeLeft.inMinutes % 60} minutes';
          });
        } else {
          setState(() {
            _timeLeftText = 'Congrats! You can donate blood now!';
          });
        }
      } else {
        setState(() {
          _timeLeftText = 'You can donate blood now!';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_downloadURL);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder(
        stream: usersCollection.doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text(
                'Loading...',
                style: TextStyle(fontSize: 20),
              ),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: const Text('Loading...'));
          }

          final userProfile = UserProfile.fromDocumentSnapshot(snapshot.data!);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
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
                                placeholder: (context, url) => const CircularProgressIndicator(), // Placeholder widget while loading
                                errorWidget: (context, url, error) => const Icon(Icons.error), // Widget to show in case of error
                              )
                                  : Image.asset(
                                'Assets/profile.png', // Replace with the path to your placeholder image asset
                                fit: BoxFit.cover,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Name",
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${userProfile.name}',
                                    style: const TextStyle(fontSize: 15),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Email",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  user.email.toString(),
                                  style: const TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Phone",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '${userProfile.phone}',
                                  style: const TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Gender: ",
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${userProfile.gender}',
                                    style: const TextStyle(fontSize: 15),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Blood Group:",
                                    style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${userProfile.blood}',
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Location:",
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${userProfile.location}',
                                    style: const TextStyle(fontSize: 15),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Time Until Next Donation:",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    _timeLeftText,
                                    style: const TextStyle(fontSize: 20, color: Colors.red),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
