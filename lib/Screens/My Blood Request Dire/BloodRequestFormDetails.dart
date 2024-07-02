import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../Function/AppBar.dart';

class RequestRequestFormDetails extends StatelessWidget {
  final String phoneNumber;
  final String emergencyNumber;
  final String patientName;
  final String numberOfBloodBags;
  final String hospitalName;
  final String age;
  final String bloodGroup;
  final String gender;
  final String location;
  final DateTime date;
  final TimeOfDay time;
  final String reason;

  const RequestRequestFormDetails({
    Key? key,
    required this.phoneNumber,
    required this.emergencyNumber,
    required this.patientName,
    required this.numberOfBloodBags,
    required this.hospitalName,
    required this.age,
    required this.bloodGroup,
    required this.gender,
    required this.location,
    required this.date,
    required this.time,
    required this.reason,
  }) : super(key: key);

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.red, size: 30),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitRequestForm(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('blood_requests').add({
        'phoneNumber': phoneNumber,
        'emergencyNumber': emergencyNumber,
        'patientName': patientName,
        'numberOfBloodBags': numberOfBloodBags,
        'hospitalName': hospitalName,
        'age': age,
        'bloodGroup': bloodGroup,
        'gender': gender,
        'location': location,
        'date': date,
        'time': time.format(context),
        'reason': reason,
        'createdTime': FieldValue.serverTimestamp(),
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request form submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back or to a different page
      Navigator.of(context).pop();
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit form: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Submission'),
          content: const Text('Are you sure you want to submit this request?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                _submitRequestForm(context);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarFunction(title: "Confirm Blood Request"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(
                  icon: Icons.person, label: "Patient Name", value: patientName),
              const Divider(),
              _buildDetailRow(
                  icon: Icons.phone, label: "Phone Number", value: phoneNumber),
              const Divider(),
              _buildDetailRow(
                  icon: Icons.phone_android,
                  label: "Emergency Number",
                  value: emergencyNumber),
              const Divider(),
              _buildDetailRow(
                  icon: Icons.water_drop_outlined,
                  label: "Number of Blood Bags",
                  value: numberOfBloodBags),
              const Divider(),
              _buildDetailRow(
                  icon: Icons.local_hospital,
                  label: "Hospital Name",
                  value: hospitalName),
              const Divider(),
              _buildDetailRow(icon: Icons.cake, label: "Age", value: age),
              const Divider(),
              _buildDetailRow(
                  icon: Icons.bloodtype, label: "Blood Group", value: bloodGroup),
              const Divider(),
              _buildDetailRow(
                  icon: Icons.person_outline, label: "Gender", value: gender),
              const Divider(),
              _buildDetailRow(icon: Icons.note_outlined, label: "Problem", value: reason),
              const Divider(),
              _buildDetailRow(
                  icon: Icons.date_range,
                  label: "Date",
                  value: DateFormat.yMd().format(date)),
              const Divider(),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _showConfirmationDialog(context),
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
                          "Submit Request Form",
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
    );
  }
}
