import 'dart:convert';
import 'package:http/http.dart' as  http;

Future<List<BloodRequestModel>> GetBloodData() async {
  final response = await http.get(
      Uri.parse("https://mocki.io/v1/116d478d-3c66-436d-bf95-92daf989a68d"));
  var data = jsonDecode(response.body.toString());
  if (response.statusCode == 200) {
    List<BloodRequestModel> requests = [];
    for (var item in data) {
      requests.add(BloodRequestModel.fromJson(item));
    }
    return requests;
  } else {
    throw Exception('Failed to load events');
  }
}


class BloodRequestModel {
  String? name;
  String? address;
  String? bloodGroupNeeded;
  String? date;
  String? timeAgo;
  String? number;
  int? numberOfBags;

  BloodRequestModel(
      {this.name,
        this.address,
        this.bloodGroupNeeded,
        this.date,
        this.timeAgo,
        this.number,
        this.numberOfBags});

  BloodRequestModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    bloodGroupNeeded = json['blood_group_needed'];
    date = json['date'];
    timeAgo = json['time_ago'];
    number = json['number'];
    numberOfBags = json['number_of_bags'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    data['blood_group_needed'] = this.bloodGroupNeeded;
    data['date'] = this.date;
    data['time_ago'] = this.timeAgo;
    data['number'] = this.number;
    data['number_of_bags'] = this.numberOfBags;
    return data;
  }
}