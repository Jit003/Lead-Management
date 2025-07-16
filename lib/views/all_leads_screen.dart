import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/widgets/custom_app_bar.dart';
import '../controller/allleads_controller.dart';
import '../models/all_leads_model.dart';
import '../widgets/expected_month_bottom_sheet.dart';

class AllLeadsScreen extends StatelessWidget {
  const AllLeadsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AllLeadsController controller = Get.put(AllLeadsController());

    return Scaffold(
      appBar: CustomAppBar(
        title: 'All Leads',
        showBackButton: false,
        actions: [

          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list_outlined),
                onPressed: () {
                  Get.bottomSheet(
                    AllLeadsFilterBottomSheet(),
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                  );
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Obx(() {
                  final count = controller.filteredLeads.length;
                  return count > 0
                      ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                      : const SizedBox.shrink();
                }),
              ),
            ],
          ),


        ],
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          // Custom Header with Aggregates
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [

                TextField(
                  onChanged: controller.updateSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Search leads ...',
                    hintStyle: const TextStyle(
                      color: Colors.black
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.black),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.orange),
                    ),
                  ),
                  style: const TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),
                ),

                // Status Filter
              ],
            ),
          ),

          // Leads List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.allLeads.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF2C3E50)),
                  ),
                );
              }

              if (controller.errorMessage.value.isNotEmpty &&
                  controller.allLeads.isEmpty) {
                return _buildErrorWidget(controller);
              }

              final filteredLeads = controller.filteredLeads;

              if (controller.allLeads.isEmpty) {
                return _buildEmptyWidget();
              }

              return RefreshIndicator(
                onRefresh: () async {
                  controller.selectedMonth.value = 'All';
                  controller.selectedLeadType.value = 'All';
                  controller.selectedStatus.value = 'all';
                  await controller.fetchAllLeads();
                },
                color: const Color(0xFF2C3E50),
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                      bottom: kBottomNavigationBarHeight + 30,
                      top: 10,
                      left: 10,
                      right: 10),
                  itemCount: filteredLeads.length,
                  itemBuilder: (context, index) {
                    final lead = filteredLeads[index];
                    return _buildLeadCard(lead, controller);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }



  Widget _buildLeadCard(Leads lead, AllLeadsController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => controller.navigateToLeadDetails(lead),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lead.name ?? 'Unknown ',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lead.companyName ?? 'N/A',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: controller
                            .getStatusColor(lead.status)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: controller
                              .getStatusColor(lead.status)
                              .withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        (lead.status ?? 'Unknown').toUpperCase(),
                        style: TextStyle(
                          color: controller.getStatusColor(lead.status),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Details Row
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.phone,
                        label: 'Phone',
                        value: lead.phone ?? 'N/A',
                      ),
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.currency_rupee,
                        label: 'Amount',
                        value: controller.formatCurrency(lead.leadAmount),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'By: ${lead.employee?.name ?? 'Unknown'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '${(lead.leadType ?? '').replaceAll('_', ' ').toUpperCase()}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(AllLeadsController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load leads',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: controller.fetchAllLeads,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C3E50),
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No leads found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filter criteria',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
