import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:ttranzit_app/commons/widgets/constants.dart';
import 'package:ttranzit_app/controllers/authentication/role_selection_controller.dart';
import 'package:ttranzit_app/screens/authentication/shipper_personal_details_screen.dart';
import 'package:ttranzit_app/screens/authentication/signin_screen.dart';

import 'driver_personal_details_screen.dart';
import 'owner_personal_details_screen.dart';

class SignUpScreen extends StatefulWidget {
  final String role;
  const SignUpScreen({super.key, required this.role});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SignUpScreen> {
  RoleSelectionController roleController = Get.put(RoleSelectionController());

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();

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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      "Register as ${widget.role}",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: GlobalVariables.secondaryColor2,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email, color: GlobalVariables.secondaryColor2),
                        labelText: "E mail ID",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: GlobalVariables.borderColor),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),

                    TextFormField(
                      controller: _pwController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Colors.brown),
                        labelText: "Password",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: GlobalVariables.borderColor),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FloatingActionButton(
                          backgroundColor: Colors.amber.shade700,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        FloatingActionButton(
                          backgroundColor: Colors.amber.shade700,
                          onPressed: () {
                            print("error: $_formKey.currentState!");
                            if (_formKey.currentState!.validate()) {
                              if (widget.role == "Shipper") {
                                Get.to(ShipperPersonalDetailsScreen(
                                  email: _emailController.text,
                                  pw: _pwController.text,
                                ));
                              } else if (widget.role == "Owner") {
                                Get.to(OwnerPersonalDetailsScreen(
                                  email: _emailController.text,
                                  pw: _pwController.text,
                                ));
                              } else if (widget.role == "Driver") {
                                Get.to(DriverPersonalDetailsScreen(
                                  email: _emailController.text,
                                  pw: _pwController.text,
                                ));
                              }
                            }
                          },
                          child: Icon(Icons.arrow_forward, color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Row(
                        children: [
                          const Text("Already have an account ?",style: TextStyle(color: GlobalVariables.secondaryColor2),),
                          InkWell(
                            onTap: (){
                              Get.to(SignInScreen());
                            },
                            child: const Text("SignIn",style: TextStyle(color: Colors.blue),),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
