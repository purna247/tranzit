import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:ttranzit_app/controllers/truck_controller.dart';
import 'package:image_picker/image_picker.dart';


class AddVehicleScreen extends StatefulWidget {
  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final TruckController truckController = Get.put(TruckController());
  final TextEditingController driverNameController = TextEditingController();
  final TextEditingController driverContactController = TextEditingController();
  final TextEditingController driverLicenseController = TextEditingController();

  final TextEditingController regNumberController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController vehicleNameController = TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController loadCapacityController = TextEditingController();
  final TextEditingController fuelTypeController = TextEditingController();
  final TextEditingController yearOfPurchaseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      appBar: AppBar(
        title: Text("Add Vehicle", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.amber.shade700,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Driver Details"),
            _buildDriverDetailsSection(),

            SizedBox(height: 20),

            _sectionTitle("Vehicle Details"),
            _buildVehicleDetailsSection(),

            SizedBox(height: 20),

            // Add Vehicle Button
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade700,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  _submitForm();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: Text(
                    "Add Vehicle",
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
      ),
    );
  }

  Widget _buildDriverDetailsSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(driverNameController, "Driver's Name"),
            _buildTextField(driverContactController, "Driver's Contact Number"),
            _buildTextField(driverLicenseController, "Driver's License Number"),
            Obx(() => _imagePickerButton("Attach Driver's License", true, truckController.driverLicenseImage.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleDetailsSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(regNumberController, "Registration Number"),
            _buildDropdownField("Model"),
            _buildDropdownField("Vehicle Name"),
            _buildDropdownField("Vehicle Type"),
            _buildTextField(loadCapacityController, "Vehicle's Load Capacity"),
            _buildTextField(fuelTypeController, "Fuel Type"),
            _buildTextField(yearOfPurchaseController, "Year of Purchase"),
            Obx(() => _imagePickerButton("Upload Image of Vehicle", false, truckController.vehicleImage.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDropdownField(String hint) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.white,
        ),
        items: ["Option 1", "Option 2", "Option 3"]
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: (value) {},
      ),
    );
  }

  Widget _buildFileUploadButton(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.amber.shade700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          print("Upload file for $label");
        },
        icon: Icon(Icons.link, color: Colors.amber.shade700),
        label: Text(
          label,
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.amber.shade700),
        ),
      ),
    );
  }

  Widget _imagePickerButton(String label, bool isDriverLicense, File? imageFile) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () => pickImage(isDriverLicense),
          icon: Icon(Icons.attach_file),
          label: Text(label),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade700),
        ),
        if (imageFile != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Image.file(imageFile, height: 100, width: 100, fit: BoxFit.cover),
          ),
      ],
    );
  }

  Future<void> pickImage(bool isDriverLicense) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (isDriverLicense) {
        truckController.driverLicenseImage.value = File(pickedFile.path);
      } else {
        truckController.vehicleImage.value = File(pickedFile.path);
      }
    }
  }

  void _submitForm() {
   truckController.addVehicle(driverNameController.text,
       driverContactController.text,
       driverLicenseController.text,
       driverLicenseController.text,
       regNumberController.text,
       modelController.text,
       vehicleNameController.text,
       vehicleTypeController.text,
       loadCapacityController.text,
       fuelTypeController.text,
       yearOfPurchaseController.text);
  }

}
