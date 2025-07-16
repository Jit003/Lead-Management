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

