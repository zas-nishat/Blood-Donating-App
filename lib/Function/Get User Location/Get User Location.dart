// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:location/location.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
//
//
// Future<LocationData> getUserLocation() async {
//   Location location = Location();
//
//   bool serviceEnabled;
//   PermissionStatus permissionGranted;
//
//   serviceEnabled = await location.serviceEnabled();
//   if (!serviceEnabled) {
//     serviceEnabled = await location.requestService();
//     if (!serviceEnabled) {
//       throw 'Location services are disabled.';
//     }
//   }
//
//   permissionGranted = await location.hasPermission();
//   if (permissionGranted == PermissionStatus.denied) {
//     permissionGranted = await location.requestPermission();
//     if (permissionGranted != PermissionStatus.granted) {
//       throw 'Location permissions are denied';
//     }
//   }
//
//   return await location.getLocation();
// }
//
// Future<LatLng> getCoordinatesFromAddress(String address) async {
//   List<Location> locations = await locationFromAddress(address);
//   return LatLng(locations.first.latitude, locations.first.longitude);
// }
//
// double calculateDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
//   return Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
// }
