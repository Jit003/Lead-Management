import 'package:get/get.dart';

class ChartLeadsController extends GetxController {
  var leadsData = <int>[1, 8, 3, 6, 10, 7, 9].obs;

  void updateData(List<int> newData) {
    leadsData.value = newData;
  }
}
