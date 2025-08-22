import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/controller/addleads_controller.dart';
import 'package:kredipal/widgets/custom_app_bar.dart';

import '../widgets/add_lead_widget/voice_record_section.dart';

class FutureLeadFormScreen extends StatefulWidget {
   FutureLeadFormScreen({super.key});

  @override
  State<FutureLeadFormScreen> createState() => _FutureLeadFormScreenState();
}

class _FutureLeadFormScreenState extends State<FutureLeadFormScreen> {
   final AddLeadsController addLeadsController = Get.put(AddLeadsController());

   @override
   void initState() {
     super.initState();
     final String? leadType = Get.arguments;
     if (leadType != null) {
       addLeadsController.leadTypeValue.value = leadType;
     }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Future Lead'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                context,
                label: 'Full Name',
                hint: 'John Doe',
                icon: Icons.person,
                keyboardType: TextInputType.name, controller: addLeadsController.nameController,
              ),
              const SizedBox(height: 20.0),
              _buildTextField(
                context,
                label: 'Phone Number',
                hint: '+1 (555) 123-4567',
                icon: Icons.phone,
                keyboardType: TextInputType.phone, controller: addLeadsController.phoneController,
              ),
              const SizedBox(height: 20.0),
              _buildTextField(
                context,
                label: 'Location',
                hint: 'Acme Corp',
                icon: Icons.location_on_outlined,
                keyboardType: TextInputType.text, controller: addLeadsController.locationController,
              ),
              const SizedBox(height: 20.0),
              _buildTextField(
                context,
                label: 'Email Address (optional)',
                hint: 'john.doe@example.com',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress, controller: addLeadsController.emailController,
              ),
              const SizedBox(height: 20.0),
              VoiceRecorderWidget(),

              const SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {
                  addLeadsController.createLead();
                  // In a real app, you would process the form data here.
                  // For now, we'll just navigate back and show a snackbar.
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  backgroundColor: Colors.orange.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 10,
                  shadowColor: Colors.deepPurple.shade900.withOpacity(0.6),
                ),
                child: const Text(
                  'Save Lead',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build beautiful text form fields
  Widget _buildTextField(
      BuildContext context, {
        required TextEditingController controller,
        required String label,
        required String hint,
        required IconData icon,
        required TextInputType keyboardType,
        int maxLines = 1,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.shade100.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(color: Colors.deepPurple.shade800, fontSize: 17.0),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.deepPurple.shade400),
          labelStyle: TextStyle(color: Colors.deepPurple.shade600),
          hintStyle: TextStyle(color: Colors.grey.shade400),
          filled: true,
          fillColor: Colors.transparent, // Handled by container's color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none, // No border for a cleaner look
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Colors.deepPurple.shade700,
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Colors.deepPurple.shade200,
              width: 1.0,
            ),
          ),
          contentPadding:
          const EdgeInsets.symmetric(vertical: 18.0, horizontal: 15.0),
        ),
      ),
    );
  }
}