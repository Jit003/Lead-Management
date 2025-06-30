import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kredipal/widgets/task_widget/task_update_screen.dart';
import '../../constant/app_color.dart';
import '../../models/all_task_model.dart';


Widget buildTaskCard(Task task) {
  final dueDate = task.dueDate != null
      ? DateFormat('MMM dd, yyyy').format(DateTime.parse(task.dueDate!))
      : 'No due date';

  final remainingDays = task.getRemainingDays();
  final isOverdue = remainingDays != null && remainingDays < 0;

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with priority and status
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                task.getPriorityColor().withOpacity(0.8),
                task.getPriorityColor().withOpacity(0.6),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    task.priority == 'high'
                        ? Icons.priority_high
                        : task.priority == 'medium'
                        ? Icons.flag
                        : Icons.low_priority,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${task.priority.toUpperCase()} PRIORITY',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: task.getStatusColor(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      task.getFormattedStatus(),
                      style: const TextStyle(
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

        // Task content
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                task.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),

              // Progress bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        '${task.progress}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: task.getStatusColor(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: task.progress / 100,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(task.getStatusColor()),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Due date and assigned by
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: isOverdue ? Colors.red : Colors.grey.shade700,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        dueDate,
                        style: TextStyle(
                          fontSize: 12,
                          color: isOverdue ? Colors.red : Colors.grey.shade700,
                          fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (isOverdue) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'OVERDUE',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: task.teamLead.profilePhoto != null
                            ? NetworkImage('https://example.com${task.teamLead.profilePhoto}')
                            : null,
                        child: task.teamLead.profilePhoto == null
                            ? Text(
                          task.teamLead.name.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        )
                            : null,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'By ${task.teamLead.name}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        // Attachments
        if (task.attachments != null && task.attachments!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  'Attachments (${task.attachments!.length})',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: task.attachments!.map((attachment) {
                      final extension = attachment.split('.').last.toLowerCase();
                      IconData icon;
                      Color color;

                      if (['pdf'].contains(extension)) {
                        icon = Icons.picture_as_pdf;
                        color = Colors.red;
                      } else if (['doc', 'docx'].contains(extension)) {
                        icon = Icons.description;
                        color = Colors.blue;
                      } else if (['xls', 'xlsx'].contains(extension)) {
                        icon = Icons.table_chart;
                        color = Colors.green;
                      } else {
                        icon = Icons.insert_drive_file;
                        color = Colors.orange;
                      }

                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: color.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(icon, size: 16, color: color),
                            const SizedBox(width: 6),
                            Text(
                              attachment,
                              style: TextStyle(
                                fontSize: 12,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

        // Action buttons
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  // View task details
                  Get.snackbar(
                    'Coming Soon',
                    'Task details view will be available soon',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                icon: const Icon(Icons.visibility, size: 18),
                label: const Text('View Details'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColor.appBarColor,
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: (){
                  Get.to(()=>EditTaskScreen( taskId: task.id.toString(),));
                },
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Update'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
