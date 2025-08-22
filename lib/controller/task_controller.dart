import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/all_task_model.dart';
import '../services/api_services.dart';
import 'login-controller.dart';

class TaskController extends GetxController {
  // Observable variables
  final RxList<Task> tasks = <Task>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final RxString selectedFilter = 'all'.obs;
  var isUpdating = false.obs;

  final AuthController authController = Get.find<AuthController>();

  // Text controllers for edit form
  final TextEditingController progressController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  // Observable form values
  final RxString status = ''.obs;
  final RxDouble progress = 0.0.obs;

  // Filter options
  final List<String> filterOptions = [
    'all',
    'pending',
    'in_progress',
    'completed'
  ];

  @override
  void onInit() {
    super.onInit();
    fetchTasks();

    // Listen to progress controller changes
    progressController.addListener(() {
      try {
        final value = double.parse(progressController.text);
        progress.value = value.clamp(0.0, 100.0);
      } catch (e) {
        progress.value = 0.0;
      }
    });
  }

  // Fetch all tasks
  Future<void> fetchTasks() async {
    try {
      isLoading.value = true;
      error.value = '';

      final fetchedTasks =
          await ApiService.getTasks(authController.token.value);
      tasks.value = fetchedTasks;
      print('the task is $fetchedTasks');
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load tasks',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Filter tasks based on status
  List<Task> getFilteredTasks() {
    if (selectedFilter.value == 'all') {
      return tasks;
    } else {
      return tasks
          .where((task) => task.status == selectedFilter.value)
          .toList();
    }
  }

  // Initialize edit form with task data
  void initializeEditForm(Task task) {
    progressController.text = task.progress;
    descriptionController.text = task.description;
    messageController.text = task.message ?? '';
    status.value = task.status;
    progress.value = double.tryParse(task.progress) ?? 0.0;
  }

  // Update task

  Future<void> updateTask(int taskId) async {
    try {
      isUpdating.value = true;

      final parsedProgress = progress.value.toInt();

      final result = await ApiService.updateTask(
        taskId: taskId,
        token: authController.token.value,
        status: status.value,
        progress: parsedProgress,
        message: messageController.text.trim().isNotEmpty
            ? messageController.text.trim()
            : "",
      );

      print("✅ Task update success: $result");

      if (result["success"]) {
        // 1️⃣ Refresh tasks
        await fetchTasks();

        // 2️⃣ Navigate back immediately
        Get.back();

        // 3️⃣ Show snackbar on the previous screen
        Get.snackbar(
          "Success",
          result["body"]["message"],
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        print("❌ Server error: ${result["body"]["message"]}");
        Get.snackbar("Error", result["body"]["message"]);
      }
    } catch (e) {
      print("❌ Error updating task: $e");

      Get.snackbar(
        'Error',
        'Failed to update task: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdating.value = false;
    }
  }
  // Update task with all fields

  // Get tasks by priority
  List<Task> getTasksByPriority(String priority) {
    return tasks.where((task) => task.priority == priority).toList();
  }

  // Get tasks count by status
  int getTasksCountByStatus(String status) {
    return tasks.where((task) => task.status == status).length;
  }

  // Get total tasks count
  int get totalTasksCount => tasks.length;

  // Get completion percentage
  double get completionPercentage {
    if (tasks.isEmpty) return 0.0;
    final completed = getTasksCountByStatus('completed');
    return (completed / totalTasksCount) * 100;
  }

  @override
  void onClose() {
    progressController.dispose();
    descriptionController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
