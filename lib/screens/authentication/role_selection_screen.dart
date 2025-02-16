import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ttranzit_app/screens/authentication/signup_screen.dart';

import '../../controllers/authentication/role_selection_controller.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
   RoleSelectionController roleController = Get.put(RoleSelectionController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcome Text
            const Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),

            // Choose Who You Are Text
            Text(
              'Choose Who You Are',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 40),

            // Shipper Button
            _buildRoleButton(
              context,
              title: 'Shipper',
              icon: Icons.local_shipping,
              color: Colors.blue,
              onPressed: () {
                roleController.selectedOption("Shipper");
                Get.to(SignUpScreen(role: roleController.selectedOption.toString()));
                print('Shipper selected');
              },
            ),
            SizedBox(height: 20),

            // Owner Button
            _buildRoleButton(
              context,
              title: 'Owner',
              icon: Icons.business,
              color: Colors.green,
              onPressed: () {
                roleController.selectedOption("Owner");
                Get.to(SignUpScreen(role: roleController.selectedOption.toString()));
                print('Owner selected');
              },
            ),
            SizedBox(height: 20),

            // Driver Button
            _buildRoleButton(
              context,
              title: 'Driver',
              icon: Icons.drive_eta,
              color: Colors.orange,
              onPressed: () {
                roleController.selectedOption("Driver");
                Get.to(SignUpScreen(role: roleController.selectedOption.toString()));
                print('Driver selected');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required VoidCallback onPressed,
      }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: Colors.white),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}