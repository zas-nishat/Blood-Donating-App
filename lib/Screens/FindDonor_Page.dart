import 'package:blood_donating/API/BloodDonorModel.dart';
import 'package:blood_donating/Function/AppBar.dart';
import 'package:blood_donating/Function/MakeCall.dart';
import 'package:flutter/material.dart';

class FindDonorPage extends StatefulWidget {
  const FindDonorPage({super.key});

  @override
  _FindDonorPageState createState() => _FindDonorPageState();
}

class _FindDonorPageState extends State<FindDonorPage> {
  String? _selectedBloodGroup;
  String _location = '';
  Future<List<BloodDonorModel>>? _futureDonors;

  @override
  void initState() {
    super.initState();
    _futureDonors = getFindDonorData();
  }

  void _filterDonors() {
    setState(() {
      _futureDonors = getFindDonorData().then((donors) {
        return donors.where((donor) {
          final matchesBloodGroup = _selectedBloodGroup == null || donor.bloodGroup == _selectedBloodGroup;
          final matchesLocation = _location.isEmpty || donor.address!.toLowerCase().contains(_location.toLowerCase());
          return matchesBloodGroup && matchesLocation;
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarFunction(title: "Find Donor"),
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
                SizedBox(width: 10,),
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
          SizedBox(height: 20,),
          Expanded(
            child: FutureBuilder<List<BloodDonorModel>>(
              future: _futureDonors,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  if (data.isEmpty) {
                    return const Center(child: Text('No donors found'));
                  }
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final request = data[index];
                      return Card(

                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Blood Group: ${request.bloodGroup}",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        makePhoneCall(request.contactNumber.toString());
                                      },
                                      child: CircleAvatar(
                                        child: Icon(Icons.call,size: 20,),
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  "${request.username}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${request.contactNumber}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  "${request.address}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
