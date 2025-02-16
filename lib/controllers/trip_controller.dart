import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TripController extends GetxController {
  RxList<Map<String, dynamic>> trips = <Map<String, dynamic>>[].obs;
  RxBool isInProgress = true.obs;
  var isExpandedList = <bool>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTrips();
  }

  void fetchTrips() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('trips')
          .where('status', isEqualTo: isInProgress.value ? 'inProgress' : 'completed')
          .get();

      trips.value = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      isExpandedList.assignAll(List.generate(trips.length, (_) => false));
    } catch (e) {
      print("Error fetching trips: $e");
    }
  }

  void toggleExpand(int index) {
    if (index >= 0 && index < isExpandedList.length) {
      isExpandedList[index] = !isExpandedList[index];
    }
  }
}
