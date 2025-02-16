import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ttranzit_app/commons/widgets/constants.dart';
import 'package:ttranzit_app/controllers/job_controller.dart';
import '../../../controllers/trip_controller.dart';

class OwnerJobTab extends StatefulWidget {
  @override
  State<OwnerJobTab> createState() => _OwnerJobTabState();
}

class _OwnerJobTabState extends State<OwnerJobTab> {
  final JobController jobController = Get.put(JobController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Jobs Around You"),
        backgroundColor: Colors.amber.shade700,
      ),
      body: Column(
        children: [

          Expanded(
            child: Obx(() {
              // Ensure isExpandedList has the correct length
              if (jobController.isExpandedList.length != jobController.jobs.length) {
                jobController.isExpandedList.assignAll(List.generate(jobController.jobs.length, (_) => false));
              }

              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: jobController.jobs.length,
                itemBuilder: (context, index) {
                  return _buildJobCard(jobController.jobs[index], index, jobController.isExpandedList);
                },
              );
            }),
          ),

        ],
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job, int index, RxList<bool> isExpandedList) {
    String pickupAddress = job['pickupLocation']?['address'] ?? "Unknown Pickup";
    String destinationAddress = job['destinationLocation']?['address'] ?? "Unknown Destination";
    String goodType = job['goodsType'] ?? "Not available";
    String time = job['estimatedTime'] ?? "N/A";
    String capacity = job['loadCapacity'] ?? "N/A";
    String distance = job['estimatedDistance'] ?? "N/A";
    String price = job['priceTag'] ?? "N/A";

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
              backgroundImage: job['profileImage'] != null && job['profileImage'].isNotEmpty
                  ? NetworkImage(job['profileImage'])
                  : const AssetImage("assets/logos/brand_2.png") as ImageProvider,
              onBackgroundImageError: (_, __) {
                print("Error loading image, falling back to default.");
              },
            ),
            title: Text(
              "$pickupAddress --- $destinationAddress",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
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
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoText("Good Type", goodType),
                          _infoText("Estimated Time", time),
                          _infoText("Load Capacity", capacity),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoText("Distance", "$distance Km"),
                          _infoText("Price", "Rs.$price /ton"),

                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(alignment:Alignment.centerRight,child: _actionButton("Apply", GlobalVariables.secondaryColor1)),
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
