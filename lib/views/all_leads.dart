import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/widgets/custom_app_bar.dart';
import '../controller/allleads_controller.dart';
import '../models/all_leads_model.dart';

class AllLeadsScreen extends StatelessWidget {
  const AllLeadsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AllLeadsController controller = Get.put(AllLeadsController());

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'All Lead',
        showBackButton: false,
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Obx(() => Row(
                        children: [
                          _buildFilterLeadType('All', 'All', controller),
                          _buildFilterLeadType('Home Loan', 'home_loan', controller),
                          _buildFilterLeadType(
                              'Personal Loan', 'personal_loan', controller),
                          _buildFilterLeadType(
                              'Business Loan', 'business_loan', controller),
                        ],
                      )),
                ),

                const SizedBox(height: 12),

                // Status Filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Obx(() => Row(
                        children: [
                          _buildFilterChip('Personal Leads', 'all', controller),
                          _buildFilterChip(
                              'Authorized Leads', 'authorized', controller),
                          _buildFilterChip(
                              'Pending Leads', 'pending', controller),
                          _buildFilterChip(
                              'Approved Leads', 'approved', controller),
                          _buildFilterChip(
                              'Disbursed Leads', 'disbursed', controller), // Changed from 'completed' to 'disbursed'

                          _buildFilterChip(
                              'Rejected Leads', 'rejected', controller),
                        ],
                      )),
                ),
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
                onRefresh: controller.fetchAllLeads,
                color: const Color(0xFF2C3E50),
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                      bottom: kBottomNavigationBarHeight + 30,
                      top: 10,
                      left: 10,
                      right: 10),
                  itemCount: filteredLeads.length,
                  itemBuilder: (context, index) {
                    final lead =
                        filteredLeads[index];
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

  Widget _buildFilterChip(
      String label, String value, AllLeadsController controller) {
    final isSelected = controller.selectedStatus.value == value;

    // Get count and amount based on the filter value
    int count = 0;
    String amount = '₹0';

    final aggregates = controller.aggregates.value;

    if (aggregates != null) {
      switch (value) {
        case 'all':
          count = aggregates.totalLeads?.count ?? 0;
          amount = controller
              .formatCurrency(aggregates.totalLeads?.totalAmount ?? '0');
          break;
        case 'approved':
          count = aggregates.approvedLeads?.count ?? 0;
          amount = controller
              .formatCurrency(aggregates.approvedLeads?.totalAmount ?? '0');
          break;
        case 'pending':
          count = aggregates.pendingLeads?.count ?? 0;
          amount = controller
              .formatCurrency(aggregates.pendingLeads?.totalAmount ?? '0');
          break;
        case 'disbursed': // Updated to match API
          count = aggregates.disbursedLeads?.count ?? 0;
          amount = controller
              .formatCurrency(aggregates.disbursedLeads?.totalAmount ?? '0');
          break;
        case 'rejected': // Updated to match API
          count = aggregates.rejectedLeads?.count ?? 0;
          amount = controller
              .formatCurrency(aggregates.rejectedLeads?.totalAmount ?? '0');
          break;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Column(
        children: [
          FilterChip(
            label: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label),
                const SizedBox(height: 2),
                Text(
                  '$count  / $amount',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color:
                        isSelected ? const Color(0xFF2C3E50) : Colors.grey[500],
                  ),
                ),
              ],
            ),
            selected: isSelected,
            onSelected: (selected) {
              controller.updateStatusFilter(value);
            },
            selectedColor: Colors.orange.withOpacity(0.7),
            checkmarkColor: const Color(0xFF2C3E50),
            labelStyle: TextStyle(
              color: isSelected ? const Color(0xFF2C3E50) : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildFilterLeadType(
      String label, String value, AllLeadsController controller) {
    final isSelected = controller.selectedLeadType.value == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Column(
        children: [
          FilterChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (selected) {
              controller.updateStatusLeadType(value);
            },
            selectedColor: Colors.orange.withOpacity(0.7),
            labelStyle: TextStyle(
              color: isSelected ? const Color(0xFF2C3E50) : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
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