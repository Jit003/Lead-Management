import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/controller/login-controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../models/all_task_model.dart';
import '../services/api_services.dart';

class TaskController extends GetxController {
  final ApiService _apiService = ApiService();
  final AuthController authController = Get.find<AuthController>();
  final RxDouble progress = 0.0.obs;
  final priority = ''.obs;
  final assignedDate = ''.obs;
  final dueDate = ''.obs;
  final descriptionController = TextEditingController();
  final status = ''.obs;
  final attachments = <String>[].obs;


  // Observable variables
  final RxList<Task> tasks = <Task>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingForUpdate = false.obs;
  final RxString error = ''.obs;
  final RxString selectedFilter = 'all'.obs;

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
  }

  // Fetch all tasks
  Future<void> fetchTasks() async {
    try {
      isLoading.value = true;
      error.value = '';

      final fetchedTasks =
          await _apiService.getTasks(authController.token.value);
      tasks.value = fetchedTasks;
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

  // Update task status

  Future<void> updateTask(String taskId) async {

    final Map<String, dynamic> body ={
      "progress": progress.value,
      "priority": "normal",
      "assigned_date": "2025-05-31 11:00:00",
      "due_date": "2025-06-06 17:00:00",
      "attachments": "[\"updated-ui.pdf\"]",
      "description": descriptionController.text.trim(),
      "status": status.value
    };

    final success = await ApiService.updateTask(taskId, body, authController.token.value);

    if (success == true) {
      print('success edit');
      Get.snackbar("Success", "Task updated successfully",backgroundColor: Colors.white);
      fetchTasks(); // Refresh list
    } else {
      print('error');
      Get.snackbar("Error ", "Failed to update task", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }


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
}
