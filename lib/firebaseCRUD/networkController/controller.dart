import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InternetController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    // Listen for connectivity changes
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    // print("Checking initial connection");
    try {
      List<ConnectivityResult> result = await _connectivity.checkConnectivity();
      // if(result.first == ConnectivityResult.none)
      // print('This is the list of connectivity result: $result');
      // print("Initial connection status: $result");
      _updateConnectionStatus(result);
    } catch (e) {
      // print("Error checking initial connection: $e");
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    // print('Network Status Changed!');
    // print('List: $result');
    if (result.first == ConnectivityResult.none) {
      // print("Connectivity Lost");
      Get.rawSnackbar(
        messageText: const Text(
          'PLEASE CONNECT TO THE INTERNET',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        isDismissible: false,
        duration: const Duration(days: 1),
        backgroundColor: Colors.red[400]!,
        icon: const Icon(
          Icons.wifi_off,
          color: Colors.white,
          size: 35,
        ),
        snackStyle: SnackStyle.GROUNDED,
      );
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }
}
