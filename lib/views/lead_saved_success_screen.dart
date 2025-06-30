import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/constant/app_color.dart';
import 'package:kredipal/routes/app_routes.dart';

class LeadSavedSuccessScreen extends StatelessWidget {
  const LeadSavedSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBarColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ Checkmark circle
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 80,
                ),
              ),
              const SizedBox(height: 24),

              // ✅ Success text
              Text(
                "Lead Saved Successfully!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                "Your new lead has been added.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),

              // ✅ View Leads Button
              ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed(AppRoutes.home);
                },
                icon: const Icon(Icons.list_alt),
                label: const Text("Go to home"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColor.appBarColor,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
