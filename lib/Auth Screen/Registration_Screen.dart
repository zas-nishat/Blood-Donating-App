import 'package:blood_donating/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import '../controller/auth_controller.dart';

class RegistrationScreen extends StatefulWidget {
  final Function()? onTap;
  const RegistrationScreen({Key? key, this.onTap}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool showProgessBar = false;
  final AuthController _authController = AuthController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  String? _selectedGender;
  String? _selectedBloodGroup;
  bool _obscureText = true;

  Uint8List? _image;

  Future<void> galleryImage() async {
    Uint8List? im = await _authController.pickProfileImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  Future<void> captureImage() async {
    Uint8List? im = await _authController.pickProfileImage(ImageSource.camera);
    setState(() {
      _image = im;
    });
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
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        leading: IconButton(
          onPressed: widget.onTap,
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
        ),
        title: const Text(
          "Sign Up",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _globalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Center(
                  child: GestureDetector(
                    onTap: galleryImage,
                    child: _image == null
                        ? const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.black,
                      backgroundImage: AssetImage("Assets/profile.png"),
                    )
                        : CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.black,
                      backgroundImage: MemoryImage(_image!),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Name TextFormField
                const Text(
                  "Name",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 3),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: _nameController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Enter your name";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Enter your name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Email TextFormField
                const Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 3),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.sentences,
                  controller: _emailController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Enter your Email";
                    }else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Phone Number TextFormField
                const Text(
                  "Phone Number",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 3),
                TextFormField(
                  controller: _phoneNumberController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Enter your phone number";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    hintText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),

                // Location TextFormField
                const Text(
                  "Location",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 3),
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: _locationController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Enter your Location";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.location_on_outlined),
                    hintText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Password TextFormField
                const Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 3),
                TextFormField(
                  controller: _passwordController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Enter your password";
                    } else {
                      return null;
                    }
                  },
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    prefixIcon: const Icon(Icons.lock),
                    hintText: 'Password',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Gender Selection
                const Text(
                  "Gender",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 20),
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

                // Blood Group Selection
                const Text(
                  "Blood Group",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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

                // Sign Up Button with Progress Indicator
                Center(
                  child: showProgessBar
                      ? CircularProgressIndicator()
                      : InkWell(
                        onTap: () async {
                          if (_globalKey.currentState!.validate()) {
                            if (_selectedGender == null || _selectedBloodGroup == null || _image == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please select gender, blood group and image also'),
                                ),
                              );
                              return;
                            }
                            setState(() {
                              showProgessBar = true;
                            });
                            String res = await _authController.createNewUser(
                              _emailController.text,
                              _passwordController.text,
                              _nameController.text,
                              _phoneNumberController.text,
                              _locationController.text,
                              _selectedGender!,
                              _selectedBloodGroup!,
                              _image,
                            );
                            setState(() {
                              showProgessBar = false;
                            });

                            if (res == 'success') {
                              Get.to(() => HomePage());
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(res)),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please fill all the information of the form')),
                            );
                          }
                        },

                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: const Center(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
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
