import 'dart:io';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';


class TruckController extends GetxController {
  var trucks = <Map<String, dynamic>>[].obs;
  var driverLicenseImage = Rx<File?>(null);
  var vehicleImage = Rx<File?>(null);
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchTrucks();
  }
  Future<String> uploadImage(File imageFile, String folderName) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child('$folderName/$fileName');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Image upload error: $e");
      return "";
    }
  }
  Future<void> addVehicle(String dName, String contactNo,String DLNo, String? driverLicenseUrl, String regNo, String model, String vName, String type, String capacity, String fuel, String year ) async {
    try {
      String? driverLicenseUrl;
      String? vehicleImageUrl;

      if (driverLicenseImage.value != null) {
        driverLicenseUrl = await uploadImage(driverLicenseImage.value!, "driver_licenses");
      }
      if (vehicleImage.value != null) {
        vehicleImageUrl = await uploadImage(vehicleImage.value!, "vehicle_images");
      }

      await FirebaseFirestore.instance.collection('vehicles').add({
        'driverName': dName,
        'contactNumber': contactNo,
        'licenseNumber': DLNo,
        'driverLicenseUrl': driverLicenseUrl,
        'registrationNumber': regNo,
        'model': model,
        'vehicleName': vName,
        'vehicleType': type,
        'loadCapacity': capacity,
        'fuelType': fuel,
        'yearOfPurchase': year,
        'vehicleImageUrl': vehicleImageUrl,
      });
      Get.snackbar("Success", "Vehicle added successfully!");
    } catch (e) {
      print("Error adding vehicle: $e");
      Get.snackbar("Error", "Failed to add vehicle");
    }
  }
  void fetchTrucks() {
    FirebaseFirestore.instance.collection('Vehicle').snapshots().listen((snapshot) async {
      try {
        var snapshot = await FirebaseFirestore.instance.collection('Vehicle').get();
        trucks.assignAll(snapshot.docs.map((doc) => doc.data()).toList());
        print("Fetched trucks: ${trucks}");
      } catch (e) {
        print("Error fetching trucks: $e");
      }
    });
  }
  Future<void> pickDriverLicenseImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      driverLicenseImage = File(pickedFile.path) as Rx<File?>;
      update(); // Update GetX UI
    }
  }

  Future<void> pickVehicleImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      vehicleImage = File(pickedFile.path) as Rx<File?>;
      update();
    }
  }
  Future<String> _uploadImage(File imageFile, String folder) async {
    try {
      String fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
      Reference ref = _storage.ref().child("$folder/$fileName");
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return "";
    }
  }
}
