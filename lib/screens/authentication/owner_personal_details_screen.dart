import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:ttranzit_app/commons/widgets/constants.dart';
import 'package:ttranzit_app/controllers/authentication/role_selection_controller.dart';

import '../../controllers/authentication/auth_controller.dart';
import '../../controllers/authentication/personal_details_controller.dart';

class OwnerPersonalDetailsScreen extends StatefulWidget {
  final String email;
  final String pw;
  const OwnerPersonalDetailsScreen({super.key, required this.email, required this.pw});

  @override
  State<OwnerPersonalDetailsScreen> createState() => _OwnerPersonalDetailsScreenState();
}

class _OwnerPersonalDetailsScreenState extends State<OwnerPersonalDetailsScreen> {
  final PersonalDetailsController controller = Get.put(PersonalDetailsController());
  final AuthController authController = Get.put(AuthController());


  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  var selectedState = ''.obs;
  var selectedCountry = ''.obs;

  List<String> states = ['State 1', 'State 2', 'State 3'];
  List<String> countries = ['Country 1', 'Country 2', 'Country 3'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.primaryColor2, // Matches the theme of the image
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Background image with a truck
            Stack(
              children: [
                Container(
                  height: 350,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/truck_image.png"), // Add your background image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 250,
                  left: MediaQuery.of(context).size.width / 2 - 40,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.amber.shade700,
                    child: Icon(Icons.business, size: 40, color: Colors.white),
                  ),
                ),
              ],
            ),

            // Registration Form
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    "Personal Details",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color:GlobalVariables.secondaryColor2,
                    ),
                  ),
                  SizedBox(height: 20),

                  Form(
                    key:_formKey ,
                    child: Column(
                        children:[ TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email, color:GlobalVariables.secondaryColor2),
                        labelText: "Name",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: GlobalVariables.borderColor),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    
                    // Password Field
                    TextField(
                      controller: contactController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Colors.brown),
                        labelText: "Contact Number",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:BorderSide(color: GlobalVariables.borderColor),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    
                    // Password Field
                    TextField(
                      controller: addressController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Colors.brown),
                        labelText: "House Number, Locality",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:BorderSide(color: GlobalVariables.borderColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() => _buildDropdown(
                            value: selectedState.value.isEmpty ? null : selectedState.value,
                            hint: "State",
                            items: states,
                            onChanged: (value) => selectedState.value = value!,
                          )),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Obx(() => _buildDropdown(
                            value: selectedCountry.value.isEmpty ? null :selectedCountry.value,
                            hint: "Country",
                            items: countries,
                            onChanged: (value) => selectedCountry.value = value!,
                          )),
                        ),
                      ],
                    ),]),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton(
                        backgroundColor: Colors.amber.shade700,
                        onPressed: () {
                          Navigator.pop(context); // Go back
                        },
                        child: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      FloatingActionButton(
                        backgroundColor: Colors.amber.shade700,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            authController.signUpOwner(
                              widget.email,
                              widget.pw,
                              nameController.text,
                              contactController.text,
                              addressController.text,
                              selectedState.value,
                              selectedCountry.value,
                            );
                          }
                        },
                        child:Text("Register",),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} Widget _buildDropdown({required String? value, required String hint, required List<String> items, required ValueChanged<String?> onChanged}) {
  return DropdownButtonFormField<String>(
    value: value,
    hint: Text(hint),
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    ),
    onChanged: onChanged,
    items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
  );
}

