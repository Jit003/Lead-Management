import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/constant/app_color.dart';
import 'package:kredipal/routes/app_routes.dart';
import '../controller/bottom_nav_controller.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavController controller = Get.find();

    final List<Map<String, dynamic>> navItems = [
      {'icon': Icons.home_rounded, 'label': 'Dashboard'},
      {'icon': Icons.list_alt_rounded, 'label': 'All Leads'},
      {'icon': Icons.add_circle, 'label': 'Add'}, // NOT A PAGE
      {'icon': Icons.event_available_rounded, 'label': 'Attendance'},
      {'icon': Icons.person_rounded, 'label': 'Account'},
    ];

    return Container(
      height: 65,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.appBarColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(navItems.length, (index) {
            final bool isAdd = index == 2;

            // Get selected index only for dashboard, leads, attendance, account (not for Add)
            final bool isSelected = !isAdd &&
                controller.selectedIndex.value == (index > 2 ? index - 1 : index);

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  if (isAdd) {
                    // Navigate without changing bottom nav index
                    Get.toNamed(AppRoutes.addLead);
                  } else {
                    final actualIndex = index > 2 ? index - 1 : index;
                    controller.changePage(actualIndex);
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      navItems[index]['icon'],
                      size: isAdd ? 25 : 25,
                      color: isAdd
                          ? Colors.white
                          : isSelected
                          ? Colors.orange
                          : Colors.white70,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      navItems[index]['label'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isAdd
                            ? Colors.white
                            : isSelected
                            ? Colors.orange
                            : Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}

// Custom painter for the curved navigation bar

// Scaffold implementation example
