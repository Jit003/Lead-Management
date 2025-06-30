import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/emi_calculator_controller.dart';

class EmiCalculatorPage extends StatelessWidget {
  EmiCalculatorPage({super.key});

  final EmiCalculatorController controller = Get.put(EmiCalculatorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // Sliver App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFF1E3A8A),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'EMI Calculator',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1E3A8A),
                      Color(0xFF3B82F6),
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.calculate_outlined,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
              onPressed: () => Get.back(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                onPressed: () => controller.clearAll(),
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Input Section
                  _buildInputSection(),

                  const SizedBox(height: 24),

                  // Results Section
                  _buildResultsSection(),

                  const SizedBox(height: 24),

                  // EMI Breakdown Chart
                  _buildEmiBreakdown(),

                  const SizedBox(height: 100), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A8A).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.input_rounded,
                  color: Color(0xFF1E3A8A),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Loan Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Loan Amount
          _buildInputField(
            label: 'Loan Amount',
            controller: controller.loanAmountController,
            prefix: '₹',
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 20),

          // Interest Rate
          _buildInputField(
            label: 'Interest Rate (per annum)',
            controller: controller.interestRateController,
            suffix: '%',
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 20),

          // Loan Tenure
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildInputField(
                  label: 'Loan Tenure',
                  controller: controller.loanTenureController,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Type',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E5E5)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.tenureType.value,
                          isExpanded: true,
                          items: controller.tenureTypes.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(
                                type,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            if (value != null) {
                              controller.updateTenureType(value);
                            }
                          },
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? prefix,
    String? suffix,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            prefixText: prefix,
            suffixText: suffix,
            prefixStyle: const TextStyle(
              fontSize: 16,
              color: Color(0xFF1A1A1A),
              fontWeight: FontWeight.w500,
            ),
            suffixStyle: const TextStyle(
              fontSize: 16,
              color: Color(0xFF1A1A1A),
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsSection() {
    return Obx(() => Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.analytics_outlined,
                  color: Color(0xFF059669),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'EMI Results',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Monthly EMI
          _buildResultCard(
            title: 'Monthly EMI',
            amount: controller.monthlyEmi.value,
            color: const Color(0xFF1E3A8A),
            icon: Icons.calendar_month_rounded,
          ),

          const SizedBox(height: 16),

          // Total Amount
          _buildResultCard(
            title: 'Total Amount Payable',
            amount: controller.totalAmount.value,
            color: const Color(0xFF7C3AED),
            icon: Icons.account_balance_wallet_outlined,
          ),

          const SizedBox(height: 16),

          // Total Interest
          _buildResultCard(
            title: 'Total Interest Payable',
            amount: controller.totalInterest.value,
            color: const Color(0xFFDC2626),
            icon: Icons.trending_up_rounded,
          ),
        ],
      ),
    ));
  }

  Widget _buildResultCard({
    required String title,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  amount > 0 ? '₹${amount.toStringAsFixed(0)}' : '₹0',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmiBreakdown() {
    return Obx(() => Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.pie_chart_outline_rounded,
                  color: Color(0xFFF59E0B),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Payment Breakdown',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          if (controller.loanAmount.value > 0) ...[
            // Principal vs Interest Chart
            _buildBreakdownBar(),

            const SizedBox(height: 20),

            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem(
                  'Principal',
                  controller.loanAmount.value,
                  const Color(0xFF059669),
                ),
                _buildLegendItem(
                  'Interest',
                  controller.totalInterest.value,
                  const Color(0xFFDC2626),
                ),
              ],
            ),
          ] else
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Enter loan details to see breakdown',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                  ),
                ),
              ),
            ),
        ],
      ),
    ));
  }

  Widget _buildBreakdownBar() {
    double principal = controller.loanAmount.value;
    double interest = controller.totalInterest.value;
    double total = principal + interest;

    if (total == 0) return const SizedBox();

    double principalPercentage = (principal / total) * 100;
    double interestPercentage = (interest / total) * 100;

    return Column(
      children: [
        Container(
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFF3F4F6),
          ),
          child: Row(
            children: [
              if (principalPercentage > 0)
                Expanded(
                  flex: principalPercentage.round(),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF059669),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              if (interestPercentage > 0)
                Expanded(
                  flex: interestPercentage.round(),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFDC2626),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${principalPercentage.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF059669),
              ),
            ),
            Text(
              '${interestPercentage.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFFDC2626),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, double amount, Color color) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '₹${amount.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
