import 'package:avatar_glow/avatar_glow.dart';
import 'package:blood_donating/Function/AppBar.dart';
import 'package:blood_donating/Function/MakeCall.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class FindDonorPage extends StatefulWidget {
  const FindDonorPage({super.key});

  @override
 _FindDonorPageState createState() => _FindDonorPageState();
}

class _FindDonorPageState extends State<FindDonorPage> {
  String? _selectedBloodGroup;
  String _location = '';
  bool _showNearbyDonors = false;
  late Future<List<Map<String, dynamic>>> _futureDonors;
  late Position _currentPosition;
  bool _locationInitialized = false;
  @override
  void initState() {
    super.initState();
    _futureDonors = Future.value([]);
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
        _locationInitialized = true;
        _futureDonors = getFindDonorData();
      });
    } catch (e) {
      print('Error getting current location: $e');
      setState(() {
        _locationInitialized = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> getFindDonorData() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('donors').get();
    List<Map<String, dynamic>> donors = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    if (!_showNearbyDonors) {
      donors.shuffle();
    } else {
      donors.sort((a, b) {
        final double lat1 = a['latitude']?.toDouble() ?? 0.0;
        final double lon1 = a['longitude']?.toDouble() ?? 0.0;
        final double lat2 = b['latitude']?.toDouble() ?? 0.0;
        final double lon2 = b['longitude']?.toDouble() ?? 0.0;

        final distance1 = Geolocator.distanceBetween(
          _currentPosition.latitude,
          _currentPosition.longitude,
          lat1,
          lon1,
        );
        final distance2 = Geolocator.distanceBetween(
          _currentPosition.latitude,
          _currentPosition.longitude,
          lat2,
          lon2,
        );
        return distance1.compareTo(distance2);  // Sort by distance
      });
    }

    // Filter by blood group and location
    donors = donors.where((donor) {
      final matchesBloodGroup = _selectedBloodGroup == null || donor['bloodGroup'] == _selectedBloodGroup;
      final matchesLocation = _location.isEmpty || (donor['location'] as String?)!.toLowerCase().contains(_location.toLowerCase()) ?? false;
      return matchesBloodGroup && matchesLocation;
    }).toList();


    if (_showNearbyDonors) {
      donors.sort((a, b) {
        final double lat1 = a['latitude']?.toDouble() ?? 0.0;
        final double lon1 = a['longitude']?.toDouble() ?? 0.0;
        final double lat2 = b['latitude']?.toDouble() ?? 0.0;
        final double lon2 = b['longitude']?.toDouble() ?? 0.0;

        final distance1 = Geolocator.distanceBetween(
          _currentPosition.latitude,
          _currentPosition.longitude,
          lat1,
          lon1,
        );
        final distance2 = Geolocator.distanceBetween(
          _currentPosition.latitude,
          _currentPosition.longitude,
          lat2,
          lon2,
        );
        return distance1.compareTo(distance2);  // Sort by distance
      });
    }

    return donors;
  }

  void _filterDonors() {
    setState(() {
      _futureDonors = getFindDonorData();
    });
  }

  String _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    final double distanceInMeters = Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
    final double distanceInKm = distanceInMeters / 1000;
    return distanceInKm.toStringAsFixed(2); // returns distance in kilometers with 2 decimal places
  }

  void _onFilterSelection(String value) {
    setState(() {
      if (value == 'All Donors') {
        _showNearbyDonors = false;
      } else if (value == 'Nearby Donors') {
        _showNearbyDonors = true;
      }
      _filterDonors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Donor"),
        actions: [
          PopupMenuButton<String>(
            onSelected: _onFilterSelection,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(value: 'All Donors', child: Text('All Donors')),
                PopupMenuItem(value: 'Nearby Donors', child: Text('Nearby Donors')),
              ];
            },
          ),
        ],
      ),
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
                const SizedBox(width: 10),
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
                if (!_locationInitialized) {
                  return const Center(child: CircularProgressIndicator()); // Show loading spinner if location is not initialized
                } else if (snapshot.connectionState == ConnectionState.waiting) {
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
                      final double donorLat = donor['latitude']?.toDouble() ?? 0.0;
                      final double donorLon = donor['longitude']?.toDouble() ?? 0.0;

                      // Ensure that the donor has valid latitude and longitude
                      if (donorLat == 0.0 || donorLon == 0.0) {
                        return SizedBox.shrink(); // Skip invalid data
                      }

                      final String distance = _calculateDistance(
                        _currentPosition.latitude,
                        _currentPosition.longitude,
                        donorLat,
                        donorLon,
                      );

                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                            donor['name'] ?? 'No Name',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${donor['location']}',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Text(
                              '${donor['bloodGroup']}',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          trailing: AvatarGlow(
                            glowCount: 1,
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