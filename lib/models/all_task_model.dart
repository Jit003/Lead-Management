import 'dart:convert';
import 'package:flutter/material.dart';

class Task {
  final String title;
  final String description;
  final String assignedDate;
  final String dueDate;
  final String priority;
  final List<String>? attachments;
  final int taskId;
  final int userId;
  final String status;
  final String progress;
  final String? completedAt;
  final String createdAt;
  final String updatedAt;
  final String? message;

  Task({
    required this.title,
    required this.description,
    required this.assignedDate,
    required this.dueDate,
    required this.priority,
    this.attachments,
    required this.taskId,
    required this.userId,
    required this.status,
    required this.progress,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
    this.message,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    // Parse attachments
    List<String>? attachments;
    if (json['attachments'] != null && json['attachments'] != "null") {
      try {
        final List<dynamic> attachmentsJson = jsonDecode(json['attachments']);
        attachments = attachmentsJson.map((item) => item.toString()).toList();
      } catch (e) {
        attachments = null;
      }
    }

    return Task(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      assignedDate: json['assigned_date'] ?? '',
      dueDate: json['due_date'] ?? '',
      priority: json['priority'] ?? 'medium',
      attachments: attachments,
      taskId: json['task_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      status: json['status'] ?? 'pending',
      progress: json['progress']?.toString() ?? '0',
      completedAt: json['completed_at'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'assigned_date': assignedDate,
      'due_date': dueDate,
      'priority': priority,
      'attachments': attachments != null ? jsonEncode(attachments) : null,
      'task_id': taskId,
      'user_id': userId,
      'status': status,
      'progress': progress,
      'completed_at': completedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'message': message,
    };
  }

  // Helper method to get status color
  Color getStatusColor() {
    switch (status.toLowerCase()) {
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

  // Helper method to get priority color
  Color getPriorityColor() {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return Colors.red.shade700;
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Helper method to get formatted status text
  String getFormattedStatus() {
    return status.replaceAll('_', ' ').toUpperCase();
  }

  // Helper method to get progress as integer
  int get progressInt {
    return int.tryParse(progress) ?? 0;
  }

  // Helper method to get remaining days
  int? getRemainingDays() {
    if (dueDate.isEmpty) return null;

    try {
      final due = DateTime.parse(dueDate);
      final now = DateTime.now();
      return due.difference(now).inDays;
    } catch (e) {
      return null;
    }
  }

  // Helper method to check if task is overdue
  bool get isOverdue {
    final remainingDays = getRemainingDays();
    return remainingDays != null && remainingDays < 0 && status != 'completed';
  }
}
