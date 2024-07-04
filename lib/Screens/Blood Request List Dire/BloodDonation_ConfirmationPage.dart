import 'package:avatar_glow/avatar_glow.dart';
import 'package:blood_donating/Function/MakeCall.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class ConfirmationPage extends StatefulWidget {
  final Map<String, dynamic> requestData;
  final DocumentReference requestRef;

  const ConfirmationPage({
    Key? key,
    required this.requestData,
    required this.requestRef,
  }) : super(key: key);

  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  bool _isChecked = false;
  bool _canDonate = true;
  bool _hasDonated = false;  // New variable to track if the user has already donated
  Timer? _timer;
  Duration _timeLeft = Duration.zero;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Initialize Firebase Auth

  @override
  void initState() {
    super.initState();
    _checkDonationStatus();
    _checkIfDonated();  // Check if the user has already donated
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _checkDonationStatus() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      return;
    }

    final userDoc = FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
    final userSnapshot = await userDoc.get();

    if (userSnapshot.exists) {
      final lastDonation = userSnapshot['lastDonation']?.toDate();
      if (lastDonation != null) {
        final nextDonationDate = lastDonation.add(const Duration(days: 90));
        final now = DateTime.now();

        if (now.isBefore(nextDonationDate)) {
          setState(() {
            _canDonate = false;
            _timeLeft = nextDonationDate.difference(now);
          });
          _startTimer();
        }
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft -= const Duration(seconds: 1);
        if (_timeLeft.isNegative) {
          _canDonate = true;
          timer.cancel();
        }
      });
    });
  }

  void _toggleCheckbox(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
  }

  void _confirmDonation() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      // Handle the case where the user is not logged in
      return;
    }

    if (_isChecked) {
      await widget.requestRef.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.teal,
          content: Text('Thank you for your donation!'),
          duration: Duration(seconds: 2),
        ),
      );

      // Save the donation date
      final userDoc = FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
      await userDoc.set({
        'lastDonation': DateTime.now(),
      }, SetOptions(merge: true));

      setState(() {
        _hasDonated = true;  // Update the state to indicate the user has donated
      });

      await Future.delayed(const Duration(seconds: 2));
      Navigator.pop(context);
    }
  }

  void _checkIfDonated() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      return;
    }

    final userDoc = FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
    final userSnapshot = await userDoc.get();

    if (userSnapshot.exists) {
      final lastDonation = userSnapshot['lastDonation']?.toDate();
      if (lastDonation != null) {
        final now = DateTime.now();
        final nextDonationDate = lastDonation.add(const Duration(days: 90));
        if (now.isBefore(nextDonationDate)) {
          setState(() {
            _hasDonated = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AvatarGlow(
              glowColor: Colors.white, // Color of the glow effect
              duration: const Duration(seconds: 2), // Duration of the glow effect
              startDelay: const Duration(milliseconds: 100),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: IconButton(
                  onPressed: () {
                    makePhoneCall(widget.requestData['phoneNumber']);
                  },
                  icon: const Icon(Icons.call, size: 15),
                ),
              ),
            ),
          ),
        ],
        title: const Text(
          "Confirm Donation",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Details Section
            buildDetailRow('Blood Group', widget.requestData['bloodGroup'] ?? 'Unknown', Colors.red),
            buildDetailRow('Patient Name', widget.requestData['patientName'] ?? 'Unknown', Colors.black87),
            buildDetailRow('Phone Number', widget.requestData['phoneNumber'] ?? 'Unknown', Colors.black87),
            buildDetailRow('Emergency Number', widget.requestData['emergencyNumber'] ?? 'Unknown', Colors.black87),
            buildDetailRow('Number of Blood Bags', widget.requestData['numberOfBloodBags'] ?? 'Unknown', Colors.black87),
            buildDetailRow('Hospital Name', widget.requestData['hospitalName'] ?? 'Unknown', Colors.black87),
            buildDetailRow('Age', widget.requestData['age'] ?? 'Unknown', Colors.black87),
            buildDetailRow('Gender', widget.requestData['gender'] ?? 'Unknown', Colors.black87),
            buildDetailRow('Location', widget.requestData['location'] ?? 'Unknown', Colors.black87),
            buildDetailRow('Date', DateFormat.yMMMMd().format((widget.requestData['date'] as Timestamp).toDate()), Colors.black87),
            buildDetailRow('Time', widget.requestData['time'] ?? 'Unknown', Colors.black87),
            buildDetailRow('Reason', widget.requestData['reason'] ?? 'Unknown', Colors.black87),

            const SizedBox(height: 30),

            // Checkbox
            if (!_hasDonated) ...[  // Show the checkbox and donation button only if the user has not donated
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: _canDonate ? _toggleCheckbox : null,
                  ),
                  const Expanded(
                    child: Text(
                      'Yes, I want to donate my blood and I accept the terms and conditions',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              if (!_canDonate) ...[
                const Text(
                  'You can donate again in:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_timeLeft.inDays} days ${_timeLeft.inHours % 24} hours ${_timeLeft.inMinutes % 60} minutes ${_timeLeft.inSeconds % 60} seconds',
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
                const SizedBox(height: 20),
              ],

              // Confirm Donation Button
              GestureDetector(
                onTap: _isChecked && _canDonate ? _confirmDonation : null,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: _isChecked && _canDonate ? Colors.red : Colors.grey,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Center(
                      child: Text(
                        "Confirm Donation",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ] else ...[
              Center(
                child: Text(
                  'You have already donated.',
                  style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
