import 'dart:convert';

import 'package:flutter/material.dart';

class Task {
  final int id;
  final int teamLeadId;
  final int employeeId;
  final String title;
  final String description;
  final String status;
  final String createdAt;
  final String updatedAt;
  final int progress;
  final String priority;
  final List<ActivityItem> activityTimeline;
  final String assignedDate;
  final String? dueDate;
  final List<String>? attachments;
  final Employee employee;
  final TeamLead teamLead;

  Task({
    required this.id,
    required this.teamLeadId,
    required this.employeeId,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.progress,
    required this.priority,
    required this.activityTimeline,
    required this.assignedDate,
    this.dueDate,
    this.attachments,
    required this.employee,
    required this.teamLead,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    // Parse activity timeline
    List<ActivityItem> timeline = [];
    if (json['activity_timeline'] != null) {
      final List<dynamic> timelineJson = jsonDecode(json['activity_timeline']);
      timeline = timelineJson.map((item) => ActivityItem.fromJson(item)).toList();
    }

    // Parse attachments
    List<String>? attachments;
    if (json['attachments'] != null && json['attachments'] != "null") {
      final List<dynamic> attachmentsJson = jsonDecode(json['attachments']);
      attachments = attachmentsJson.map((item) => item.toString()).toList();
    }

    return Task(
      id: json['id'],
      teamLeadId: json['team_lead_id'],
      employeeId: json['employee_id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      progress: json['progress'],
      priority: json['priority'],
      activityTimeline: timeline,
      assignedDate: json['assigned_date'],
      dueDate: json['due_date'],
      attachments: attachments,
      employee: Employee.fromJson(json['employee']),
      teamLead: TeamLead.fromJson(json['team_lead']),
    );
  }

  // Helper method to get status color
  Color getStatusColor() {
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

  // Helper method to get priority color
  Color getPriorityColor() {
    switch (priority) {
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

  // Helper method to get remaining days
  int? getRemainingDays() {
    if (dueDate == null) return null;

    final due = DateTime.parse(dueDate!);
    final now = DateTime.now();
    return due.difference(now).inDays;
  }
}

class ActivityItem {
  final String timestamp;
  final String action;
  final int by;
  final String note;
  final List<String>? fieldsChanged;

  ActivityItem({
    required this.timestamp,
    required this.action,
    required this.by,
    required this.note,
    this.fieldsChanged,
  });

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    List<String>? fields;
    if (json['fields_changed'] != null) {
      fields = List<String>.from(json['fields_changed']);
    }

    return ActivityItem(
      timestamp: json['timestamp'],
      action: json['action'],
      by: json['by'],
      note: json['note'],
      fieldsChanged: fields,
    );
  }
}

class Employee {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String designation;
  final String? profilePhoto;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.designation,
    this.profilePhoto,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'] ?? '',
      designation: json['designation'] ?? '',
      profilePhoto: json['profile_photo'],
    );
  }
}

class TeamLead {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String designation;
  final String? profilePhoto;

  TeamLead({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.designation,
    this.profilePhoto,
  });

  factory TeamLead.fromJson(Map<String, dynamic> json) {
    return TeamLead(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'] ?? '',
      designation: json['designation'] ?? '',
      profilePhoto: json['profile_photo'],
    );
  }
}

// Don't forget to import this at the top
