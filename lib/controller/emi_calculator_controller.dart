import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

class EmiCalculatorController extends GetxController {
  // Observable variables
  var loanAmount = 0.0.obs;
  var interestRate = 0.0.obs;
  var loanTenure = 0.0.obs;
  var tenureType = 'Years'.obs; // Years or Months

  // Results
  var monthlyEmi = 0.0.obs;
  var totalAmount = 0.0.obs;
  var totalInterest = 0.0.obs;

  // Controllers for text fields
  var loanAmountController = TextEditingController();
  var interestRateController = TextEditingController();
  var loanTenureController = TextEditingController();

  // Tenure type options
  final tenureTypes = ['Years', 'Months'];

  @override
  void onInit() {
    super.onInit();
    // Listen to text field changes
    loanAmountController.addListener(() {
      loanAmount.value = double.tryParse(loanAmountController.text) ?? 0.0;
      calculateEmi();
    });

    interestRateController.addListener(() {
      interestRate.value = double.tryParse(interestRateController.text) ?? 0.0;
      calculateEmi();
    });

    loanTenureController.addListener(() {
      loanTenure.value = double.tryParse(loanTenureController.text) ?? 0.0;
      calculateEmi();
    });
  }

  void calculateEmi() {
    if (loanAmount.value > 0 && interestRate.value > 0 && loanTenure.value > 0) {
      double principal = loanAmount.value;
      double rate = interestRate.value / 100 / 12; // Monthly interest rate
      double tenure = tenureType.value == 'Years'
          ? loanTenure.value * 12
          : loanTenure.value; // Convert to months

      // EMI Formula: P * r * (1 + r)^n / ((1 + r)^n - 1)
      double emi = principal * rate * pow(1 + rate, tenure) / (pow(1 + rate, tenure) - 1);

      monthlyEmi.value = emi;
      totalAmount.value = emi * tenure;
      totalInterest.value = totalAmount.value - principal;
    } else {
      monthlyEmi.value = 0.0;
      totalAmount.value = 0.0;
      totalInterest.value = 0.0;
    }
  }

  void updateTenureType(String type) {
    tenureType.value = type;
    calculateEmi();
  }

  void clearAll() {
    loanAmountController.clear();
    interestRateController.clear();
    loanTenureController.clear();
    loanAmount.value = 0.0;
    interestRate.value = 0.0;
    loanTenure.value = 0.0;
    monthlyEmi.value = 0.0;
    totalAmount.value = 0.0;
    totalInterest.value = 0.0;
  }

  @override
  void onClose() {
    loanAmountController.dispose();
    interestRateController.dispose();
    loanTenureController.dispose();
    super.onClose();
  }
}
