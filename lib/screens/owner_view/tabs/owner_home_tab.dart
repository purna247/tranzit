import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:ttranzit_app/controllers/job_controller.dart';

import '../../../commons/widgets/constants.dart';
import '../../../commons/widgets/mini_map.dart';
import '../../../controllers/truck_controller.dart';
import '../../../map_screen.dart';

class OwnerHomeTab extends StatefulWidget {
  @override
  State<OwnerHomeTab> createState() => _OwnerHomeTabState();
}

class _OwnerHomeTabState extends State<OwnerHomeTab> {
  final TrackingController trackingController = Get.put(TrackingController());
  final JobController jobController = Get.put(JobController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome!",
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black)),
            SizedBox(width: 10),
            Text("Sourav Sundar",
                style: GoogleFonts.poppins(
                    fontSize: 24,
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
                    Get.to(MapScreen( latitude: trackingController.latitude.value,
                      longitude: trackingController.longitude.value,));
                  },
                  child: Text("View Map"),
                )
              ],
            ),
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: MiniMapWidget(
                latitude: trackingController.latitude.value,
                longitude: trackingController.longitude.value,
              ),
            ),
            SizedBox(height: 20),

            // Available Trucks
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Jobs Around You",
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
              if (jobController.jobs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("No jobs available"),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          jobController.fetchAllJobs();
                        },
                        child: Text("Reload Jobs"),
                      ),
                    ],
                  ),
                );
              }

              return SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: jobController.jobs.length,
                  itemBuilder: (context, index) {
                    var job = jobController.jobs[index]; // Get job data

                    return _jobItem(
                      job['estimatedTime']?.toString() ?? "Unknown", // Load capacity
                      job['estimatedDistance'] ?? "Unknown", // Goods type
                      job['priceTag'] ?? "Unknown", // Estimated distance
                      "assets/logos/brand_1.png", // Default placeholder image
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

  Widget _jobItem(
      String time, String distance, String priceTag, String imagePath) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
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
              "$time hr | $distance km | Rs.$priceTag/ton  ",
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



class TrackingController extends GetxController {
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref("tracking/driver2");

  @override
  void onInit() {
    super.onInit();
    _listenToLocationUpdates();
  }

  void _listenToLocationUpdates() {
    _databaseRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        latitude.value = data['latitude'];
        longitude.value = data['longitude'];
      }
    });
  }
}
