import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/widgets/add_lead_widget/voice_record_section.dart';

import '../../controller/addleads_controller.dart';
import 'modern_date_picker.dart';
import 'modern_text_field.dart';

Widget buildExtraInfoSection(){
  final AddLeadsController addLeadsController = Get.find<AddLeadsController>();


  return Column(
    children: [

      const SizedBox(height: 20),
      buildModernDatePicker(),
      const SizedBox(height: 20),
      buildModernTextField(
        label: 'Email Address',
        controller: addLeadsController.emailController,
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: 20),

    ],
  );


}
