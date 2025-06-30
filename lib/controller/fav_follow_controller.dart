import 'package:get/get.dart';

class FavFollowController extends GetxController {
  var isFollowing = false.obs;

  void toggleFollow(){
    isFollowing.value = !isFollowing.value;
  }
}