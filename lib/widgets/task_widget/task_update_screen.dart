import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/controller/task_controller.dart';
import 'package:kredipal/constant/app_color.dart';
import 'package:kredipal/widgets/custom_app_bar.dart';

class EditTaskScreen extends StatelessWidget {
  final String taskId;

  EditTaskScreen({required this.taskId});

  final TaskController taskController = Get.put(TaskController());

  final List<String> statusOptions = [
    'pending',
    'in_progress',
    'completed',
  ];

  @override
  Widget build(BuildContext context) {
    final progress =
        double.tryParse(taskController.progress.value.toString()) ?? 0.0;
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Edit Task',
        actions: [
          Icon(Icons.edit_note, color: Colors.white),
        ],
      ),
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColor.appBarColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.task_alt,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Edit Task Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Update task information below',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Form Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress Section with Slider
                    const Text(
                      'Progress',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Task Progress',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Obx(() => Text(
                                '${taskController.progress.value.toInt()}%',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.appBarColor,
                                ),
                              ))

                            ],
                          ),
                          const SizedBox(height: 12),
                          Obx(() => SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AppColor.appBarColor,
                              inactiveTrackColor: Colors.grey.shade300,
                              thumbColor: AppColor.appBarColor,
                              overlayColor: AppColor.appBarColor.withOpacity(0.2),
                              valueIndicatorColor: AppColor.appBarColor,
                              trackHeight: 6,
                            ),
                            child: Slider(
                              value: taskController.progress.value.clamp(0.0, 100.0),
                              min: 0,
                              max: 100,
                              divisions: 100,
                              label: '${taskController.progress.value.toInt()}%',
                              onChanged: (value) {
                                taskController.progress.value = value;
                              },
                            ),
                          ))

                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Description Section
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: taskController.descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Enter task description...',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: AppColor.appBarColor, width: 2),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Status Section
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: taskController.status.value.isEmpty
                            ? null
                            : taskController.status.value,
                        onChanged: (value) {
                          taskController.status.value = value ?? '';
                        },
                        items: statusOptions.map((String status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(status),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  status.capitalizeFirst ?? status,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          hintText: 'Select task status',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Update Button
                    SizedBox(
                      width: double.infinity,
                      height: 50 ,
                      child: ElevatedButton(
                        onPressed: () {
                          taskController.updateTask(taskId);
                          print('update');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.appBarColor,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.update, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Update Task',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for status colors
  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
