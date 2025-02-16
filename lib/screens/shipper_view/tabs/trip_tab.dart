import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ttranzit_app/commons/widgets/constants.dart';
import '../../../controllers/echalan_controller.dart';
import '../../../controllers/trip_controller.dart';


class ShipperTripTab extends StatefulWidget {
  @override
  State<ShipperTripTab> createState() => _ShipperTripTabState();
}

class _ShipperTripTabState extends State<ShipperTripTab> {
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
              if (tripController.isExpandedList.length != tripController.trips.length) {
                tripController.isExpandedList.assignAll(List.generate(tripController.trips.length, (_) => false));
              }

              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: tripController.trips.length,
                itemBuilder: (context, index) {
                  return _buildTripCard(tripController.trips[index], index, tripController.isExpandedList);
                },
              );
            }),
          ),

        ],
      ),
    );
  }

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

  Widget _buildTripCard(Map<String, dynamic> trip, int index, RxList<bool> isExpandedList) {
    String pickupAddress = trip['pickupLocation']?['address'] ?? "Unknown Pickup";
    String destinationAddress = trip['destinationLocation']?['address'] ?? "Unknown Destination";
    String startDate = trip['startDate'] ?? "No Start Date";
    String endDate = trip['endDate'] ?? "No End Date";
    String owner = trip['owner'] ?? "Unknown Owner";
    String vehicleNumber = trip['vehicleNumber'] ?? "N/A";
    String paymentStatus = trip['paymentStatus'] ?? "Pending";

    return Obx(() => Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.only(bottom: 12),
      color:GlobalVariables.primaryColor2,
      elevation: 4,
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 22,
              backgroundImage: trip['profileImage'] != null && trip['profileImage'].isNotEmpty
                  ? NetworkImage(trip['profileImage'])
                  : const AssetImage("assets/images/driver_1.png") as ImageProvider,
              onBackgroundImageError: (_, __) {
                print("Error loading image, falling back to default.");
              },
            ),
            title: Text(
              "$pickupAddress --- $destinationAddress",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            subtitle: Text(
              "$startDate - $endDate",
              style: GoogleFonts.poppins(fontSize: 12, color: GlobalVariables.secondaryColor1),
            ),
            trailing: IconButton(
              icon: Icon(
                isExpandedList[index] ? Icons.expand_less : Icons.expand_more,
                color: GlobalVariables.secondaryColor1,
              ),
              onPressed: () {
                isExpandedList[index] = !isExpandedList[index];
              },
            ),
          ),
          if (isExpandedList[index])
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoText("Owner", owner),
                  _infoText("Vehicle Number", vehicleNumber),
                  _infoText("Payment Status", paymentStatus),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _actionButton("Pay", GlobalVariables.secondaryColor1),
                      GeneratePDFButton(color: Colors.blue, text: "E-Challan ")
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    ));
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
class GeneratePDFButton extends StatelessWidget {
  final Color color;
  final String text;

  GeneratePDFButton({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed:() async {
        String responseMessage = await generateAndDownloadPDF();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseMessage)),
        );
      },
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }
}

