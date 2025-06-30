import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kredipal/constant/app_color.dart';
import 'package:kredipal/controller/all_leave_controller.dart';
import 'package:kredipal/widgets/custom_app_bar.dart';

class LeaveHistoryScreen extends StatelessWidget {
  LeaveHistoryScreen({super.key});

  final AllLeavesController allLeavesController =
      Get.put(AllLeavesController());

  Color getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'Pending':
      default:
        return Colors.orange;
    }
  }

  IconData getLeaveIcon(String type) {
    switch (type) {
      case 'sick':
        return Icons.local_hospital;
      case 'casual':
        return Icons.event;
      case 'paid':
        return Icons.card_giftcard;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'Leave History'),
        body: Obx(() {
          if (allLeavesController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (allLeavesController.leavesList.isEmpty) {
            return Text("No leaves found");
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: allLeavesController.leavesList.length,
            itemBuilder: (context, index) {
              final leave = allLeavesController.leavesList[index];
              return Card(
                elevation: 5,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.teal.shade100,
                            child: Icon(getLeaveIcon(leave.leaveType!), color: Colors.teal),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            leave.leaveType ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Chip(
                            label: Text(leave.status!),
                            backgroundColor:
                                getStatusColor(leave.status!).withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: getStatusColor(leave.status!),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.date_range,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            "${DateFormat('dd-mm-yyyy').format(DateTime.parse(leave.startDate!))} to "
                                "${DateFormat('dd-mm-yyyy').format(DateTime.parse(leave.endDate!))}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        leave.reason ?? '',
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }));
  }
}
