import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for data
            return const Center(child: CircularProgressIndicator());
          }

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

              Timestamp createdTime = document['createdTime'] ?? Timestamp.now();
              DateTime createdDateTime = createdTime.toDate();
              String timeAgo = timeago.format(createdDateTime);

              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Blood Group: ${data['bloodGroup'] ?? 'Unknown'}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('$timeAgo', style: const TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic
                          ),),
                        ],
                      ),
                      Text(
                        'Number of Blood Bags: ${data['numberOfBloodBags'] ?? 'Unknown'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Patient Name: ${data['patientName'] ?? 'Unknown'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Hospital Name: ${data['hospitalName'] ?? 'Unknown'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Location: ${data['location'] ?? 'Unknown'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Phone Number: ${data['phoneNumber'] ?? 'Unknown'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Date: ${DateFormat.yMMMMd().format((data['date'] as Timestamp).toDate())}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BloodDonationConfirmationPage(
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
                                    "Blood Need",
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
