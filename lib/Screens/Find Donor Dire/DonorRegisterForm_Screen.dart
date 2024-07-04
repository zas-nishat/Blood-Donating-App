import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';
import '../../Function/AppBar.dart';
import 'DonorRegistrationConfirm_Screen.dart';

class DonorRegisterFormScreen extends StatefulWidget {
  const DonorRegisterFormScreen({Key? key}) : super(key: key);

  @override
  State<DonorRegisterFormScreen> createState() => _DonorRegisterFormScreenState();
}

class _DonorRegisterFormScreenState extends State<DonorRegisterFormScreen> {
  File? _image;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _ageController = TextEditingController();

  String? _selectedBloodGroup;
  String? _selectedGender;
  double _latitude = 0.0;
  double _longitude = 0.0;

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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedBloodGroup != null && _selectedGender != null) {
        try {
          List<Location> locations = await locationFromAddress(_locationController.text);
          if (locations.isNotEmpty) {
            setState(() {
              _latitude = locations[0].latitude;
              _longitude = locations[0].longitude;
            });

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DonorConfirmationPage(
                  name: _nameController.text,
                  contact: _contactController.text,
                  location: _locationController.text,
                  bloodGroup: _selectedBloodGroup!,
                  latitude: _latitude,
                  longitude: _longitude,
                  age: int.parse(_ageController.text),
                  gender: _selectedGender!,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Location not found. Please enter a valid location.')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Enter yout location correctly')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select blood group and gender.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarFunction(title: "Donor Registration Form"),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Enter your name: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.1),
                    prefixIcon: const Icon(Icons.person),
                    labelText: 'Enter your name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "Enter your number: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _contactController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.1),
                    prefixIcon: const Icon(Icons.phone),
                    labelText: 'Enter your number',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "Enter your location: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _locationController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.1),
                    prefixIcon: const Icon(Icons.location_on),
                    labelText: 'Enter your location',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "Enter your age: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.1),
                    prefixIcon: const Icon(Icons.cake),
                    labelText: 'Enter your age',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "Gender: ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSelectableContainer(
                      text: 'Male',
                      isSelected: _selectedGender == 'Male',
                      onTap: () {
                        setState(() {
                          _selectedGender = 'Male';
                        });
                      },
                    ),
                    _buildSelectableContainer(
                      text: 'Female',
                      isSelected: _selectedGender == 'Female',
                      onTap: () {
                        setState(() {
                          _selectedGender = 'Female';
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Choose Your Blood Group: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
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
                GestureDetector(
                  onTap: _submitForm,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Center(
                          child: Text(
                            "Next",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
