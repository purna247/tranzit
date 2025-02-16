import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class JobController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var jobs = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var isExpandedList = <bool>[].obs;
  @override
  void onInit() {
    super.onInit();
    fetchAllJobs();
  }

  Future<void> createJob({
    required String from,
    required String to,
    required String estimatedDistance,
    required String estimatedTime,
    required String priceTag,
    required String goodsType,
    required String loadCapacity,
    required String receiverAddress,
    required String receiverMailId,
  }) async {
    try {
      isLoading(true);
      DocumentReference jobRef = _firestore.collection("jobs").doc();

      Map<String, dynamic> jobData = {
        "from": from,
        "to": to,
        "estimatedDistance": estimatedDistance,
        "estimatedTime": estimatedTime,
        "priceTag": priceTag,
        "goodsType": goodsType,
        "loadCapacity": loadCapacity,
        "receiverAddress": receiverAddress,
        "receiverMailId": receiverMailId,
        "createdAt": FieldValue.serverTimestamp(),
      };

      await jobRef.set(jobData);
      print("Job created successfully!");
      fetchAllJobs(); // Refresh job list
    } catch (e) {
      print("Error creating job: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchAllJobs() async {
    try {
      isLoading(true);
      QuerySnapshot querySnapshot = await _firestore
          .collection("jobs")
          .orderBy("createdAt", descending: true)
          .get();

      jobs.assignAll(querySnapshot.docs.map((doc) {
        return {
          "id": doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList());
    } catch (e) {
      print("Error fetching jobs: $e");
    } finally {
      isLoading(false);
    }
  }



  void startJob(String tripId) async {
    try {
      DocumentSnapshot jobSnapshot =
      await FirebaseFirestore.instance.collection('active_jobs').doc(tripId).get();

      if (!jobSnapshot.exists) {
        Get.snackbar("Error", "Job not found!");
        return;
      }

      Map<String, dynamic> jobData = jobSnapshot.data() as Map<String, dynamic>;

      String newStatus = jobData['status'] == 'inProgress' ? 'pending' : 'completed';

      await FirebaseFirestore.instance.collection('trips').doc(tripId).set({
        ...jobData,
        'status': newStatus,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance.collection('active_jobs').doc(tripId).delete();

      Get.snackbar("Success", "Job applied successfully!");

      //fetchTrips();
    } catch (e) {
      print("Error : $e");
      Get.snackbar("Error", "Failed to apply for job!");
    }
  }

}
