import 'package:flutter/material.dart';

import '../Function/AppBar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarFunction(title: 'Profile'),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           const Center(
             child: CircleAvatar(
               radius: 50,
             ),
           ),
            Text("Name",style: TextStyle(
              fontSize: 16,
              color: Colors.black.withOpacity(0.7)
            ),),
            const Text("Itadori Nishat",style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black
            ),),
            const SizedBox(height: 20,),
            Text("Location",style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.7)
            ),),
            const Text("Feni,Bangladesh",style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black
            ),),
            const SizedBox(height: 20,),
            Text("Gender",style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.7)
            ),),
            const Text("Male",style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black
            ),),
            const SizedBox(height: 20,),
            Text("Blood Group",style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.7)
            ),),
            const Text("O+",style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black
            ),),
            const SizedBox(height: 20,),
            Text("Contact Number",style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.7)
            ),),
            const Text("01811111111",style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black
            ),),
          ],
        ),
      ),
    );
  }
}
