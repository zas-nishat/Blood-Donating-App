import 'dart:convert';
import 'package:http/http.dart' as  http;

Future<List<BloodDonorModel>> getFindDonorData() async {
  final response = await http.get(
      Uri.parse("https://mocki.io/v1/ea7066c2-1d68-4c70-bb4f-1c8993459dcd"));
  var data = jsonDecode(response.body.toString());
  if (response.statusCode == 200) {
    List<BloodDonorModel> requests = [];
    for (var item in data) {
      requests.add(BloodDonorModel.fromJson(item));
    }
    return requests;
  } else {
    throw Exception('Failed to load events');
  }
}




class BloodDonorModel {
  String? username;
  String? bloodGroup;
  String? contactNumber;
  String? address;

  BloodDonorModel(
      {this.username, this.bloodGroup, this.contactNumber, this.address});

  BloodDonorModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    bloodGroup = json['blood_group'];
    contactNumber = json['contact_number'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['blood_group'] = this.bloodGroup;
    data['contact_number'] = this.contactNumber;
    data['address'] = this.address;
    return data;
  }
}