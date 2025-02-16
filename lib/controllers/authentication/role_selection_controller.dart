import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoleSelectionController extends GetxController{
  RxString selectedOption = ''.obs;
  void selectOption(String option) {
    selectedOption.value = option;
    print("Selected Role: $option");
    update();
  }
}