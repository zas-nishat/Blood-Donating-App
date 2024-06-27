import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '';
import '../Function/AppBar.dart';
import 'BloodRequestFormDetails.dart';

class BloodRequestForm extends StatefulWidget {
  const BloodRequestForm({super.key});

  @override
  State<BloodRequestForm> createState() => _BloodRequestFormState();
}

class _BloodRequestFormState extends State<BloodRequestForm> {
  String? _selectedBloodGroup;
  String? _selectedGender;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emergencyPhoneController =
      TextEditingController();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _bloodBagsController = TextEditingController();
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _problemPhoneController = TextEditingController();

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }


  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedTime != null &&
        _selectedBloodGroup != null &&
        _selectedGender != null) {
      Get.to(() => RequestDetailsPage(
        phoneNumber: _phoneController.text,
        emergencyNumber: _emergencyPhoneController.text,
        patientName: _patientNameController.text,
        numberOfBloodBags: _bloodBagsController.text,
        hospitalName: _hospitalNameController.text,
        age: _ageController.text,
        bloodGroup: _selectedBloodGroup!,
        gender: _selectedGender!,
        location: _locationController.text,
        date: _selectedDate!,
        time: _selectedTime!,
        reason: _problemPhoneController.text,
      ));
    } else {
      // Show a dialog or snackbar prompting the user to select date and time
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Incomplete Form'),
            content: Text('Please fill all the info'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarFunction(title: "Request for Blood Donor"),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                const Center(
                  child: Text(
                    "Patient Details",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Choose Blood Group: ",
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
                  "Patient Name",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text,
                  controller: _patientNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.1),
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.person),
                    labelText: 'Patient Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the patient name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  "Phone Number",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _phoneController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.1),
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.phone),
                    labelText: 'Phone Number',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  "Emergency Phone Number",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _emergencyPhoneController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.1),
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.phone),
                    labelText: 'Emergency Phone Number',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an emergency phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  "Number of Bag",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _bloodBagsController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.water_drop_outlined),
                    labelText: 'Number of Blood Bags',
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.1),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of blood bags';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  "Hospital Name",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text,
                  controller: _hospitalNameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.local_hospital),
                    labelText: 'Hospital Name',
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.1),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the hospital name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  "Location",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text,
                  controller: _locationController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.1),
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.location_on),
                    labelText: 'Location',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  "Patient Age",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _ageController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.timelapse_rounded),
                    labelText: 'Age',
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.1),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  "Patient Problem",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _problemPhoneController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.1),
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.note_outlined),
                    labelText: 'Cause of blood ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the problem';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: (){
                    _selectDate(context);
                  },
                  child: Container(
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.1),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: const Icon(Icons.date_range),
                        ),
                        Text(
                          _selectedDate == null
                              ? 'No date selected'
                              : 'Date: ${DateFormat.yMd().format(_selectedDate!)}',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: (){
                    _selectTime(context);
                  },
                  child: Container(
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.1),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: const Icon(Icons.av_timer_sharp),
                        ),
                        Text(
                          _selectedTime == null
                              ? 'No time selected'
                              : 'Time: ${_selectedTime!.format(context)}',
                        ),

                      ],
                    ),
                  ),
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
                            "Submit",
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
