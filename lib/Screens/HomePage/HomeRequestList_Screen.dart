import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Blood Request List Dire/BloodDonation_ConfirmationPage.dart';

class HomeRequestListScreen extends StatelessWidget {
  HomeRequestListScreen({super.key});

  final CollectionReference _bloodRequestsCollection = FirebaseFirestore.instance.collection('blood_requests');

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: _bloodRequestsCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error: Something went wrong'));
          }

          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return Center(
              child: Text(
                '(⊙ _ ⊙)..No Blood Request',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            );
          }

          List<DocumentSnapshot> documents = snapshot.data!.docs;
          List<DocumentSnapshot> limitedDocuments = documents.take(10).toList();

          return ListView.builder(
            itemCount: limitedDocuments.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = limitedDocuments[index];
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Blood Group: ${data['bloodGroup'] ?? 'Unknown'}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Patient Name: ${data['patientName'] ?? 'Unknown'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Phone Number: ${data['phoneNumber'] ?? 'Unknown'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Emergency Number: ${data['emergencyNumber'] ?? 'Unknown'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Number of Blood Bags: ${data['numberOfBloodBags'] ?? 'Unknown'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Hospital Name: ${data['hospitalName'] ?? 'Unknown'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Age: ${data['age'] ?? 'Unknown'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Gender: ${data['gender'] ?? 'Unknown'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Location: ${data['location'] ?? 'Unknown'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Date: ${DateFormat.yMMMMd().format((data['date'] as Timestamp).toDate())}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Time: ${data['time']}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Reason: ${data['reason'] ?? 'Unknown'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConfirmationPage(
                                  requestData: data,
                                  requestRef: document.reference,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.red,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Center(
                                  child: Text(
                                    "I want to donate",
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
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
