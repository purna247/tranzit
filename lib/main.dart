import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:ttranzit_app/screens/authentication/role_selection_screen.dart';
import 'package:ttranzit_app/screens/owner_view/owner_tab_view.dart';
import 'package:ttranzit_app/screens/shipper_view/shipper_tab_view.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!authSnapshot.hasData || authSnapshot.data == null) {
          return RoleSelectionScreen();
        }

        User user = authSnapshot.data!;

        return FutureBuilder<DocumentSnapshot?>(
          future: checkUserRole(user.uid),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (roleSnapshot.hasError || roleSnapshot.data == null || !roleSnapshot.data!.exists) {
              Get.snackbar('Error', 'User role not found');
              signOut();
              return RoleSelectionScreen();
            }

            String role = roleSnapshot.data!.reference.parent.id;

            if (role == 'shippers') {
              return ShipperTabView(givenIndex: 0);
            } else if (role == 'owners') {
              return OwnerTabView(givenIndex: 0);
            }

            return RoleSelectionScreen();
          },
        );
      },
    );
  }

  Future<DocumentSnapshot<Object?>?> checkUserRole(String uid) async {
    DocumentSnapshot<Object?> shipperDoc = await firestore.collection('shippers').doc(uid).get();
    if (shipperDoc.exists) return shipperDoc;

    DocumentSnapshot<Object?> ownerDoc = await firestore.collection('owners').doc(uid).get();
    if (ownerDoc.exists) return ownerDoc;

    return null;
  }

  void signOut() async {
    await auth.signOut();
    Get.offAll(() => RoleSelectionScreen());
  }
}