import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kredipal/constant/app_color.dart';
import 'package:kredipal/widgets/custom_button.dart';
import '../controller/leave_controller.dart';

class ApplyLeavePage extends StatelessWidget {
  final LeaveController controller = Get.put(LeaveController());
  final _formKey = GlobalKey<FormState>();

  ApplyLeavePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.appBarColor,
                      AppColor.appBarColor.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Apply for Leave',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Form Body
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Leave Type', Icons.category_rounded),
                      const SizedBox(height: 12),
                      Obx(() => DropdownButtonFormField<String>(
                        value: controller.leaveType.value.isEmpty
                            ? null
                            : controller.leaveType.value,
                        items: controller.options.map((type) {
                          return DropdownMenuItem(
                              value: type, child: Text(type));
                        }).toList(),
                        onChanged: (value) =>
                        controller.leaveType.value = value ?? '',
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Select Leave Type',
                          prefixIcon: const Icon(Icons.work_outline,
                              color: Colors.blue),
                        ),
                        validator: (value) => value == null
                            ? 'Please select leave type'
                            : null,
                      )),
                      const SizedBox(height: 24),
                      _buildSectionTitle(
                          'Duration', Icons.calendar_month_rounded),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() => _buildDatePickerCard(
                              label: 'Start Date',
                              selectedDate: controller.startDate.value,
                              onTap: () =>
                                  controller.pickDate(context, true),
                            )),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Obx(() => _buildDatePickerCard(
                              label: 'End Date',
                              selectedDate: controller.endDate.value,
                              onTap: () =>
                                  controller.pickDate(context, false),
                            )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Reason', Icons.edit_note),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: controller.reasonController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Please provide a reason...',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.message_outlined,
                              color: Colors.purple),
                        ),
                        validator: (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Reason is required'
                            : null,
                      ),
                      const SizedBox(height: 32),
                      Obx(() => CustomButton(
                        isLoading: controller.isLoading.value,
                        text: 'Submit Application',
                        onPressed: () => controller.applyForLeave(),
                      ))
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColor.primaryColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerCard({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(Icons.date_range, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedDate == null
                        ? 'Select Date'
                        : DateFormat('MMM dd, yyyy').format(selectedDate),
                    style: TextStyle(
                      fontSize: 13,
                      color:
                      selectedDate == null ? Colors.grey : Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}