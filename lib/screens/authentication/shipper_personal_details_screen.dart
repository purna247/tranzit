import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ttranzit_app/commons/widgets/constants.dart';
import '../../controllers/authentication/personal_details_controller.dart';
import '../../controllers/authentication/auth_controller.dart';

class ShipperPersonalDetailsScreen extends StatefulWidget {
  final String email;
  final String pw;

  const ShipperPersonalDetailsScreen({super.key, required this.pw, required this.email});

  @override
  State<ShipperPersonalDetailsScreen> createState() => _ShipperPersonalDetailsScreenState();
}

class _ShipperPersonalDetailsScreenState extends State<ShipperPersonalDetailsScreen> {
  final PersonalDetailsController controller = Get.put(PersonalDetailsController());
  final AuthController authController = Get.put(AuthController());

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController gstinController = TextEditingController();

  var selectedState = ''.obs;
  var selectedCountry = ''.obs;

  List<String> states = ['State 1', 'State 2', 'State 3'];
  List<String> countries = ['Country 1', 'Country 2', 'Country 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.primaryColor2,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 350,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/truck_image.png"),
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
                    "Brand Details",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: GlobalVariables.secondaryColor2,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Form Fields
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person, color: GlobalVariables.secondaryColor2),
                            labelText: "Name",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: GlobalVariables.borderColor),
                            ),
                          ),
                          validator: (value) => value!.isEmpty ? "Enter your name" : null,
                        ),
                        const SizedBox(height: 15),

                        TextFormField(
                          controller: contactController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone, color: Colors.brown),
                            labelText: "Contact Number",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: GlobalVariables.borderColor),
                            ),
                          ),
                          validator: (value) => value!.isEmpty ? "Enter your contact number" : null,
                        ),
                        const SizedBox(height: 15),

                        TextFormField(
                          controller: addressController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.home, color: Colors.brown),
                            labelText: "House Number, Locality",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: GlobalVariables.borderColor),
                            ),
                          ),
                          validator: (value) => value!.isEmpty ? "Enter your address" : null,
                        ),
                        const SizedBox(height: 20),

                        // Dropdowns for State & Country
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
                                value: selectedCountry.value.isEmpty ? null : selectedCountry.value,
                                hint: "Country",
                                items: countries,
                                onChanged: (value) => selectedCountry.value = value!,
                              )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        TextFormField(
                          controller: gstinController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.credit_card, color: Colors.brown),
                            labelText: "GSTIN Number",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: GlobalVariables.borderColor),
                            ),
                          ),
                          validator: (value) => value!.isEmpty ? "Enter your Driving Licence Number" : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Navigation Buttons
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
                            authController.signUpShipper(widget.email, widget.pw,nameController.text, contactController.text,selectedState.value,
                                selectedCountry.value, addressController.text,gstinController.text);
                          } else {
                            Get.snackbar("Error", "Please fill in all fields correctly.");
                          }
                        },
                        child: Icon(Icons.arrow_forward, color: Colors.white),
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
}

Widget _buildDropdown({required String? value, required String hint, required List<String> items, required ValueChanged<String?> onChanged}) {
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
