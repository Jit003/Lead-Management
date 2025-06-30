
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/views/all_leads.dart';
import 'package:kredipal/views/attendance_screen.dart';
import 'package:kredipal/views/profile_screen.dart';

import '../controller/bottom_nav_controller.dart';
import 'bottom_nav_bar.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final BottomNavController controller = Get.put(BottomNavController());

  final List<Widget> _pages = [
     DashboardScreen(),
    const AllLeadsScreen(),
    AttendanceScreen(),
    ProfileScreen(),

  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBody: true,
      body: Obx(() {
        return IndexedStack(
          index: controller.selectedIndex.value,
          children: _pages,
        );
      }),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
