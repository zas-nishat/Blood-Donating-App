import 'package:flutter/material.dart';
import '../API/BloodRequestModel.dart';
import '../Function/AppBar.dart';
import '../Function/MakeCall.dart';

class AllBloodRequestScreen extends StatefulWidget {
  const AllBloodRequestScreen({super.key});

  @override
  State<AllBloodRequestScreen> createState() => _AllBloodRequestScreenState();
}

class _AllBloodRequestScreenState extends State<AllBloodRequestScreen> {
  String? _selectedBloodGroup;

  Future<List<BloodRequestModel>> _getFilteredRequests() async {
    List<BloodRequestModel> allRequests = await GetBloodData();
    if (_selectedBloodGroup == null) {
      return allRequests;
    } else {
      return allRequests.where((request) => request.bloodGroupNeeded == _selectedBloodGroup).toList();
    }
  }

  Widget _buildSelectableContainer({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.white,
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.red,
          ),
        ),
      ),
    );
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
            const Text("Filter: ",style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSelectableContainer(
                  text: 'A+',
                  isSelected: _selectedBloodGroup == 'A+',
                  onTap: () {
                    setState(() {
                      _selectedBloodGroup = 'A+';
                    });
                  },
                ),
                _buildSelectableContainer(
                  text: 'A-',
                  isSelected: _selectedBloodGroup == 'A-',
                  onTap: () {
                    setState(() {
                      _selectedBloodGroup = 'A-';
                    });
                  },
                ),
                _buildSelectableContainer(
                  text: 'B+',
                  isSelected: _selectedBloodGroup == 'B+',
                  onTap: () {
                    setState(() {
                      _selectedBloodGroup = 'B+';
                    });
                  },
                ),
                _buildSelectableContainer(
                  text: 'B-',
                  isSelected: _selectedBloodGroup == 'B-',
                  onTap: () {
                    setState(() {
                      _selectedBloodGroup = 'B-';
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSelectableContainer(
                  text: 'O+',
                  isSelected: _selectedBloodGroup == 'O+',
                  onTap: () {
                    setState(() {
                      _selectedBloodGroup = 'O+';
                    });
                  },
                ),
                _buildSelectableContainer(
                  text: 'O-',
                  isSelected: _selectedBloodGroup == 'O-',
                  onTap: () {
                    setState(() {
                      _selectedBloodGroup = 'O-';
                    });
                  },
                ),
                _buildSelectableContainer(
                  text: 'AB+',
                  isSelected: _selectedBloodGroup == 'AB+',
                  onTap: () {
                    setState(() {
                      _selectedBloodGroup = 'AB+';
                    });
                  },
                ),
                _buildSelectableContainer(
                  text: 'AB-',
                  isSelected: _selectedBloodGroup == 'AB-',
                  onTap: () {
                    setState(() {
                      _selectedBloodGroup = 'AB-';
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<BloodRequestModel>>(
                future: _getFilteredRequests(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final request = data[index];
                        return Card(
                          margin: EdgeInsets.zero,
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
                                        "Blood Group: ${request.bloodGroupNeeded}",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      ),
                                      Text(
                                        "${request.timeAgo}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade700),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "${request.name}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${request.numberOfBags} Bag${request.numberOfBags! > 1 ? 's' : ''}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    "${request.number}",
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${request.date}",
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          makePhoneCall(request.number.toString());
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.circular(8)),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 9.0, vertical: 5),
                                            child: Text(
                                              "Confirm",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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
      ),
    );
  }
}
