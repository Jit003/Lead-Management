import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/allleads_controller.dart';

class AllLeadsFilterBottomSheet extends StatelessWidget {
  final AllLeadsController controller = Get.find<AllLeadsController>();
  final RxString selectedCategory = 'Lead Type'.obs;

  final Map<String, List<String>> filterOptions = {
    'Lead Type': ['all', 'home_loan', 'business_loan', 'personal_loan'],
    'Lead Status': ['all', 'authorized', 'pending', 'approved', 'disbursed', 'rejected'],
    'Month': [
      'All',
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header with drag handle
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Side Panel
                  Container(
                    width: 120,
                    color: Colors.grey[50],
                    child: Obx(() {
                      return ListView(
                        children: filterOptions.keys.map((category) {
                          final isSelected = selectedCategory.value == category;
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.orange[50] : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              title: Text(
                                category,
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  color: isSelected ? Colors.orange[800] : Colors.grey[800],
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () => selectedCategory.value = category,
                            ),
                          );
                        }).toList(),
                      );
                    }),
                  ),

                  // Options Panel with Scroll
                  Expanded(
                    child: Obx(() {
                      final category = selectedCategory.value;
                      final options = filterOptions[category]!;
                      return Container(
                        color: Colors.white,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                              SizedBox(height: 12),
                              ...options.map((option) {
                                final isSelected = _isSelected(category, option);
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: isSelected,
                                        onChanged: (_) => _onOptionSelected(category, option),
                                        activeColor: Colors.orange[700],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          option,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Fixed Buttons
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        controller.selectedLeadType.value = 'all';
                        controller.selectedStatus.value = 'all';
                        controller.selectedMonth.value = null;
                        controller.searchQuery.value = '';
                        controller.fetchAllLeads();
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey[400]!),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Clear Filters',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[700],
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        controller.fetchAllLeads(
                          leadType: controller.selectedLeadType.value == 'All'
                              ? null
                              : controller.selectedLeadType.value,
                          status: controller.selectedStatus.value == 'all'
                              ? null
                              : controller.selectedStatus.value,
                          expectedMonth: controller.selectedMonth.value == 'All'
                              ? null
                              : controller.selectedMonth.value,
                        );
                        Get.back();
                      },
                      child: Text(
                        'Apply',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isSelected(String category, String option) {
    switch (category) {
      case 'Lead Type':
        return controller.selectedLeadType.value == option;
      case 'Lead Status':
        return controller.selectedStatus.value == option;
      case 'Month':
        return controller.selectedMonth.value == option || (controller.selectedMonth.value == null && option == 'All');
      default:
        return false;
    }
  }

  void _onOptionSelected(String category, String option) {
    switch (category) {
      case 'Lead Type':
        controller.selectedLeadType.value = option;
        break;
      case 'Lead Status':
        controller.selectedStatus.value = option;
        break;
      case 'Month':
        controller.selectedMonth.value = option == 'All' ? null : option;
        break;
    }
  }
}