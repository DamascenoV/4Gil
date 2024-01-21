import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:battery_plus/battery_plus.dart';
import 'package:background_location/background_location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  late LocationSettings locationSettings;
  late Battery battery;
  RxString latitude = "0".obs;
  RxString longitude = "0".obs;
  RxString accuracy = "0".obs;
  RxString altitude = "0".obs;
  RxString bearing = "0".obs;
  RxString speed = "0".obs;
  RxString time = "0".obs;
  late RxInt batteryLevel = 0.obs;

  @override
  void onReady() {
    super.onReady();
    startGetLocation();
  }

  Future<void> startGetLocation() async {
    await BackgroundLocation.setAndroidNotification(
      title: 'Background service is running',
      message: 'Background location in progress',
      icon: '@mipmap/ic_launcher',
    );
    battery = Battery();

    batteryLevel.value = await battery.batteryLevel;
    await BackgroundLocation.setAndroidConfiguration(10000);
    await BackgroundLocation.startLocationService(distanceFilter: 5);
    await BackgroundLocation.getLocationUpdates((Location location) {
        latitude.value = location.latitude.toString();
        longitude.value = location.longitude.toString();
        accuracy.value = location.accuracy.toString();
        altitude.value = location.altitude.toString();
        bearing.value = location.bearing.toString();
        speed.value = location.speed.toString();
        time.value = DateTime.fromMillisecondsSinceEpoch(
                location.time!.toInt())
            .toString();
      debugPrint('''\n
              Latitude:  $latitude
              Longitude: $longitude
              Altitude: $altitude
              Accuracy: $accuracy
              Bearing:  $bearing
              Speed: $speed
              Time: $time
              Battery: $batteryLevel
            ''');

      Map data = {
        'id': 1,
        'latitude': latitude.value,
        'longitude': longitude.value,
        'altitude': altitude.value,
        'accuracy': accuracy.value,
        'bearing': bearing.value,
        'speed': speed.value,
        'time': time.value,
        'battery': batteryLevel.value
      };

        sendRequest(data);
    });
  }

  Future<http.Response> sendRequest(Map body) async {
    try {
      Uri url = Uri.parse('');
      var requestBody = json.encode(body);

      var response = await http.post(url,
        headers: {"Content-type": "application/json"},
        body: requestBody
      );

      debugPrint(response.body);
      debugPrint('${response.statusCode}');
      return response;
    } catch (error) {
      debugPrint('ERRO: $error');
      Get.snackbar('Error', error.toString());
      rethrow;
    }
  }
}

