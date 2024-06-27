import 'package:blood_donating/Function/AppBar.dart';
import 'package:flutter/material.dart';

class BloodDetails extends StatelessWidget {
  const BloodDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarFunction(title: "Contact"),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text("Blood Group",style: TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.bold
            ),),
            const Text("O+",style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black
            ),),
            const SizedBox(height: 20,),
            Text("Number of bags",style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.7)

            ),),
            const Text("2",style: TextStyle(
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
