import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/widgets/custom_app_bar.dart';
import '../../models/all_leads_model.dart';

class FilteredLeadsScreen extends StatelessWidget {
  const FilteredLeadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Leads> leads = Get.arguments ?? [];

    return Scaffold(
      appBar: CustomAppBar(title: 'Future Leads'),
      body: leads.isEmpty
          ? const Center(child: Text("No future leads found."))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: leads.length,
        itemBuilder: (context, index) {
          final lead = leads[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name & Type
                  Text(
                    '${lead.name ?? 'N/A'} (${lead.leadType ?? '-'})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Phone
                  Text('Phone: ${lead.phone ?? 'N/A'}'),

                  // Expected Month
                  if (lead.expectedMonth != null)
                    Text('Expected Month: ${lead.expectedMonth}'),

                  // Lead Amount
                  if (lead.leadAmount != null)
                    Text('Lead Amount: ₹${double.tryParse(lead.leadAmount!)?.toStringAsFixed(2) ?? '0.00'}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
