import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/constant/app_images.dart';
import 'package:kredipal/routes/app_routes.dart';

import '../constant/app_color.dart';
import '../controller/login-controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColor.bgColor,
              AppColor.bgColor.withOpacity(0.8),
              AppColor.primaryColor.withOpacity(0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Enhanced Logo Section

                            // Welcome Text Section
                            _buildWelcomeSection(),

                            const SizedBox(height: 40),

                            // Login Form Card
                            _buildLoginForm(controller),

                            const SizedBox(height: 30),

                            // Additional Features
                            _buildAdditionalFeatures(),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }


  Widget _buildWelcomeSection() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.white, Colors.white.withOpacity(0.8)],
          ).createShader(bounds),
          child: InkWell(
            onTap: (){Get.toNamed(AppRoutes.home);},
            child: const Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildLoginForm(AuthController controller) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),

        border: Border.all(
          color: Colors.white.withOpacity(1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Form header

          const SizedBox(height: 30),

          // Enhanced Email Field
          _buildEnhancedTextField(
            controller: controller.emailController,
            label: 'Email Address',
            hint: 'Enter your email',
            icon: Icons.email_outlined,
            color: Colors.blue,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email id Required';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Enhanced Password Field
          _buildEnhancedTextField(
            controller: controller.passwordController,
            label: 'Password',
            hint: 'Enter your password',
            icon: Icons.lock_outline,
            color: Colors.purple,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password require';
              }
              return null;
            },
          ),

          const SizedBox(height: 30),

          // Enhanced Login Button
          Obx(() => _buildEnhancedButton(
            text: 'Sign In',
            isLoading: controller.isLoading.value,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                controller.loginUser();
              }
            },
          )),
        ],
      ),
    );
  }

  Widget _buildEnhancedTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color color,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white, // Label color white
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            labelStyle: const TextStyle(color: Colors.white),
            prefixIcon: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            filled: true,
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.white, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.white, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: color, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          style: const TextStyle(color: Colors.white), // Text color white
        ),
      ],
    );
  }


  Widget _buildEnhancedButton({
    required String text,
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isLoading
              ? [Colors.grey[400]!, Colors.grey[500]!]
              : [AppColor.primaryColor, AppColor.primaryColor.withOpacity(1)],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: (isLoading ? Colors.grey : AppColor.primaryColor)
                .withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(15),
          child: Center(
            child: isLoading
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.login, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalFeatures() {
    return Column(
      children: [
        // Security badge

        const SizedBox(height: 20),

        // App version
        Text(
          'Version 1.0.0',
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
