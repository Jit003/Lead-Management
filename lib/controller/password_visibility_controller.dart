import 'package:get/get.dart';

class PasswordVisibilityController extends GetxController {
  var isObscure = true.obs;

  void toggleVisibility() {
    isObscure.value = !isObscure.value;
  }
}
