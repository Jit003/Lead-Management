import 'package:get/get.dart';

class MoreTextController extends GetxController {
  var isMore = false.obs;
  var isMoreAddLead = false.obs;

  moreText(){
    isMore.value = !isMore.value;
  }

  moreTextAddLead(){
    isMoreAddLead.value = !isMoreAddLead.value;
  }
}