import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/allleads_controller.dart';
import '../widgets/custom_app_bar.dart';

class FutureLeadsScreen extends StatelessWidget {
  final AllLeadsController controller = Get.put(AllLeadsController());

  FutureLeadsScreen({super.key}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAllLeads(
        status: 'future_lead',
        expectedMonth: 'all',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(title: 'Future Leads'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.filteredLeads.isEmpty) {
          return const Center(
            child: Text(
              "No future leads found",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.filteredLeads.length,
          itemBuilder: (context, index) {
            final lead = controller.filteredLeads[index];
            return GestureDetector(
              onTap: () => controller.navigateToLeadDetails(lead),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: lead.employee?.profilePhoto != null &&
                            lead.employee!.profilePhoto!.isNotEmpty
                            ? NetworkImage(lead.employee!.profilePhoto!)
                            : null,
                        backgroundColor: Colors.blueAccent.withOpacity(0.1),
                        child: Text(
                          (lead.name?.isNotEmpty ?? false)
                              ? lead.name![0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        )
                        ,
                      ),

                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lead.name ?? 'No Name',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.phone, size: 16, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text(lead.phone ?? "No Phone"),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.currency_rupee, size: 16, color: Colors.green),
                                const SizedBox(width: 6),
                                Text(
                                  controller.formatCurrency(lead.leadAmount),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Future Lead",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
