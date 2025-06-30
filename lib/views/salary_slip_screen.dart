import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kredipal/widgets/custom_app_bar.dart';
import '../controller/salary_slip_controller.dart';
import '../models/salary_slip_model.dart';
import '../widgets/salary_slip_widget/salary_slip_card.dart';

class SalarySlipScreen extends StatelessWidget {
  const SalarySlipScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SalarySlipController controller = Get.put(SalarySlipController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: CustomAppBar(title: 'Salary Slips',actions: [
        IconButton(onPressed: (){
          controller.getSalarySlip();
        }, icon: Icon(Icons.refresh))
      ],),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1565C0)),
            ),
          );
        }

        if (controller.slipList.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () => controller.getSalarySlip(),
          color: const Color(0xFF1565C0),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.slipList.length,
            itemBuilder: (context, index) {
              return ClassicSalarySlipCard(
                slip: controller.slipList[index],
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Salary Slips Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your salary slips will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }


  String _formatMonth(String monthString) {
    if (monthString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(monthString);
      return DateFormat('MMMM yyyy').format(date);
    } catch (e) {
      return monthString;
    }
  }
}
