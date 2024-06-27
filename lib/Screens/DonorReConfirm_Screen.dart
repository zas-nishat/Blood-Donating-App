import 'dart:io';

import 'package:flutter/material.dart';

class ConfirmationPage extends StatelessWidget {
  final File image;
  final String name;
  final String contact;
  final String location;
  final String bloodGroup;

  const ConfirmationPage({
    Key? key,
    required this.image,
    required this.name,
    required this.contact,
    required this.location,
    required this.bloodGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: FileImage(image),
            ),
            SizedBox(height: 20),
            Text(
              'Name: $name',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Contact: $contact',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Location: $location',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Blood Group: $bloodGroup',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}