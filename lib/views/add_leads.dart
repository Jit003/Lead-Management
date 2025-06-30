import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/constant/app_color.dart';
import 'package:kredipal/controller/lead_details_text_more_controller.dart';
import '../controller/addleads_controller.dart';
import '../widgets/custom_app_bar.dart';
import 'add_lead/bl_add_lead.dart';
import 'add_lead/ccl_add_lead.dart';
import 'add_lead/hl_add_lead.dart';
import 'add_lead/pl_add_lead.dart';

class AddLeadsPage extends StatefulWidget {
  final String? preselectedLeadType;

  AddLeadsPage({super.key, this.preselectedLeadType});

  @override
  State<AddLeadsPage> createState() => _AddLeadsPageState();
}

class _AddLeadsPageState extends State<AddLeadsPage> {
  final AddLeadsController addLeadsController = Get.put(AddLeadsController());

  final MoreTextController moreTextController = Get.put(MoreTextController());

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Defer the state update until after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addLeadsController.clearForm(
        leadType: widget.preselectedLeadType ?? 'personal_loan',
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    // Set only if not already set
    if (widget.preselectedLeadType != null &&
        addLeadsController.leadTypeValue.value.isEmpty) {
      addLeadsController.leadTypeValue.value = widget.preselectedLeadType!;
    }
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: CustomAppBar(title: 'Add New Lead'),
      body: Column(
        children: [
          _buildLeadTypeButtons(),

          // Form Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Form(
                key: _formKey,
                child: Obx(() => _buildBodyContent()),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildSaveButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildLeadTypeButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: addLeadsController.leadType.take(4).map((type) {
          final display = leadTypeDisplay[type];
          return Obx(() => Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ElevatedButton(
                onPressed: () {
                  addLeadsController.leadTypeValue.value = type;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  addLeadsController.leadTypeValue.value == type
                      ? AppColor.btnColor
                      : const Color(0xFFF5F5F5),
                  foregroundColor:
                  addLeadsController.leadTypeValue.value == type
                      ? Colors.white
                      : const Color(0xFF1A1A1A),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      display?['icon'],
                      size: 24,
                      color: addLeadsController.leadTypeValue.value == type
                          ? Colors.white
                          : const Color(0xFF1A1A1A),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      display?['label'] ?? type,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: addLeadsController.leadTypeValue.value == type
                            ? Colors.white
                            : const Color(0xFF1A1A1A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ));
        }).toList(),
      ),
    );
  }

  Widget _buildBodyContent() {
    switch (addLeadsController.leadTypeValue.value) {
      case 'personal_loan':
        return buildPersonalLoanBody();
      case 'home_loan':
        return buildHomeLoanBody();
      case 'creditcard_loan':
        return buildCreditCardLoanBody();
      case 'business_loan':
        return buildBusinessLoanBody();
      default:
        return const SizedBox(child: Text('Nothing to show'),);
    }
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() => ElevatedButton(
            onPressed: addLeadsController.isLoading.value
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      addLeadsController.createLead();
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.btnColor,
              disabledBackgroundColor: const Color(0xFFCCCCCC),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (addLeadsController.isLoading.value)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                else
                  const Icon(Icons.save_outlined, size: 20),
                const SizedBox(width: 12),
                Text(
                  addLeadsController.isLoading.value
                      ? 'Saving Lead...'
                      : 'Save Lead',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )),
    );
  }

  final Map<String, Map<String, dynamic>> leadTypeDisplay = {
    'personal_loan': {
      'label': 'PL',
      'icon': Icons.person,
    },
    'business_loan': {
      'label': 'BL',
      'icon': Icons.business,
    },
    'home_loan': {
      'label': 'HL',
      'icon': Icons.home,
    },
    'creditcard_loan': {
      'label': 'CC',
      'icon': Icons.credit_card,
    },
    // Add more if you have
  };
}






















// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:kredipal/constant/app_color.dart';
// import 'package:kredipal/controller/lead_details_text_more_controller.dart';
// import 'package:kredipal/widgets/custom_app_bar.dart';

// class AddLeadsController extends GetxController {
//   var leadTypeValue = ''.obs;
//   var isLoading = false.obs;

//   // Text Controllers for all fields
//   final nameController = TextEditingController();
//   final businessNameController = TextEditingController();
//   final phoneController = TextEditingController();
//   final locationController = TextEditingController();
//   final bankNameController = TextEditingController();
//   final loanAmountController = TextEditingController();
//   final employmentTypeController = TextEditingController();
//   final businessVintageController = TextEditingController();

//   final leadType = [
//     'personal_loan',
//     'business_loan',
//     'home_loan',
//     'creditcard_loan',
//   ];
//   var selectedBank = ''.obs;
//   final List<String> banks = [
//     'Select Bank',
//     'State Bank',
//     'Andhra Bank',
//     'HDFC Bank',
//     'ICICI Bank'
//   ];

//   void clearForm({required String leadType}) {
//     leadTypeValue.value = leadType;
//     nameController.clear();
//     businessNameController.clear();
//     phoneController.clear();
//     locationController.clear();
//     bankNameController.clear();
//     loanAmountController.clear();
//     employmentTypeController.clear();
//     businessVintageController.clear();
//   }

//   void createLead() async {
//     isLoading.value = true;

//     // Prepare lead data based on lead type
//     Map<String, dynamic> leadData = {
//       'lead_type': leadTypeValue.value,
//       'name': nameController.text.trim(),
//       'location': locationController.text.trim(),
//     };

//     // Add specific fields based on lead type
//     switch (leadTypeValue.value) {
//       case 'business_loan':
//         leadData.addAll({
//           'business_name': businessNameController.text.trim(),
//           'phone': phoneController.text.trim(),
//           'salary': '50 Lac & Above', // Fixed value
//           'business_vintage':
//               businessVintageController.text.trim(), // Added field
//         });
//         break;
//       case 'creditcard_loan':
//         leadData.addAll({
//           'bank_name': bankNameController.text.trim(),
//         });
//         break;
//       case 'home_loan':
//         leadData.addAll({
//           'phone': phoneController.text.trim(),
//           'loan_amount': loanAmountController.text.trim(),
//         });
//         break;
//       case 'personal_loan':
//         leadData.addAll({
//           'phone': phoneController.text.trim(),
//           'employment_type': employmentTypeController.text.trim(),
//         });
//         break;
//     }

//     // Simulate API call
//     await Future.delayed(const Duration(seconds: 2));
//     print('Lead Data: $leadData');

//     isLoading.value = false;
//     Get.snackbar('Success', 'Lead created successfully!');
//     clearForm(leadType: leadTypeValue.value);
//   }

//   @override
//   void onClose() {
//     // Dispose controllers
//     nameController.dispose();
//     businessNameController.dispose();
//     phoneController.dispose();
//     locationController.dispose();
//     bankNameController.dispose();
//     loanAmountController.dispose();
//     employmentTypeController.dispose();
//     businessVintageController.dispose();
//     super.onClose();
//   }
// }

// // Custom Text Field Widget
// class CustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final String hint;
//   final String? Function(String?)? validator;
//   final TextInputType? keyboardType;
//   final bool isReadOnly;

//   const CustomTextField({
//     super.key,
//     required this.controller,
//     required this.label,
//     required this.hint,
//     this.validator,
//     this.keyboardType,
//     this.isReadOnly = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: controller,
//           keyboardType: keyboardType,
//           readOnly: isReadOnly,
//           decoration: InputDecoration(
//             hintText: hint,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Colors.grey[300]!),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Colors.grey[300]!),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: AppColor.btnColor),
//             ),
//             contentPadding:
//                 const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//           ),
//           validator: validator,
//         ),
//       ],
//     );
//   }
// }

// // Form Bodies
// Widget buildPersonalLoanBody() {
//   final AddLeadsController addLeadsController = Get.find<AddLeadsController>();

//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       CustomTextField(
//         controller: addLeadsController.nameController,
//         label: 'Name',
//         hint: 'Enter full name',
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter a name';
//           }
//           return null;
//         },
//       ),
//       const SizedBox(height: 16),
//       CustomTextField(
//         controller: addLeadsController.phoneController,
//         label: 'Phone Number',
//         hint: 'Enter phone number',
//         keyboardType: TextInputType.phone,
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter a phone number';
//           } else if (value.length != 10) {
//             return 'Please enter a valid 10-digit phone number';
//           }
//           return null;
//         },
//       ),
//       const SizedBox(height: 16),
//       CustomTextField(
//         controller: addLeadsController.locationController,
//         label: 'Location',
//         hint: 'Enter city or area',
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter a location';
//           }
//           return null;
//         },
//       ),
//       const SizedBox(height: 16),
//       CustomTextField(
//         controller: addLeadsController.employmentTypeController,
//         label: 'Employment Type',
//         hint: 'Enter employment type (e.g., Salaried, Self-Employed)',
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter employment type';
//           }
//           return null;
//         },
//       ),
//       const SizedBox(height: 80),
//     ],
//   );
// }

// Widget buildBusinessLoanBody() {
//   final AddLeadsController addLeadsController = Get.find<AddLeadsController>();

//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       CustomTextField(
//         controller: addLeadsController.nameController,
//         label: 'Name',
//         hint: 'Enter full name',
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter a name';
//           }
//           return null;
//         },
//       ),
//       const SizedBox(height: 16),
//       CustomTextField(
//         controller: addLeadsController.businessNameController,
//         label: 'Business Name',
//         hint: 'Enter business name',
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter a business name';
//           }
//           return null;
//         },
//       ),
//       const SizedBox(height: 16),
//       CustomTextField(
//         controller: addLeadsController.phoneController,
//         label: 'Phone Number',
//         hint: 'Enter phone number',
//         keyboardType: TextInputType.phone,
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter a phone number';
//           } else if (value.length != 10) {
//             return 'Please enter a valid 10-digit phone number';
//           }
//           return null;
//         },
//       ),
//       const SizedBox(height: 16),
//       CustomTextField(
//         controller: addLeadsController.locationController,
//         label: 'Location',
//         hint: 'Enter city or area',
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter a location';
//           }
//           return null;
//         },
//       ),
//       const SizedBox(height: 16),
//       CustomTextField(
//         controller: addLeadsController.businessVintageController,
//         label: 'Business Vintage (Months)',
//         hint: 'Enter business vintage in months',
//         keyboardType: TextInputType.number,
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter business vintage';
//           } else if (int.tryParse(value) == null || int.parse(value) < 24) {
//             return 'Business vintage must be at least 24 months';
//           }
//           return null;
//         },
//       ),
//       const SizedBox(height: 80),
//     ],
//   );
// }

// Widget buildCreditCardLoanBody() {
//   final AddLeadsController addLeadsController = Get.find<AddLeadsController>();

//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       CustomTextField(
//         controller: addLeadsController.nameController,
//         label: 'Name',
//         hint: 'Enter full name',
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter a name';
//           }
//           return null;
//         },
//       ),
//       const SizedBox(height: 16),
//       CustomTextField(
//         controller: addLeadsController.locationController,
//         label: 'Location',
//         hint: 'Enter city or area',
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter a location';
//           }
//           return null;
//         },
//       ),
//       const SizedBox(height: 16),
//       Obx(() => Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Bank Name',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               DropdownButtonFormField<String>(
//                 value: addLeadsController.selectedBank.value.isEmpty
//                     ? null
//                     : addLeadsController.selectedBank.value,
//                 hint: const Text(
//                   'Select Bank',
//                   style: TextStyle(fontWeight: FontWeight.normal),
//                 ),
//                 items: addLeadsController.banks.map((String bank) {
//                   return DropdownMenuItem<String>(
//                     value: bank,
//                     child: Text(
//                       bank,
//                       style: const TextStyle(fontWeight: FontWeight.normal),
//                     ),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   if (newValue != null) {
//                     addLeadsController.selectedBank.value = newValue;
//                   }
//                 },
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide(color: Colors.grey[300]!),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide(color: Colors.grey[300]!),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: const BorderSide(color: AppColor.btnColor),
//                   ),
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//                 ),
//                 validator: (value) {
//                   if (value == null || value == 'Select Bank') {
//                     return 'Please select a bank';
//                   }
//                   return null;
//                 },
//               ),
//             ],
//           )),
//       const SizedBox(height: 80),
//     ],
//   );
// }

// Widget buildHomeLoanBody() {
//   final AddLeadsController addLeadsController = Get.find<AddLeadsController>();

//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       CustomTextField(
//         controller: addLeadsController.nameController,
//         label: 'Name',
//         hint: 'Enter full name',
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter a name';
//           }
//           return null;
//         },
//       ),
//       const SizedBox(height: 16),
//       CustomTextField(
//         controller: addLeadsController.phoneController,
//         label: 'Phone Number',
//         hint: 'Enter phone number',
//         keyboardType: TextInputType.phone,
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter a phone number';
//           } else if (value.length != 10) {
//             return 'Please enter a valid 10-digit phone number';
//           }
//           return null;
//         },
//       ),
//       const SizedBox(height: 16),
//       CustomTextField(
//         controller: addLeadsController.locationController,
//         label: 'Location',
//         hint: 'Enter city or area',
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter a location';
//           }
//           return null;
//         },
//       ),
//       const SizedBox(height: 16),
//       CustomTextField(
//         controller: addLeadsController.loanAmountController,
//         label: 'Loan Amount',
//         hint: 'Enter loan amount (in INR)',
//         keyboardType: TextInputType.number,
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter a loan amount';
//           }
//           return null;
//         },
//       ),
//       const SizedBox(height: 80),
//     ],
//   );
// }

// // Main Add Leads Page
// class AddLeadsPage extends StatefulWidget {
//   final String? preselectedLeadType;

//   const AddLeadsPage({super.key, this.preselectedLeadType});

//   @override
//   State<AddLeadsPage> createState() => _AddLeadsPageState();
// }

// class _AddLeadsPageState extends State<AddLeadsPage> {
//   final AddLeadsController addLeadsController = Get.put(AddLeadsController());
//   final MoreTextController moreTextController = Get.put(MoreTextController());
//   final _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     addLeadsController.clearForm(
//       leadType: widget.preselectedLeadType ?? 'personal_loan',
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.preselectedLeadType != null &&
//         addLeadsController.leadTypeValue.value.isEmpty) {
//       addLeadsController.leadTypeValue.value = widget.preselectedLeadType!;
//     }
//     return Scaffold(
//       backgroundColor: const Color(0xFFFAFAFA),
//       appBar: CustomAppBar(title: 'Add New Lead'),
//       body: Column(
//         children: [
//           _buildLeadTypeButtons(),
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//               child: Form(
//                 key: _formKey,
//                 child: Obx(() => _buildBodyContent()),
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: _buildSaveButton(),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }

//   Widget _buildLeadTypeButtons() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//       color: Colors.white,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: addLeadsController.leadType.take(4).map((type) {
//           final display = leadTypeDisplay[type];
//           return Obx(() => Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 4),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       addLeadsController.leadTypeValue.value = type;
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor:
//                           addLeadsController.leadTypeValue.value == type
//                               ? AppColor.btnColor
//                               : const Color(0xFFF5F5F5),
//                       foregroundColor:
//                           addLeadsController.leadTypeValue.value == type
//                               ? Colors.white
//                               : const Color(0xFF1A1A1A),
//                       elevation: 0,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           display?['icon'],
//                           size: 24,
//                           color: addLeadsController.leadTypeValue.value == type
//                               ? Colors.white
//                               : const Color(0xFF1A1A1A),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           display?['label'] ?? type,
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             color:
//                                 addLeadsController.leadTypeValue.value == type
//                                     ? Colors.white
//                                     : const Color(0xFF1A1A1A),
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ));
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildBodyContent() {
//     switch (addLeadsController.leadTypeValue.value) {
//       case 'personal_loan':
//         return buildPersonalLoanBody();
//       case 'home_loan':
//         return buildHomeLoanBody();
//       case 'creditcard_loan':
//         return buildCreditCardLoanBody();
//       case 'business_loan':
//         return buildBusinessLoanBody();
//       default:
//         return const SizedBox(child: Text('Nothing to show'));
//     }
//   }

//   Widget _buildSaveButton() {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       child: Obx(() => ElevatedButton(
//             onPressed: addLeadsController.isLoading.value
//                 ? null
//                 : () {
//                     if (_formKey.currentState!.validate()) {
//                       addLeadsController.createLead();
//                     }
//                   },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColor.btnColor,
//               disabledBackgroundColor: const Color(0xFFCCCCCC),
//               foregroundColor: Colors.white,
//               elevation: 0,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 if (addLeadsController.isLoading.value)
//                   const SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     ),
//                   )
//                 else
//                   const Icon(Icons.save_outlined, size: 20),
//                 const SizedBox(width: 12),
//                 Text(
//                   addLeadsController.isLoading.value
//                       ? 'Saving Lead...'
//                       : 'Save Lead',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           )),
//     );
//   }

//   final Map<String, Map<String, dynamic>> leadTypeDisplay = {
//     'personal_loan': {
//       'label': 'PL',
//       'icon': Icons.person,
//     },
//     'business_loan': {
//       'label': 'BL',
//       'icon': Icons.business,
//     },
//     'home_loan': {
//       'label': 'HL',
//       'icon': Icons.home,
//     },
//     'creditcard_loan': {
//       'label': 'CC',
//       'icon': Icons.credit_card,
//     },
//   };
// }
