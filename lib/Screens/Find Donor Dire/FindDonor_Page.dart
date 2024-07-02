import 'package:avatar_glow/avatar_glow.dart';
import 'package:blood_donating/Function/AppBar.dart';
import 'package:blood_donating/Function/MakeCall.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FindDonorPage extends StatefulWidget {
  const FindDonorPage({super.key});

  @override
  _FindDonorPageState createState() => _FindDonorPageState();
}

class _FindDonorPageState extends State<FindDonorPage> {
  String? _selectedBloodGroup;
  String _location = '';
  late Future<List<Map<String, dynamic>>> _futureDonors;

  @override
  void initState() {
    super.initState();
    _futureDonors = getFindDonorData();
  }

  Future<List<Map<String, dynamic>>> getFindDonorData() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('donors').get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  void _filterDonors() {
    setState(() {
      _futureDonors = getFindDonorData().then((donors) {
        return donors.where((donor) {
          final matchesBloodGroup = _selectedBloodGroup == null || donor['bloodGroup'] == _selectedBloodGroup;
          final matchesLocation = _location.isEmpty || (donor['location'] as String?)!.toLowerCase().contains(_location.toLowerCase()) ?? false;
          return matchesBloodGroup && matchesLocation;
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarFunction(title: "Find Donor"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Location',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _location = value;
                      });
                      _filterDonors();
                    },
                  ),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedBloodGroup,
                    hint: const Text("Blood Group"),
                    items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                        .map((bloodGroup) => DropdownMenuItem(
                      value: bloodGroup,
                      child: Text(bloodGroup),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBloodGroup = value;
                      });
                      _filterDonors();
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _futureDonors,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No donors found.'));
                } else {
                  final donors = snapshot.data!;
                  return ListView.builder(
                    itemCount: donors.length,
                    itemBuilder: (context, index) {
                      final donor = donors[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(donor['name'],style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),),
                          subtitle: Text('${donor['location']}',style: TextStyle(
                            fontSize: 18,
                          ),),
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Text('${donor['bloodGroup']}',style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),),
                          ),
                          trailing: AvatarGlow(
                            glowCount: 1,
                            glowRadiusFactor: 0.3,
                            glowColor: Colors.black, // Color of the glow effect
                            duration: const Duration(seconds: 2), // Duration of the glow effect
                            startDelay: const Duration(milliseconds: 100),
                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.white,
                              child: IconButton(
                                onPressed: () {
                                  makePhoneCall(donor['contact']);
                                },
                                icon: const Icon(Icons.call, size: 15),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}



