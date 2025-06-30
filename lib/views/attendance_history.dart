import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/widgets/custom_app_bar.dart';
import '../controller/attendance_history_controller.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  const AttendanceHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AttendanceHistoryController controller =
    Get.put(AttendanceHistoryController());
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const CustomAppBar(title: 'Attendance History'),
      body: Obx(() {
        if (controller.isLoading.value && controller.records.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty &&
            controller.records.isEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        return RefreshIndicator(
          onRefresh: controller.fetchAttendanceHistory,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildSummary(controller, screenWidth),
                SizedBox(height: screenHeight * 0.02),
                _buildFilterTabs(controller, screenWidth),
                SizedBox(height: screenHeight * 0.02),
                _buildRecordsList(controller, screenWidth, screenHeight),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSummary(AttendanceHistoryController controller, double screenWidth) {
    final summary = controller.summary.value;
    if (summary == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatCard("Total", summary.totalDays ?? 0, Colors.blue, screenWidth),
          SizedBox(width: screenWidth * 0.03),
          _buildStatCard("Present", summary.present ?? 0, Colors.green, screenWidth),
          SizedBox(width: screenWidth * 0.03),
          _buildStatCard("Absent", summary.absent ?? 0, Colors.red, screenWidth),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, int count, Color color, double screenWidth) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: screenWidth * 0.035, color: color),
            ),
            SizedBox(height: screenWidth * 0.01),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs(AttendanceHistoryController controller, double screenWidth) {
    final filters = {
      'All': 'all',
      'Completed': 'completed',
      'Incomplete': 'incomplete'
    };

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: filters.entries.map((entry) {
          final isSelected = controller.selectedFilter.value == entry.value;
          return Flexible(
            child: GestureDetector(
              onTap: () => controller.updateFilter(entry.value),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                padding: EdgeInsets.symmetric(vertical: screenWidth * 0.025),
                constraints: BoxConstraints(minWidth: screenWidth * 0.25), // Ensure minimum width
                decoration: BoxDecoration(
                  color: isSelected ? Colors.orange : Colors.white,
                  borderRadius: BorderRadius.circular(screenWidth * 0.025),
                  border: Border.all(color: Colors.orange),
                ),
                child: Center(
                  child: Text(
                    entry.key,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.orange,
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecordsList(
      AttendanceHistoryController controller, double screenWidth, double screenHeight) {
    final records = controller.filteredRecords;

    if (records.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(screenWidth * 0.08),
        child: const Text("No attendance records found."),
      );
    }

    return ListView.builder(
      itemCount: records.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final record = records[index];
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenWidth * 0.02,
          ),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
            ),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.formatDateWithDay(record.date),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.01),
                  Text(
                    record.employeeName,
                    style: TextStyle(fontSize: screenWidth * 0.035),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTimeInfo(
                          icon: Icons.login_rounded,
                          label: "Check-in",
                          time: controller.formatTime(record.checkIn),
                          imageUrl: record.checkinImage,
                          screenWidth: screenWidth,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Expanded(
                        child: _buildTimeInfo(
                          icon: Icons.logout_rounded,
                          label: "Check-out",
                          time: controller.formatTime(record.checkOut),
                          imageUrl: record.checkoutImage,
                          screenWidth: screenWidth,
                        ),
                      ),
                    ],
                  ),
                  if (record.checkIn != null && record.checkOut != null)
                    Padding(
                      padding: EdgeInsets.only(top: screenWidth * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: screenWidth * 0.05,
                            color: Colors.blue,
                          ),
                          SizedBox(width: screenWidth * 0.015),
                          Text(
                            "Total: ${controller.calculateWorkTime(record.checkIn, record.checkOut)}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimeInfo({
    required IconData icon,
    required String label,
    required String time,
    String? imageUrl,
    required double screenWidth,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.grey, size: screenWidth * 0.06),
        SizedBox(height: screenWidth * 0.01),
        Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.03,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: screenWidth * 0.005),
        Text(
          time,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.035,
          ),
        ),
        if (imageUrl != null) ...[
          SizedBox(height: screenWidth * 0.015),
          ClipRRect(
            borderRadius: BorderRadius.circular(screenWidth * 0.015),
            child: Image.network(
              imageUrl,
              height: screenWidth * 0.15,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.broken_image, size: screenWidth * 0.1),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  height: screenWidth * 0.15,
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: screenWidth * 0.005),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}