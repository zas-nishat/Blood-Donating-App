import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../Function/AppBar.dart';
import 'BloodDonation_ConfirmationPage.dart';

class AllBloodRequestScreen extends StatefulWidget {
  const AllBloodRequestScreen({super.key});

  @override
  State<AllBloodRequestScreen> createState() => _AllBloodRequestScreenState();
}

class _AllBloodRequestScreenState extends State<AllBloodRequestScreen> {
  String? _selectedBloodGroup;
  String _searchLocation = '';
  final CollectionReference _bloodRequestsCollection = FirebaseFirestore.instance.collection('blood_requests');

  Stream<QuerySnapshot> _getFilteredRequests() {
    Query query = _bloodRequestsCollection;

    if (_selectedBloodGroup != null) {
      query = query.where('bloodGroup', isEqualTo: _selectedBloodGroup);
    }

    return query.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarFunction(title: "Blood Request"),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {
                setState(() {
                  _searchLocation = value.trim().toLowerCase();
                });
              },
              decoration: InputDecoration(
                labelText: 'Search by Location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.red),
                  onPressed: () {
                    setState(() {}); // Refresh the StreamBuilder
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Blood Group Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    "Blood Group",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                DropdownButton<String>(
                  value: _selectedBloodGroup,
                  hint: const Text('Select here'),
                  items: <String>['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedBloodGroup = newValue;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getFilteredRequests(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'No Blood Request',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<DocumentSnapshot> documents = snapshot.data!.docs;

                  // Apply local filtering based on the search location
                  if (_searchLocation.isNotEmpty) {
                    documents = documents.where((document) {
                      final data = document.data() as Map<String, dynamic>;
                      final location = data['location'] as String?;
                      return location != null && location.toLowerCase().contains(_searchLocation);
                    }).toList();
                  }

                  if (documents.isEmpty) {
                    return Center(
                      child: Text(
                        'No Blood Request',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = documents[index];
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                      Timestamp createdTime = data['createdTime'] ?? Timestamp.now();
                      DateTime createdDateTime = createdTime.toDate();
                      String timeAgo = timeago.format(createdDateTime);

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Blood Group: ${data['bloodGroup'] ?? 'Unknown'}', style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold
                                  ),),
                                  Text('$timeAgo', style: const TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic
                                  ),),
                                ],
                              ),
                              Text('Number of Bags: ${data['numberOfBloodBags'] ?? 'Unknown'}', style: const TextStyle(
                                  fontSize: 18
                              ),),
                              Text('Hospital Name: ${data['hospitalName'] ?? 'Unknown'}', style: const TextStyle(
                                  fontSize: 18
                              ),),
                              Text('Location: ${data['location'] ?? 'Unknown'}', style: const TextStyle(
                                  fontSize: 18
                              ),),
                              Text('Phone Number: ${data['phoneNumber'] ?? 'Unknown'}', style: const TextStyle(
                                  fontSize: 18
                              ),),
                              Text('Date: ${DateFormat.yMMMMd().format((data['date'] as Timestamp).toDate())}', style: const TextStyle(
                                  fontSize: 18
                              ),),

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
            ),
          ],
        ),
      ),
    );
  }
}
