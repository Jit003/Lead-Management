import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/controller/current_time_controller.dart';
import '../constant/app_color.dart';

Widget customHeader(String text, [String? time]) {
  final TimeController timeController = Get.put(TimeController());

  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColor.appBarColor,
          AppColor.appBarColor.withOpacity(0.9),
          AppColor.appBarColor.withOpacity(0.8),
        ],
        stops: const [0.0, 0.7, 1.0],
      ),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      boxShadow: [
        BoxShadow(
          color: AppColor.appBarColor.withOpacity(0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Stack(
      children: [
        // Background pattern
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Decorative circles
        Positioned(
          top: -20,
          right: -20,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),

        Positioned(
          top: 20,
          right: 50,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),

        Positioned(
          bottom: -10,
          left: -10,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
        ),

        // Main content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header text with enhanced styling
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      _getIconForText(text),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 3,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Time section with enhanced design
              if (time != null) ...[
                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Time icon with animation
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.access_time,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),

                      const SizedBox(width: 15),

                      // Time display
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Time',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Obx(() {
                              return Text(
                                timeController.currentTime.value,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                ),
                              );
                            }),
                          ],
                        ),
                      ),

                      // Live indicator
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'LIVE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

// Helper function to get appropriate icon based on header text
IconData _getIconForText(String text) {
  final lowerText = text.toLowerCase();

  if (lowerText.contains('dashboard') || lowerText.contains('home')) {
    return Icons.dashboard;
  } else if (lowerText.contains('lead') || lowerText.contains('customer')) {
    return Icons.leaderboard;
  } else if (lowerText.contains('attendance') || lowerText.contains('check')) {
    return Icons.access_time;
  } else if (lowerText.contains('profile') || lowerText.contains('account')) {
    return Icons.person;
  } else if (lowerText.contains('report') || lowerText.contains('analytics')) {
    return Icons.analytics;
  } else if (lowerText.contains('setting') || lowerText.contains('config')) {
    return Icons.settings;
  } else if (lowerText.contains('notification') || lowerText.contains('alert')) {
    return Icons.notifications;
  } else if (lowerText.contains('task') || lowerText.contains('todo')) {
    return Icons.task;
  } else if (lowerText.contains('calendar') || lowerText.contains('schedule')) {
    return Icons.calendar_today;
  } else if (lowerText.contains('message') || lowerText.contains('chat')) {
    return Icons.message;
  } else {
    return Icons.apps; // Default icon
  }
}
