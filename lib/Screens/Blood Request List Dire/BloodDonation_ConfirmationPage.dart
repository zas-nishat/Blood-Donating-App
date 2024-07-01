import 'package:avatar_glow/avatar_glow.dart';
import 'package:blood_donating/Function/MakeCall.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  void _toggleCheckbox(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
  }

  void _confirmDonation() async {
    if (_isChecked) {
      await widget.requestRef.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.teal,
          content: Text('Thank you for your donation!'),
          duration: Duration(seconds: 2),
        ),
      );

      await Future.delayed(const Duration(seconds: 2));
      Navigator.pop(context);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: _toggleCheckbox,
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

            // Confirm Donation Button
            GestureDetector(
              onTap: _isChecked ? _confirmDonation : null,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _isChecked ? Colors.red : Colors.grey,
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
