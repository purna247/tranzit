import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:ttranzit_app/screens/shipper_view/shipper_tab_view.dart';
import '../../screens/authentication/role_selection_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../screens/authentication/signup_screen.dart';
import '../../screens/owner_view/owner_tab_view.dart';


class AuthController extends GetxController{
  static AuthController instance = Get.find();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Rx<User?> _user = Rx<User?>(null);
  FirebaseAuth auth = FirebaseAuth.instance;


  RxString email = ''.obs;
  RxString pw = ''.obs;

  @override
  void onReady() {
    super.onReady();
    _user.value = auth.currentUser;
    _user.bindStream(auth.userChanges());
    ever(_user, _setInitialScreen); // Listen for changes to the user
  }

  _setInitialScreen(User? user) async {
    if (user == null) {
      Get.offAll(() => RoleSelectionScreen());
    } else {
      // Check if user exists in the "shippers" collection
      DocumentSnapshot shipperDoc = await firestore.collection('shippers').doc(user.uid).get();

      if (shipperDoc.exists) {
        Get.offAll(() => ShipperTabView(givenIndex: 0));
        return; // Exit function after routing
      }

      // Check if user exists in the "owners" collection
      DocumentSnapshot ownerDoc = await firestore.collection('owners').doc(user.uid).get();

      if (ownerDoc.exists) {
        Get.offAll(() => OwnerTabView(givenIndex: 0));
        return; // Exit function after routing
      }

      // If user is not found in either collection
      Get.snackbar('Error', 'User role not found');
      signOut();
    }
  }


  Future<void> signUpShipper(String email, String pw, String name, String phone, String state,String country, String address,String gstNo) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: pw);
      User? user = userCredential.user;

      if (user != null) {
        await firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'phone': phone,
          'state': state,
          'country':country,
          'address': address,
          'gstNo':gstNo,
          'createdAt': FieldValue.serverTimestamp(),
        });
        print("User signed up: ${user.email}");
        Get.offAll(() => ShipperTabView(givenIndex: 0,));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar('Error', 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar('Error', 'The account already exists for that email.');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'An unexpected error occurred.');
    }
  }
  Future<void> signUpOwner(String email, String pw, String name, String phone, String address, String state, String country) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: pw);
      User? user = userCredential.user;

      if (user != null) {
        await firestore.collection('owners').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'phone': phone,
          'address': address,
          'state': state,
          'country': country,
          'role': 'Owner',
          'createdAt': FieldValue.serverTimestamp(),
        });
        Get.offAll(() => const OwnerTabView(givenIndex: 0));
        Get.snackbar('Welcome', 'Successfully registered');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while registering');
    }
  }


  Future signIn(String email, String pw) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: pw);
      print("User signed in: ${userCredential.user?.email}");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('No user found for that email.','');
      } else if (e.code == 'wrong-password') {
        Get.snackbar('wrong password.',
          '',
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'An unknown error occurred.',
      );
    }
  }

  Future signOut() async {
    await auth.signOut();
  }
}
