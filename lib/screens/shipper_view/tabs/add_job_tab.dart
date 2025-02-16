import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'add_job_2.dart';

class CreateRouteTab extends StatelessWidget {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

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
            Text("Create Route", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 16),
            _buildTextField("From", fromController),
            _buildTextField("To", toController),
            _buildTextField("Estimated Distance", distanceController),
            _buildTextField("Estimated Time", timeController),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                backgroundColor: Colors.orange,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JobDetailsTab(src: fromController.text, dest: toController.text, distance: distanceController.text, time: timeController.text,)),
                  );
                },
                child: Icon(Icons.arrow_forward, color: Colors.white),
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
        ),
      ),
    );
  }
}



