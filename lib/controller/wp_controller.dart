import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsappController extends GetxController {
  final TextEditingController shareMessageController = TextEditingController();

  void shareLeadMessage({String? phone}) {
    // Default message if no text entered
    String message = shareMessageController.text.isNotEmpty
        ? shareMessageController.text
        : 'Hi! I wanted to share this with you.';

    // If a phone number is provided, add it to the message
    if (phone != null && phone.isNotEmpty) {
      message = "Send to: $phone\n\n$message";
    }

    print('Sharing message: $message');

    // Open native share sheet
    Share.share(
      message,
      subject: 'Message from Matri Station',
    );
  }



  Future<void> makePhoneCall(String phoneNumber) async {
    var _url = Uri.parse('tel:$phoneNumber');
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Error', 'Could not launch phone call',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}