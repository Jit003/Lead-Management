import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/widgets/custom_app_bar.dart';
import '../controller/credit_card_controller.dart';
import '../models/credit_card_model.dart';

class CreditCardLeadDetailsPage extends StatelessWidget {
  final int leadId;

  const CreditCardLeadDetailsPage({Key? key, required this.leadId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CreditLeadsController controller = Get.find<CreditLeadsController>();
    final Lead? lead = controller.getLeadById(leadId);

    if (lead == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Lead Details'),
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('Lead not found'),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(title: 'Lead Deatils'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCreditCardDesign(lead),
            const SizedBox(height: 24),
            _buildPersonalInfo(lead),
            const SizedBox(height: 24),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCardDesign(Lead lead) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade800,
            Colors.blue.shade600,
            Colors.blue.shade400,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lead.bankName.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const Spacer(),
             Text(
              'Phone:${lead.phone}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w300,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CARD HOLDER',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lead.name.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'STATUS',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lead.status.replaceAll('_', ' ').toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfo(Lead lead) {
    return _buildSection(
      'Personal Information',
      [
        _buildInfoRow('Name', lead.name),
        _buildInfoRow('Email', lead.email),
        _buildInfoRow('Phone', lead.phone),
        _buildInfoRow('Lead Type', lead.leadType.replaceAll('_', ' ').toUpperCase()),
        _buildInfoRow('Bank Name', lead.bankName),
        _buildInfoRow('Status', lead.status.replaceAll('_', ' ').toUpperCase()),
        _buildInfoRow('Personal Lead', lead.isPersonalLead ? 'Yes' : 'No'),
        _buildInfoRow('Created At', _formatDateTime(lead.createdAt)),
        _buildInfoRow('Updated At', _formatDateTime(lead.updatedAt)),
      ],
    );
  }





  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }



  String _formatDateTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}