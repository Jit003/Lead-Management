import 'package:get/get.dart';
import 'package:kredipal/routes/app_routes.dart';
import 'package:kredipal/views/add_leads.dart';
import 'package:kredipal/views/all_leads.dart';
import 'package:kredipal/views/attendance_history.dart';
import 'package:kredipal/views/attendance_screen.dart';
import 'package:kredipal/views/change_password_screen.dart';
import 'package:kredipal/views/dashboard_screen.dart';
import 'package:kredipal/views/edit_profile_screen.dart';
import 'package:kredipal/views/home_screen.dart';
import 'package:kredipal/views/lead_details_screen.dart';
import 'package:kredipal/views/lead_saved_success_screen.dart';
import 'package:kredipal/views/leave_history_screen.dart';
import 'package:kredipal/views/login_screen.dart';
import 'package:kredipal/views/notification_screen.dart';
import 'package:kredipal/views/profile_screen.dart';
import 'package:kredipal/views/salary_slip_screen.dart';
import 'package:kredipal/views/splash_screen.dart';

import '../controller/login-controller.dart';
import '../views/task_screen.dart';

class AppPages {
  static final List<GetPage> appPages = [
    GetPage(name: AppRoutes.splash, page: () => SplashScreen(),
  ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 800),
    ),



    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.allLead,
      page: () => AllLeadsScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.addLead,
      page: () => AddLeadsPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.attendance,
      page: () => AttendanceScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.leadDetails,
      page: () => LeadDetailsScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.leadSavedSuccess,
      page: () => LeadSavedSuccessScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.notification,
      page: () => NotificationScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.salarySlip,
      page: () => SalarySlipScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.leaveHistory,
      page: () => LeaveHistoryScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => EditProfileScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.attendanceHistory,
      page: () => AttendanceHistoryScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.task,
      page: () => TaskScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.password,
      page: () => ChangePasswordScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
    )
  ];
}
