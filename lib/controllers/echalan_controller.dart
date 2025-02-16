import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<String> generateAndDownloadPDF() async {
  final url = Uri.parse('http://localhost:3000/generate-pdf'); // Change to your API URL
  final Map<String, dynamic> requestBody = {
    "deliveryChallanFor": "Order 123",
    "shipperName": "ABC Logistics",
    "shipperAddress": "Mumbai, India",
    "s_pin": "400001",
    "gstin": "GSTIN123456",
    "placeOfSupply": "Maharashtra",
    "shipTo": "XYZ Company",
    "truckOwnerName": "John Doe",
    "truckOwneraddress": "Pune, India",
    "t_pin": "411001",
    "goods": "Electronics",
    "quantity": "50",
    "unit": "kg",
    "pricePerUnit": "1000",
    "bankAccountNo": "1234567890",
    "truckRegNo": "MH12AB1234",
    "licenseNo": "DL12345",
    "truckModel": "Tata 407"
  };

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      // Get the directory to save the PDF
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/generated_document.pdf';

      // Save the PDF file
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      return "PDF successfully saved at: $filePath";
    } else {
      return "Failed to generate PDF: ${response.body}";
    }
  } catch (e) {
    return "Error: $e";
  }
}
