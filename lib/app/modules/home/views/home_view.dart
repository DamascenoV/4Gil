import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

import 'package:background_location/background_location.dart';

var homeController = Get.put(HomeController());

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
      ),
      body: Center(
          child: ListView(children: <Widget>[
        Obx(() => locationData('Latitude: ${homeController.latitude.value}')),
        Obx(() => locationData('Longitude: ${homeController.longitude.value}')),
        Obx(() => locationData('Altitude: ${homeController.altitude.value}')),
        Obx(() => locationData('Accuracy: ${homeController.accuracy.value}')),
        Obx(() => locationData('Bearing: ${homeController.bearing.value}')),
        Obx(() => locationData('Speed: ${homeController.speed.value}')),
        Obx(() => locationData('Time: ${homeController.time.value}')),
        Obx(() => locationData('Battery: ${homeController.batteryLevel.value}')),
        ElevatedButton(
            onPressed: () async {
              homeController.startGetLocation();
            },
            child: const Text('Start Location Service')),
        ElevatedButton(
            onPressed: () {
              BackgroundLocation.stopLocationService();
            },
            child: const Text('Stop Location Service')),
        ElevatedButton(
            onPressed: () {
              getCurrentLocation();
            },
            child: const Text('Get Current Location')),
      ])),
    );
  }
}

Widget locationData(String data) {
    return Text(
      data,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      textAlign: TextAlign.center,
    );
  }

  void getCurrentLocation() {
    BackgroundLocation().getCurrentLocation().then((location) {
      print('This is current Location ${location.toMap()}');
    });
  }
