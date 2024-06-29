import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String blood;
  final String gender;
  final String location;
  final String? profileImageUrl;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.blood,
    required this.gender,
    required this.location,
    this.profileImageUrl,
  });

  // Factory method to create a UserProfile from Firestore document snapshot
  factory UserProfile.fromDocumentSnapshot(DocumentSnapshot doc) {
    return UserProfile(
      uid: doc.id,
      name: doc['name'],
      email: doc['email'],
      phone: doc['number'],
      blood: doc['blood'],
      gender: doc['gender'],
      location: doc['location'],
      profileImageUrl: doc['photoUrl'],
    );
  }
}