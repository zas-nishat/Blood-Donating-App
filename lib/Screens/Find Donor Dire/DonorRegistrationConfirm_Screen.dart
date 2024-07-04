import 'package:blood_donating/Function/AppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DonorConfirmationPage extends StatefulWidget {
  final String name;
  final String contact;
  final String location;
  final String bloodGroup;
  final double latitude;
  final double longitude;
  final int age;
  final String gender;

  const DonorConfirmationPage({
    Key? key,
    required this.name,
    required this.contact,
    required this.location,
    required this.bloodGroup,
    required this.latitude,
    required this.longitude,
    required this.age,
    required this.gender,
  }) : super(key: key);

  @override
  _DonorConfirmationPageState createState() => _DonorConfirmationPageState();
}

class _DonorConfirmationPageState extends State<DonorConfirmationPage> {
  bool _isAlreadyDonor = false;

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyDonor();
  }

  Future<void> _checkIfAlreadyDonor() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final String uid = user.uid;
    final CollectionReference donorsCollection = FirebaseFirestore.instance.collection('donors');

    try {
      final QuerySnapshot querySnapshot = await donorsCollection.where('uid', isEqualTo: uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _isAlreadyDonor = true;
        });
      }
    } catch (e) {
      print('Error checking donor status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarFunction(title: "Confirm Registration"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_isAlreadyDonor)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  color: Colors.redAccent,
                  child: const Text(
                    'You are already a donor!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              if (!_isAlreadyDonor) ...[
                // Confirmation Card
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Please Confirm Your Details:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildDetailRow('Name', widget.name),
                        _buildDetailRow('Contact', widget.contact),
                        _buildDetailRow('Location', widget.location),
                        _buildDetailRow('Blood Group', widget.bloodGroup),
                       const SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            _showConfirmationDialog(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.red,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Center(
                                  child: Text(
                                    "Next",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Details'),
          content: const Text('Do you want to proceed with the registration?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addDonorToFirebase(context);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addDonorToFirebase(BuildContext context) async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No user is logged in. Please log in and try again.'),
        ),
      );
      return;
    }

    final String uid = user.uid;
    final CollectionReference donorsCollection = FirebaseFirestore.instance.collection('donors');

    try {
      // Check if the user has already filled the form
      final QuerySnapshot querySnapshot = await donorsCollection.where('uid', isEqualTo: uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        // User has already filled the form
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have already registered as a donor.'),
          ),
        );
        return;
      }

      // Add the donor details to the Firestore collection
      await donorsCollection.add({
        'uid': uid, // Add the UID of the current user
        'name': widget.name,
        'contact': widget.contact,
        'location': widget.location,
        'bloodGroup': widget.bloodGroup,
        'latitude': widget.latitude,
        'longitude': widget.longitude,
        'age': widget.age,
        'gender': widget.gender,
        'timestamp': FieldValue.serverTimestamp(), // Add a timestamp for sorting or querying
      });

      _showSuccessDialog(context);
    } catch (e) {
      print('Error adding donor to Firestore: $e');
      _showErrorDialog(context);
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Thank you for confirming your registration.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Optionally navigate to another screen or perform additional actions here
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('There was an error confirming your registration. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
