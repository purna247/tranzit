import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:ttranzit_app/commons/widgets/constants.dart';
import 'package:ttranzit_app/controllers/truck_controller.dart';

import '../../../commons/widgets/mini_map.dart';
import '../../../map_screen.dart';



class HomeTab extends StatefulWidget {
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final TruckController truckController = Get.put(TruckController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/logos/brand_1.png', height: 30),
            SizedBox(width: 10),
            Text("Larsen & Toubro",
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: GlobalVariables.primaryColor1)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(LucideIcons.bell, color: Colors.orange),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carousel Slider
            CarouselSlider(
              options: CarouselOptions(
                  height: 180, autoPlay: true, enlargeCenterPage: true),
              items: [
                'assets/images/banner_1.png',
                'assets/images/banner_1.png'
              ].map((item) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(item,
                      fit: BoxFit.cover, width: double.infinity),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Track your Shipment",
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: GlobalVariables.primaryColor1)),
                GestureDetector(
                  onTap: () {
                    Get.to(MapScreen(latitude: 22.5726, longitude: 88.3639));
                  },
                  child: Text("View Map"),
                )
              ],
            ),
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: MiniMapWidget(latitude: 22.5726, longitude: 88.3639),
            ),
            SizedBox(height: 20),

            // Available Trucks
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Available Trucks",
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                Text("See all",
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: Colors.orange)),
              ],
            ),
            SizedBox(height: 10),

            // Truck List
            Obx(() {
              if (truckController.trucks.isEmpty) {
                return Column(
                  children: [
                    Center(child: Text("No trucks available")),
                    ElevatedButton(
                      onPressed: () {
                        truckController.fetchTrucks();
                      },
                      child: Text("Reload Trucks"),
                    )
                  ],
                );
              }
              return SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: truckController.trucks.length,
                  itemBuilder: (context, index) {
                    var truck = truckController.trucks[index];
                    return _truckItem(
                      truck['capacity'].toString(),
                      truck['fuelType'] ?? "Unknown",
                      truck['model'] ?? "Unknown",
                      truck['imagePath'] ?? "assets/images/vehicle_2.png",
                    );
                  },
                ),
              );
            })
          ],
        ),
      ),
    );
  }

  Widget _truckItem(
      String capacity, String fuelType, String model, String imagePath) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(imagePath,
                height: 50, width: 50, fit: BoxFit.cover),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "$capacity | $fuelType | $model ",
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
