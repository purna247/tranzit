import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ttranzit_app/commons/widgets/constants.dart';
import '../../../controllers/trip_controller.dart';

class OwnerTripTab extends StatelessWidget {
  final TripController tripController = Get.put(TripController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Trip Details"),
        backgroundColor: Colors.amber.shade700,
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: Obx(() {
              if (tripController.trips.isEmpty) {
                return Center(child: Text("No trips available"));
              }

              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: tripController.trips.length,
                itemBuilder: (context, index) {
                  return _buildTripCard(tripController.trips[index], index);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  /// ✅ **Trip Status Toggle (In Progress / Completed)**
  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildTabButton("In Progress", true),
          SizedBox(width: 10),
          _buildTabButton("Completed", false),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, bool value) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          tripController.isInProgress.value = value;
          tripController.fetchTrips();
        },
        child: Obx(() => Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: tripController.isInProgress.value == value ? Colors.amber.shade700 : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: tripController.isInProgress.value == value ? Colors.white : Colors.black,
            ),
          ),
        )),
      ),
    );
  }

  /// ✅ **Trip Card UI**
  Widget _buildTripCard(Map<String, dynamic> trip, int index) {
    return Obx(() {
      bool isExpanded = tripController.isExpandedList[index];

      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.only(bottom: 12),
        color: GlobalVariables.primaryColor2,
        elevation: 4,
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 22,
                backgroundImage: trip['profileImage'] != null && trip['profileImage'].isNotEmpty
                    ? NetworkImage(trip['profileImage'])
                    : const AssetImage("assets/logos/brand_3.png") as ImageProvider,
                onBackgroundImageError: (_, __) {
                  print("Error loading image, using default.");
                },
              ),
              title: Text(
                "${trip['pickupLocation']?['address'] ?? "Unknown"} --- ${trip['destinationLocation']?['address'] ?? "Unknown"}",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              subtitle: Text(
                "${trip['startDate'] ?? "No Start Date"} - ${trip['endDate'] ?? "No End Date"}",
                style: GoogleFonts.poppins(fontSize: 12, color: GlobalVariables.secondaryColor1),
              ),
              trailing: IconButton(
                icon: Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: GlobalVariables.secondaryColor1,
                ),
                onPressed: () {
                  tripController.toggleExpand(index);
                },
              ),
            ),
            if (isExpanded)
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoText("Vehicle Number", trip['vehicleNumber'] ?? "N/A"),
                    _infoText("Payment Status", trip['paymentStatus'] ?? "Pending"),
                    SizedBox(height: 10),
                    _actionButton("E-challan", GlobalVariables.secondaryColor1),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _infoText(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Text(
        "$title - $value",
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade800),
      ),
    );
  }

  Widget _actionButton(String text, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () {},
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }
}
