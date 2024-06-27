import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Screens/AllBloodRequest_Screen.dart';
import 'Screens/BloodRequestForm.dart';
import 'Screens/DonorRegisterForm_Screen.dart';
import 'Screens/HomeRequestList_Screen.dart';
import 'Screens/Profile_Screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = -1;

  Widget _container(String image, String text, bool isSelected, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Get.height * 0.15,
        width: Get.width * 0.3,
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
            Image.network(
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
          "Blood Donation App",
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("John Doe"),
              accountEmail: Text("johndoe@example.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://via.placeholder.com/150",
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.app_registration),
              title: const Text('Donor Registration'),
              onTap: () {
                Get.to(const DonorRegisterFormScreen());
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add_rounded),
              title: const Text('Find Donor'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bloodtype),
              title: const Text('Blood Request'),
              onTap: () {
                Get.to(const BloodRequestForm());
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Get.to(const ProfileScreen());
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _container(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbXGdX3UjKffveecWO2lvWsjdsg0L9KZhuPA&s",
                  'Find Donor',
                  selectedIndex == 0,
                      () {
                    setState(() {
                      selectedIndex = 0;
                    });
                    Get.to(const ProfileScreen());
                  },
                ),
                _container(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRwM2JmG5hq9wEe4aXjDDj2PMglKgPoXvc7sw&s',
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
                "https://static.vecteezy.com/system/resources/thumbnails/021/432/955/small_2x/blood-donation-icon-png.png",
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
            const HomeRequestListScreen()
          ],
        ),
      ),
    );
  }
}
