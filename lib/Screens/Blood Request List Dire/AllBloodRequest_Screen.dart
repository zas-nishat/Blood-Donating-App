import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../Function/AppBar.dart';
import 'BloodDonation_ConfirmationPage.dart';
import 'dart:async';

class AllBloodRequestScreen extends StatefulWidget {
  const AllBloodRequestScreen({super.key});

  @override
  State<AllBloodRequestScreen> createState() => _AllBloodRequestScreenState();
}

class _AllBloodRequestScreenState extends State<AllBloodRequestScreen> {
  String? _selectedBloodGroup;
  String _searchLocation = '';
  final CollectionReference _bloodRequestsCollection = FirebaseFirestore.instance.collection('blood_requests');
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _scheduleDailyDeletion();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _scheduleDailyDeletion() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final durationUntilTomorrow = tomorrow.difference(now);

    // Schedule the initial run for tomorrow at midnight
    Future.delayed(durationUntilTomorrow, _startPeriodicDeletion);
  }

  void _startPeriodicDeletion() {
    _timer?.cancel(); // Cancel any existing timer
    _deleteOldRequests(); // Run immediately on first start

    // Schedule the periodic task to run daily
    _timer = Timer.periodic(Duration(days: 1), (timer) {
      _deleteOldRequests();
    });
  }

  Future<void> _deleteOldRequests() async {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(Duration(days: 7));

    QuerySnapshot snapshot = await _bloodRequestsCollection
        .where('date', isLessThan: Timestamp.fromDate(sevenDaysAgo))
        .get();

    WriteBatch batch = FirebaseFirestore.instance.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
    print('Deleted old blood requests');
  }

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
                                  Expanded(
                                    child: Text('Blood Group: ${data['bloodGroup'] ?? 'Unknown'}', style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold
                                    ),),
                                  ),
                                  SizedBox(width: 5,),
                                  Text('$timeAgo', style: const TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic
                                  ),),
                                ],
                              ),
                              Text('Number of Bags: ${data['numberOfBloodBags'] ?? 'Unknown'}', style: const TextStyle(
                                  fontSize: 18
                              ),),
                              Text('Patient Name: ${data['patientName'] ?? 'Unknown'}', style: const TextStyle(
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
            ),
          ],
        ),
      ),
    );
  }
}
