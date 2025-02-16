import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var isTracking = false.obs;
  var locationMessage = "Tap the button to get location".obs;

  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref("tracking");

  // Start tracking live location updates
  void startTracking(String driverId) async {
    isTracking.value = true;

    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Updates every 10 meters
      ),
    ).listen((Position position) {
      latitude.value = position.latitude;
      longitude.value = position.longitude;
      locationMessage.value = "Lat: ${position.latitude}, Lng: ${position.longitude}";

      // Update location in Firebase Realtime Database
      databaseRef.child(driverId).set({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      }).then((_) {
        print("Location updated in Firebase!");
      }).catchError((error) {
        print("Firebase update error: $error");
      });
    });
  }
}
