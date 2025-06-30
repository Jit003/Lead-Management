import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kredipal/views/edit_lead_screen.dart';
import 'package:kredipal/widgets/custom_app_bar.dart';
import 'package:kredipal/widgets/custom_button.dart';
import 'package:kredipal/widgets/follow_up_bottom_sheet.dart';
import 'package:kredipal/widgets/voice_new_screen.dart';
import '../models/all_leads_model.dart';
import '../services/url_helper.dart';
import '../widgets/add_lead_widget/voice_record_section.dart';
import '../widgets/modern_audio_player.dart';
import 'lead_details_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class LeadDetailsScreen extends StatelessWidget {
  const LeadDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LeadDetailsController controller = Get.put(LeadDetailsController());

    Future<void> makePhoneCall(String phoneNumber) async {
      var _url = Uri.parse('tel:$phoneNumber');
      if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
        Get.snackbar('Error', 'Could not launch phone call',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }

    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
            appBar: CustomAppBar(title: ''),
            body: Center(
              child: CircularProgressIndicator(),
            ));
      }
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: CustomAppBar(
          title: controller.leadDetails.value?.name ?? 'Lead Details',
          actions: [
            Obx(() {
              final lead = controller.leadDetails.value;
              if (lead == null || !lead.isPersonalLead!) {
                return const SizedBox.shrink();
              }
              return TextButton(
                onPressed: () {
                  Get.to(() => EditLeadsPage(leadId: lead!.id!));
                },
                child: Center(
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2C3E50)),
              ),
            );
          }

          if (controller.leadDetails.value == null) {
            return const Center(
              child: Text(
                'No lead details available',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          }

          final lead = controller.leadDetails.value!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Lead Header Card
                _buildHeaderCard(lead, controller),

                const SizedBox(height: 16),

                // Personal Information
                _buildSectionCard(
                  title: 'Personal Information',
                  icon: Icons.person,
                  children: [
                    _buildDetailRow('Full Name', lead.name ?? 'N/A'),
                    _buildDetailRow('Email', lead.email ?? 'N/A'),
                    _buildDetailRow('Phone', lead.phone ?? 'N/A'),
                    _buildDetailRow(
                        'Date of Birth', controller.formatDate(lead.dob)),
                    _buildDetailRow(
                      'Location',
                      [
                        lead.state,
                        lead.district,
                        lead.city
                      ].where((e) => e != null && e.isNotEmpty).join(', ').isNotEmpty
                          ? [
                        lead.state,
                        lead.district,
                        lead.city
                      ].where((e) => e != null && e.isNotEmpty).join(', ')
                          : 'N/A',
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Financial Information
                _buildSectionCard(
                  title: 'Financial Information',
                  icon: Icons.account_balance_wallet,
                  children: [
                    _buildDetailRow('Lead Amount',
                        controller.formatCurrency(lead.leadAmount)),
                    _buildDetailRow('Current Salary',
                        controller.formatCurrency(lead.salary)),
                    _buildDetailRow('Success Percentage',
                        '${lead.successPercentage ?? 0}%'),
                    _buildDetailRow(
                        'Expected Month', lead.expectedMonth ?? 'N/A'),
                    _buildDetailRow(
                        'Lead Type',
                        (lead.leadType ?? 'N/A')
                            .replaceAll('_', ' ')
                            .toUpperCase()),
                  ],
                ),

                const SizedBox(height: 16),

                // Company Information
                _buildSectionCard(
                  title: 'Company Information',
                  icon: Icons.business,
                  children: [
                    _buildDetailRow('Company Name', lead.companyName ?? 'N/A'),
                  ],
                ),

                const SizedBox(height: 16),

                // Team Information
                _buildSectionCard(
                  title: 'Team Information',
                  icon: Icons.group,
                  children: [
                    _buildDetailRow('Employee', lead.employee?.name ?? 'N/A'),
                    _buildDetailRow(
                        'Employee Email', lead.employee?.email ?? 'N/A'),
                    _buildDetailRow('Team Lead', lead.teamLead?.name ?? 'N/A'),
                    _buildDetailRow(
                        'Team Lead Phone', lead.teamLead?.phone ?? 'N/A'),
                  ],
                ),

                if (lead.remarks != null && lead.remarks!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  // Remarks
                  _buildSectionCard(
                    title: 'Remarks',
                    icon: Icons.note,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Text(
                          lead.remarks!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2C3E50),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 16),

                // Timestamps
                _buildSectionCard(
                  title: 'Timeline',
                  icon: Icons.schedule,
                  children: [
                    _buildDetailRow(
                        'Created At', controller.formatDate(lead.createdAt)),
                    _buildDetailRow(
                        'Updated At', controller.formatDate(lead.updatedAt)),
                  ],
                ),
                const SizedBox(height: 32),

                controller.leadDetails.value?.voiceRecording?.isNotEmpty == true
                    ? _buildSectionCard(
                        title: 'Audio',
                        icon: Icons.audiotrack,
                        children: [
                          ModernAudioPlayer(
                            label: 'Listen',
                            audioPath:
                                controller.leadDetails.value!.voiceRecording!,
                          ),
                        ],
                      )
                    : const SizedBox(),

                const SizedBox(height: 32),

                VoiceNoteScreen(),

                const SizedBox(height: 32),

                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Call',
                        onPressed: () {
                          makePhoneCall('+91${lead.phone}');
                          print(
                              "Audio  path from backend: ${controller.leadDetails.value!.voiceRecording}");
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: CustomButton(
                        text: 'Follow Up',
                        onPressed: () {
                          Get.bottomSheet(
                            FollowUpBottomSheet(leadId: lead.id.toString()),
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ForwardDropdown(isForwarded: !lead.isPersonalLead!),
              ],
            ),
          );
        }),
      );
    });
  }

  Widget _buildHeaderCard(Leads lead, LeadDetailsController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            controller.getStatusColor(lead.status),
            controller.getStatusColor(lead.status).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: controller.getStatusColor(lead.status).withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lead.name ?? 'Unknown Lead',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lead.companyName ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Text(
                  (lead.status ?? 'Unknown').toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildHeaderStat(
                  'Lead Amount',
                  controller.formatCurrency(lead.leadAmount),
                  Icons.currency_rupee,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.3),
              ),
              Expanded(
                child: _buildHeaderStat(
                  'Success Rate',
                  '${lead.successPercentage ?? 0}%',
                  Icons.trending_up,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2C3E50).withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: const Color(0xFF2C3E50),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(
            ': ',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF2C3E50),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF2C3E50),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ForwardDropdown extends StatefulWidget {
  final bool isForwarded;

  const ForwardDropdown({super.key, required this.isForwarded});

  @override
  State<ForwardDropdown> createState() => _ForwardDropdownState();
}

class _ForwardDropdownState extends State<ForwardDropdown> {
  String? _selectedOption;

  final List<String> options = [
    'Forward to TL',
    'Forward to Operation',
    'Forward to Admin',
  ];

  void _handleForward(String? value) {
    if (value == null) return;

    setState(() {
      _selectedOption = value;
    });

    Get.snackbar(
      'Forwarded',
      'Lead has been $value',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedOption,
      hint: const Text('Forward Lead'),
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: widget.isForwarded ? null : _handleForward,
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.isForwarded ? Colors.grey.shade300 : Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.orange),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
      icon: const Icon(Icons.arrow_drop_down),
    );
  }
}
