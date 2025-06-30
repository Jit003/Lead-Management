import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/controller/login-controller.dart';
import 'package:kredipal/routes/app_routes.dart';
import 'package:kredipal/views/apply_leave_screen.dart';
import '../constant/app_color.dart';
import '../controller/user_profile_controller.dart';
import '../widgets/profile_option_tile.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final AuthController authController = Get.find<AuthController>();
  final userController = Get.put(UserController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Gorgeous Header Section
          SliverToBoxAdapter(
            child: Obx(() => Container(
              decoration: BoxDecoration(
                color: AppColor.appBarColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Profile Avatar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Text(
                          _getInitials(authController.userData['name'] ?? ''),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppColor.appBarColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 5,),
                      // Name
                      Flexible(
                        child: Column(
                          children: [
                            Text(
                              '${authController.userData['name']}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),

                            // Designation
                            Text(
                              '(${authController.userData['designation']}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.85),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Contact Info
                  _buildContactCard(
                    Icons.email_outlined,
                    '${authController.userData['email']}',
                  ),
                  _buildContactCard(
                    Icons.phone_outlined,
                    '${authController.userData['phone']}',
                  ),

                ],
              ),
            )),
          ),

          // Beautiful Options Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section header
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColor.appBarColor.withOpacity(0.1), AppColor.appBarColor.withOpacity(0.05)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.settings_outlined,
                            color: AppColor.appBarColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Quick Actions',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Beautiful option tiles
                  _buildGorgeousOptionTile(
                    Icons.add_circle_outline,
                    "Apply for Leave",
                    "Request time off",
                    Colors.blue,
                        () => Get.to(() => ApplyLeavePage()),
                  ),

                  const SizedBox(height: 16),
                  _buildGorgeousOptionTile(
                    Icons.receipt_long_outlined,
                    "Salary Slip",
                    "View payment details",
                    Colors.green,
                        () => Get.toNamed(AppRoutes.salarySlip),
                  ),

                  const SizedBox(height: 16),
                  _buildGorgeousOptionTile(
                    Icons.history_outlined,
                    "Leave History",
                    "Track your records",
                    Colors.purple,
                        () => Get.toNamed(AppRoutes.leaveHistory),
                  ),

                  const SizedBox(height: 16),
                  _buildGorgeousOptionTile(
                    Icons.lock_outline,
                    "Change Password",
                    "Update security",
                    Colors.amber,
                        () => Get.toNamed(AppRoutes.password),
                  ),

                  const SizedBox(height: 16),
                  _buildGorgeousOptionTile(
                    Icons.edit_outlined,
                    "Edit Profile",
                    "Update information",
                    Colors.teal,
                        () => Get.toNamed(AppRoutes.editProfile),
                  ),

                  const SizedBox(height: 16),
                  _buildGorgeousOptionTile(
                    Icons.logout_outlined,
                    "Logout",
                    "Sign out securely",
                    Colors.red,
                        () => authController.logoutUser(),
                    isDestructive: true,
                  ),
                ],
              ),

            ),
          ),

          // ✅ Sliver 3: Add this padding at the bottom
          SliverPadding(
            padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight + 30),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String info) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),

      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              info,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGorgeousOptionTile(
      IconData icon,
      String title,
      String? subtitle,
      Color color,
      VoidCallback onTap, {
        bool isDestructive = false,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Gradient icon container
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.8), color],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),

                const SizedBox(width: 20),

                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: isDestructive ? Colors.red[600] : Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow indicator
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';

    List<String> nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return nameParts[0][0].toUpperCase() + nameParts[1][0].toUpperCase();
    } else {
      return name[0].toUpperCase();
    }
  }
}
