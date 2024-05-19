import 'package:get/get.dart';

class SimpleUIController extends GetxController {
  var isObscure = true.obs;
  var isRememberMe = false.obs;

  void isObscureActive() {
  isObscure.value = !isObscure.value;
  }
  }
