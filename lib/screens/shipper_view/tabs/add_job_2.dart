import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/job_controller.dart';

class JobDetailsTab extends StatefulWidget {

   final String src;
   final String dest;
   final String distance;
   final String time;

  const JobDetailsTab({super.key, required this.src, required this.dest, required this.distance, required this.time});

  @override
  State<JobDetailsTab> createState() => _JobDetailsTabState();
}

class _JobDetailsTabState extends State<JobDetailsTab> {
  final JobController jobController = Get.put(JobController());
  final TextEditingController priceTagController = TextEditingController();
  final TextEditingController goodsTypeController = TextEditingController();
  final TextEditingController loadCapacityController = TextEditingController();
  final TextEditingController receiverAddressController = TextEditingController();
  final TextEditingController receiverEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Create Job", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.amber.shade700,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Job Details", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 16),
            _buildTextField("Price Tag",priceTagController),
            _buildTextField("Goods Type", goodsTypeController),
            _buildTextField("Load Capacity", loadCapacityController),
            _buildTextField("Receiver's Address", receiverAddressController),
            _buildTextField("Receiver's Mail ID", receiverEmailController),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  try {
                    await jobController.createJob(
                      from: widget.src,
                      to: widget.dest,
                      estimatedDistance: widget.distance,
                      estimatedTime: widget.time,
                      priceTag: priceTagController.text,
                      goodsType: goodsTypeController.text,
                      loadCapacity: loadCapacityController.text,
                      receiverAddress: receiverAddressController.text,
                      receiverMailId: receiverEmailController.text,
                    );

                    // Show success message
                    if (mounted) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Success"),
                          content: Text("Job created successfully!"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                                Navigator.of(context).pop(); // Navigate back
                              },
                              child: Text("OK"),
                            ),
                          ],
                        ),
                      );
                    }
                  } catch (e) {
                    // Show error message
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Failed to create job: $e"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },

                child: Text("Create Job", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }


}
