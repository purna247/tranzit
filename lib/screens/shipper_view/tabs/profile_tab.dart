import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import 'brand_details_tab.dart';
import 'brand_stats_tab.dart';


class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber.shade700,
        elevation: 0,
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildProfileHeader(),
          _buildMenuOptions(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: Get.size.width * 1,
      color: Colors.amber.shade700,
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 40,
            child: Image.asset("assets/logos/brand_1.png", height: 50),
          ),
          SizedBox(height: 10),
          Text(
            "Larsen & Toubro",
            style: GoogleFonts.poppins(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOptions(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            _buildMenuItem(context, "Brand Details", BrandDetailsTab(),),
            _buildMenuItem(context, "Brand Stats", BrandStatsTab()),
            _buildMenuItem(
                context, "Settings", BrandDetailsTab(), isHighlighted: true),
          ],
        ),
      ),
    );
  }

  // Menu Item UI
  Widget _buildMenuItem(BuildContext context, String title, Widget targetPage,
      {bool isHighlighted = false}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isHighlighted ? Colors.white : Colors.amber.shade100,
          borderRadius: BorderRadius.circular(12),
          border: isHighlighted
              ? Border.all(color: Colors.blue, width: 2)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
