import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kredipal/constant/app_color.dart';
import 'package:kredipal/widgets/custom_app_bar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  // Sample mock notifications
  final List<Map<String, dynamic>> notifications = const [
    {
      'title': 'New Lead Assigned',
      'message': 'You have a new lead assigned: John Doe.',
      'time': '2025-05-19 08:30:00',
      'icon': Icons.person_add_alt_1,
      'isNew': true,
    },
    {
      'title': 'Meeting Reminder',
      'message': 'Don\'t forget your 2:00 PM meeting with Alice.',
      'time': '2025-05-18 13:00:00',
      'icon': Icons.calendar_today,
      'isNew': false,
    },
    {
      'title': 'Task Completed',
      'message': 'You marked the task "Call client" as completed.',
      'time': '2025-05-17 17:45:00',
      'icon': Icons.check_circle,
      'isNew': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: CustomAppBar(title: 'Notifications'),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          final formattedTime = DateFormat('MMM dd, hh:mm a').format(DateTime.parse(item['time']));

          return Card(
            color: item['isNew'] ? Colors.teal.shade50 : Colors.white,
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              leading: CircleAvatar(
                backgroundColor: Colors.teal.shade100,
                child: Icon(item['icon'], color: Colors.red),
              ),
              title: Text(
                item['title'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(item['message']),
                  const SizedBox(height: 4),
                  Text(
                    formattedTime,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
              trailing: item['isNew']
                  ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'New',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
