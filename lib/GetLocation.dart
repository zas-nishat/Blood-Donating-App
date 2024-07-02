// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
//
// class Getlocation extends StatefulWidget {
//   const Getlocation({super.key});
//
//   @override
//   State<Getlocation> createState() => _GetlocationState();
// }
//
// class _GetlocationState extends State<Getlocation> {
//
//   String locationMessage = "Current Location";
//
//   Future<Position> _getLocation () async{
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if(!serviceEnabled) {
//       return Future.error("Location Service are disabled");
//     }
//     LocationPermission permission = await Geolocator.checkPermission();
//     if(permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if(permission == LocationPermission.denied) {
//         return Future.error("Location Denied");
//       }
//     }
//     if(permission == LocationPermission.deniedForever) {
//       return Future.error("Location Permission denied. we can not request");
//     }
//     return await Geolocator.getCurrentPosition();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(locationMessage),
//           ElevatedButton(
//               onPressed: (){
//                 _getLocation();
//               },
//               child: Text("Get User Location")),
//         ],
//       ),
//     );
//   }
// }
