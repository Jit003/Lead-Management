import 'package:get/get.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class TimeController extends GetxController {
  var currentTime = ''.obs;
  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    currentTime.value = DateFormat('hh:mm:ss a').format(DateTime.now());
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
