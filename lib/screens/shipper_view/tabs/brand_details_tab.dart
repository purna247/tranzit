import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BrandDetailsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber.shade700,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
      Container(
      width: Get.size.width,
        color: Colors.amber.shade700,
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 40,
              child: Image.asset("assets/logos/brand_1.png", height: 50), // Replace with actual logo
            ),
            SizedBox(height: 10),
            Text(
              "Larsen & Toubro",
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
            ),
          ],
        ),
      ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: [
                  _buildDetailItem(LucideIcons.user, "Larsen Toubro"),
                  _buildDetailItem(LucideIcons.phone, "+91 123456789"),
                  _buildDetailItem(LucideIcons.home, "Plot No. - 149, Industrial & Business"),
                  _buildDetailItem(LucideIcons.mapPin, "Chandigarh"),
                  _buildDetailItem(LucideIcons.globe, "India"),
                  _buildDetailItem(LucideIcons.mail, "larsentoubro@gmail.com"),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          // Edit Profile Action
        },
        child: Icon(LucideIcons.pencil, color: Colors.white),
      ),
    );
  }



  Widget _buildDetailItem(IconData icon, String text) {
    return Container(

      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
