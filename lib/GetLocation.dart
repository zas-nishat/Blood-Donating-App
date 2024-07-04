import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class GetLocation extends StatefulWidget {
  const GetLocation({super.key});

  @override
  State<GetLocation> createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  String locationMessage = "Current Location";
  String lat = "";
  String long = "";
  TextEditingController locationController = TextEditingController();

  Future<Position> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location Services are disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location Permission Denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location Permission Denied Forever. We cannot request permissions.");
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getLatLngFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        double latitude = locations[0].latitude;
        double longitude = locations[0].longitude;
        setState(() {
          lat = "$latitude";
          long = "$longitude";
          locationMessage = 'Lat: $lat, Long: $long';
        });
        print('Latitude: $latitude, Longitude: $longitude');
      } else {
        setState(() {
          locationMessage = 'No locations found for this address.';
        });
      }
    } catch (e) {
      setState(() {
        locationMessage = 'Error: $e';
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Location'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Text(locationMessage)),
          ElevatedButton(
            onPressed: () async {
              try {
                Position position = await _getLocation();
                setState(() {
                  lat = "${position.latitude}";
                  long = "${position.longitude}";
                  locationMessage = 'Lat: $lat, Long: $long';
                });
              } catch (e) {
                setState(() {
                  locationMessage = 'Error: $e';
                });
                print('Error: $e');
              }
            },
            child: const Text("Get User Location"),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: locationController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Location Name',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _getLatLngFromAddress(locationController.text);
            },
            child: const Text("Get LatLng from Address"),
          ),
        ],
      ),
    );
  }
}
