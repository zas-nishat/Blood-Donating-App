import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Function/AppBar.dart';

class RequestDetailsPage extends StatelessWidget {
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


  const RequestDetailsPage({
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
    required this.time
  }) : super(key: key);

  Widget _buildDetailRow({required IconData icon, required String label, required String value}) {
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
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarFunction(title: "Confirm Blood Request"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(icon: Icons.person, label: "Patient Name", value: patientName),
              const Divider(),
              _buildDetailRow(icon: Icons.phone, label: "Phone Number", value: phoneNumber),
              const Divider(),
              _buildDetailRow(icon: Icons.phone_android, label: "Emergency Number", value: emergencyNumber),
              const Divider(),
              _buildDetailRow(icon: Icons.water_drop_outlined, label: "Number of Blood Bags", value: numberOfBloodBags),
              const Divider(),
              _buildDetailRow(icon: Icons.local_hospital, label: "Hospital Name", value: hospitalName),
              const Divider(),
              _buildDetailRow(icon: Icons.cake, label: "Age", value: age),
              const Divider(),
              _buildDetailRow(icon: Icons.bloodtype, label: "Blood Group", value: bloodGroup),
              const Divider(),
              _buildDetailRow(icon: Icons.person_outline, label: "Gender", value: gender),
              const Divider(),
              _buildDetailRow(icon: Icons.date_range, label: "Date", value:  DateFormat.yMd().format(date)),
              const Divider(),
              _buildDetailRow(icon: Icons.av_timer_sharp, label: "Time", value: time.format(context)),
              const Divider(),

              const SizedBox(height: 20),
              GestureDetector(
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
