import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/views/attendance_history.dart';
import 'package:kredipal/widgets/custom_app_bar.dart';
import '../controller/attendance_controller.dart';
import 'camera_capture_screen.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final AttendanceController controller = Get.put(AttendanceController());
  Timer? _reminderTimer;

  @override
  void initState() {
    super.initState();
    print('AttendanceScreen: initState called');

    // Run after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAttendanceStatus().then((_) {
        print(
            'AttendanceScreen: fetchAttendanceStatus completed, status=${controller.attendanceStatus.value?.status}');
        _startReminderTimer();
      });

      // Watch for attendance status changes
      ever(controller.attendanceStatus, (_) {
        final status = controller.attendanceStatus.value?.status;
        print('attendanceStatus changed: $status');
        if (status == 'checked_in') {
          _cancelReminderTimer();
        }
      });
    });
  }


  void _startReminderTimer() {
    if (_reminderTimer != null) {
      print('AttendanceScreen: Timer already running, skipping start');
      return;
    }

    _reminderTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final data = controller.attendanceStatus.value;

      print('Reminder timer tick: status=${data?.status}, isLoading=${controller.isLoading.value}');
      Get.closeAllSnackbars(); // Prevent snackbar overlap

      // ✅ Only show snackbar if user is already checked in
      if (data != null && data.status == 'checked_in') {
        print('Showing snackbar: status=checked_in');
        Get.snackbar(
          'Attendance Reminder',
          'You are checked in.\nCheck-in Time: ${data.checkInTime ?? 'Not available'}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF3498DB).withOpacity(0.9),
          colorText: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          borderRadius: 16,
          duration: const Duration(seconds: 4),
          isDismissible: true,
          icon: const Icon(
            Icons.info,
            color: Colors.white,
            size: 24,
          ),
          shouldIconPulse: true,
          snackStyle: SnackStyle.FLOATING,
          titleText: const Text(
            'Attendance Reminder',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          messageText: Text(
            'You are still checked in.\nCheck-in Time: ${data.checkInTime ?? 'Not available'}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          boxShadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          animationDuration: const Duration(milliseconds: 500),
        );
      } else {
        // ✅ If not checked in, cancel the reminder
        print('User is not checked in, canceling reminder timer.');
        _cancelReminderTimer();
      }
    });
  }

  void _cancelReminderTimer() {
    if (_reminderTimer != null) {
      _reminderTimer?.cancel();
      _reminderTimer = null;
      print('Reminder timer cancelled');
    }
  }

  @override
  void dispose() {
    _cancelReminderTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: CustomAppBar(
        title: 'Attendance',
        showBackButton: false,
        actions: [
          IconButton(onPressed: (){
            Get.to(()=>const AttendanceHistoryScreen());
          }, icon: const Icon(Icons.history)),
          

        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchAttendanceStatus(); // ⬅️ Your refresh logic
          },
          child: Obx(() {
            print('Obx rebuild: isLoading=${controller.isLoading.value}');
            if (controller.isLoading.value) {
              return _buildProcessingView();
            }
            return SingleChildScrollView( // Required for RefreshIndicator to work
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height, // Ensure full height
                child: _buildMainView(controller, context),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildMainView(AttendanceController controller, BuildContext context) {
    final data = controller.attendanceStatus.value;
    print('buildMainView: status=${data?.status}');
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTodayStatusCard(controller),
          const SizedBox(height: 24),
          Obx(() => _buildActionButton(controller, context)),
          const SizedBox(height: 24),
          _buildSessionsInfo(controller),
          if (data != null && data.status == 'error')
            _buildRetryButton(controller),
        ],
      ),
    );
  }

  Widget _buildTodayStatusCard(AttendanceController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2C3E50), Color(0xFF3498DB)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today\'s Attendance',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Obx(() {
            final data = controller.attendanceStatus.value;
            print('TodayStatusCard: status=${data?.status}');
            if (data != null && data.status == 'error') {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.message ?? 'Error occurred',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Action: ${data.buttonAction ?? 'Unknown'}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              );
            }
            return Row(
              children: [
                Expanded(
                  child: _buildTimeCard(
                    'Check-in',
                    'Time: ${controller.formatTime(data?.checkInTime)}',
                    Icons.login,
                    Colors.green.shade300,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTimeCard(
                    'Check-out',
                    'Time: ${controller.formatTime(data?.checkOutTime)}',
                    Icons.logout,
                    Colors.red.shade300,
                  ),
                ),

              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTimeCard(
      String label, String time, IconData icon, Color color,) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            time,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      AttendanceController controller, BuildContext context) {
    final data = controller.attendanceStatus.value;
    final buttonLabel = data?.buttonAction?.toUpperCase() ?? 'LOADING';
    final isCheckIn = data?.buttonAction == 'checkin';
    final isCheckOut = data?.buttonAction == 'checkout';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCheckIn
              ? [Colors.green.shade400, Colors.green.shade700]
              : [Colors.red.shade400, Colors.red.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: controller.isLoading.value
            ? null
            : () async {
          controller.isButtonLoading.value = true; // Start showing spinner
          final coordinates = await controller.getCurrentCoordinates();
          if (coordinates == null) {
            Get.snackbar(
              'Error',
              'Could not fetch coordinates',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.redAccent.withOpacity(0.9),
              colorText: Colors.white,
              margin: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 20),
              borderRadius: 16,
              boxShadows: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              animationDuration: const Duration(milliseconds: 500),
            );
            return;
          }
          await Get.to(() => CameraCaptureScreen());

          final imageFile = controller.getCapturedImageFile();

          if (imageFile == null) {
            Get.snackbar(
              'Error',
              'No image captured',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.redAccent.withOpacity(0.9),
              colorText: Colors.white,
              margin: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 20),
              borderRadius: 16,
              boxShadows: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              animationDuration: const Duration(milliseconds: 500),
            );
            return;
          }

          if (isCheckIn) {
            controller.performCheckIn(
              coordinates: coordinates,
              location: 'Nexpro Solution Office',
              notes: 'Morning check-in',
              image: imageFile,
            );
          } else if (isCheckOut) {
            controller.performCheckOut(
              id: controller.checkInId.value,
              coordinates: coordinates,
              location: 'Main Office',
              notes: 'Evening check-out',
              image: imageFile,
            );
          }
          controller.isButtonLoading.value = false; // ✅ Moved after await
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (controller.isButtonLoading.value == true)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            else ...[
              Icon(
                isCheckIn ? Icons.login : Icons.logout,
                color: Colors.white,
                size: 26,
              ),
              const SizedBox(width: 10),
              Text(
                buttonLabel,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSessionsInfo(AttendanceController controller) {
    return Obx(() => GestureDetector(
      onTap: () {
        controller.isSessionExpanded.toggle(); // toggle the expansion
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
            Row(
              children: [
                const Icon(Icons.punch_clock_rounded,
                    color: Color(0xFF3498DB), size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Sessions ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Icon(
                  controller.isSessionExpanded.value
                      ? Icons.expand_less
                      : Icons.expand_more,
                  color: Colors.black54,
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (controller.isSessionExpanded.value)
              const Text(
                'Session details shown here...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
          ],
        ),
      ),
    ));
  }

  Widget _buildRetryButton(AttendanceController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ElevatedButton(
        onPressed: () {
          controller.fetchAttendanceStatus();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3498DB),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Retry Location Fetch',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildProcessingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3498DB)),
          ),
          SizedBox(height: 20),
          Text(
            'Processing your attendance...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}