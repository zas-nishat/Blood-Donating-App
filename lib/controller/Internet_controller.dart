import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResults) {
    final ConnectivityResult connectivityResult = connectivityResults.last;

    if (connectivityResult == ConnectivityResult.none) {
      Get.rawSnackbar(
        messageText: const Text(
          "You're not connected to the internet. Please connect to internet or some function may not work",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        isDismissible: false,
        duration: const Duration(days: 1),
        icon: const Icon(Icons.wifi_off, color: Colors.red),
        margin: EdgeInsets.zero,
        snackStyle: SnackStyle.GROUNDED,
      );
    } else {
      if (Get.isSnackbarOpen) {
        Get.rawSnackbar(
          messageText: const Text(
            'Your internet connection restored.',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          isDismissible: true,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
          snackStyle: SnackStyle.GROUNDED,
        );
        Get.closeCurrentSnackbar();
      }
    }
  }
}

///DependencyInjection
///
class DependencyInjection {

  static void init() {
    Get.put<NetworkController>(NetworkController(),permanent:true);
  }
}