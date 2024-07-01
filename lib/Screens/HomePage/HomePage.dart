import 'package:blood_donating/Screens/Find%20Donor%20Dire/FindDonor_Page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widget/Custom Drawer Header.dart';
import '../Blood Request List Dire/AllBloodRequest_Screen.dart';
import '../Find Donor Dire/DonorRegisterForm_Screen.dart';
import '../My Blood Request Dire/Request Blood Form Screen.dart';
import 'HomeRequestList_Screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = -1;

  ///Select option
  Widget _container(String image, String text, bool isSelected, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Get.height * 0.2,
        width: Get.width * 0.35,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isSelected ? Colors.white : Colors.red
          ),
          color: isSelected ? Colors.red : Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              image,
              height: 60,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.red,
              ),
            ),
          ],
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
        title: const Text(
          "Blood Donation",
          style: TextStyle(color: Colors.white,
          fontWeight: FontWeight.bold),
        ),
      ),
      drawer: CustomDrawerHeader(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _container(
                  "Assets/FindDonor.png",
                  'Find Donor',
                  selectedIndex == 0,
                      () {
                    setState(() {
                      selectedIndex = 0;
                    });
                    Get.to(FindDonorPage());
                  },
                ),
                _container(
                  'Assets/Request.png',
                  'Request',
                  selectedIndex == 1,
                      () {
                    setState(() {
                      selectedIndex = 1;
                    });
                    Get.to(const BloodRequestForm());
                  },
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Center(
              child: _container(
                "Assets/WantToDonate.png",
                'I want to Donate',
                selectedIndex == 2,
                    () {
                  setState(() {
                    selectedIndex = 2;
                  });
                  Get.to(const DonorRegisterFormScreen());
                },
              ),
            ),
            const SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Request List: ",style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),),
                GestureDetector(
                  onTap: (){
                    Get.to(const AllBloodRequestScreen());
                  },
                  child: const Text("See all ",style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold
                  ),),
                ),
              ],
            ),
            const Divider(),
            HomeRequestListScreen()
          ],
        ),
      ),
    );
  }
}
