import 'package:blood_donating/Screens/Find%20Donor%20Dire/FindDonor_Page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Function/Notification_dire/firebase_notification_service.dart';
import '../../Widget/Custom Drawer Header.dart';
import '../Blood Request List Dire/AllBloodRequest_Screen.dart';
import '../Find Donor Dire/DonorRegisterForm_Screen.dart';
import '../My Blood Request Dire/BloodRequestForm.dart';
import 'HomeRequestList_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = -1;
  String _timeLeftText = '';

  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  NotificationServices notificationService = NotificationServices();

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    notificationService.requestNotificationPermission();
    notificationService.getDeviceToken().then((value){
      if(kDebugMode) {
        print("device token");
      }
      if(kDebugMode) {
        print(value);
      }
    });
    notificationService.firebaseInit();
  }

  Future<void> _calculateTimeLeft() async {
    final userDoc = usersCollection.doc(user.uid);
    final userSnapshot = await userDoc.get();
    if (userSnapshot.exists) {
      final lastDonation = userSnapshot['lastDonation']?.toDate();
      if (lastDonation != null) {
        final nextDonationDate = lastDonation.add(const Duration(days: 90));
        final now = DateTime.now();

        if (now.isBefore(nextDonationDate)) {
          final timeLeft = nextDonationDate.difference(now);
          setState(() {
            _timeLeftText =
            '${timeLeft.inDays} days ${timeLeft.inHours % 24} hours ${timeLeft.inMinutes % 60} minutes';
          });
        } else {
          setState(() {
            _timeLeftText = 'You can donate blood';
          });
        }
      } else {
        setState(() {
          _timeLeftText = 'You can donate blood now!';
        });
      }
    }
  }

  Future<void> _refreshPage() async {
    await _calculateTimeLeft();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Blood Donation",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _timeLeftText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //     Get.to(GetLocation());
      //   },
      //   child: Icon(Icons.add),
      // ),
      drawer: const CustomDrawerHeader(),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: Padding(
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
                      Get.to(const FindDonorPage());
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
                  const Text(
                    "Request List: ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(const AllBloodRequestScreen());
                    },
                    child: const Text(
                      "See all ",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              HomeRequestListScreen()
            ],
          ),
        ),
      ),
    );
  }

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
}
