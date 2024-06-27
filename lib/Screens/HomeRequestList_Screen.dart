import 'package:blood_donating/Screens/BloodDetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../API/BloodRequestModel.dart';
import '../Function/MakeCall.dart';

class HomeRequestListScreen extends StatelessWidget {
  const HomeRequestListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<BloodRequestModel>>(
        future: GetBloodData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final request = data[index];
                return GestureDetector(
                  onTap: (){
                    Get.to(BloodDetails());
                  },
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Blood Group: ${request.bloodGroupNeeded}",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                                Text(
                                  "${request.timeAgo}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                            Text(
                              "${request.name}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${request.numberOfBags} Bag${request.numberOfBags! > 1 ? 's' : ''}",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "${request.number}",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "${request.address}",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${request.date}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    makePhoneCall(request.number.toString());
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 9.0, vertical: 5),
                                      child: Text(
                                        "Confirm",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
