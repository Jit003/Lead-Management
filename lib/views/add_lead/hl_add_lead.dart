import 'package:flutter/material.dart';
import '../../widgets/add_lead_widget/business_info_section.dart';
import '../../widgets/add_lead_widget/contact_info_section.dart';
import '../../widgets/add_lead_widget/lead_details_section.dart';
import '../../widgets/add_lead_widget/personal_info_section.dart';
import '../../widgets/add_lead_widget/section_tile.dart';
import '../../widgets/add_lead_widget/voice_record_section.dart';

Widget buildHomeLoanBody() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildSectionTitle('Personal Information'),
      const SizedBox(height: 16),
      buildPersonalInfoSection(),
      const SizedBox(height: 32),
      buildSectionTitle('Contact Information'),
      const SizedBox(height: 16),
      buildContactInfoSection(),
      const SizedBox(height: 32),
      buildSectionTitle('Business Information'),
      const SizedBox(height: 16),
      buildBusinessInfoSection(),
      const SizedBox(height: 16,),
      // Lead Details
      buildSectionTitle('Lead Details'),
      const SizedBox(height: 16),
      buildLeadDetailsSection(),
      const SizedBox(height: 32),
      VoiceRecorderWidget(),
      const SizedBox(height: 100),
    ],
  );
}