import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:kredipal/views/offer_details_screen.dart';

import '../models/offer_model.dart';
import '../services/offer_api_service.dart';
import '../widgets/offer_dialog.dart';

class OffersController extends GetxController {
  final ApiService _apiService = Get.put(ApiService());

  // Observable variables
  var isLoading = false.obs;
  var offers = <Offers>[].obs;
  var currentOfferIndex = 0.obs;
  var hasOffers = false.obs;
  var errorMessage = ''.obs;
  var filtersApplied = Rx<FiltersApplied?>(null);

  // Page controller for banner slider
  late PageController pageController;
  Timer? _autoSlideTimer; // <-- Add timer


  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    fetchOffers();
    startAutoSlide();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  Future<void> fetchOffers({
    String? filter,
    String? startDate,
    String? endDate,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _apiService.getOffers(
        filter: filter,
        startDate: startDate,
        endDate: endDate,
      );

      if (result != null && result.status == 'success') {
        offers.value = result.data?.offers ?? [];
        filtersApplied.value = result.data?.filtersApplied;
        hasOffers.value = offers.isNotEmpty;

        // Show dialog if offers available and it's first time
        if (hasOffers.value && shouldShowOfferDialog()) {
          showOfferDialog();
        }
      } else {
        errorMessage.value = result?.message ?? 'Failed to load offers';
        hasOffers.value = false;
      }
    } catch (e) {
      errorMessage.value = 'An error occurred while loading offers';
      hasOffers.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  void startAutoSlide() {
    _autoSlideTimer?.cancel(); // Clear previous timer

    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (offers.isEmpty || !pageController.hasClients) return;

      int nextPage = (currentOfferIndex.value + 1) % offers.length;
      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void onPageChanged(int index) {
    currentOfferIndex.value = index;
  }

  void goToOfferDetails(Offers offer) {
    Get.to(()=>OfferDetailsScreen(), arguments: offer);
  }

  bool shouldShowOfferDialog() {
    // Check if dialog should be shown (e.g., first time, new offers, etc.)
    // You can implement your logic here
    return true;
  }

  void showOfferDialog() {
    if (offers.isNotEmpty) {
      Get.dialog(
        OfferDialog(offer: offers.first),
        barrierDismissible: true,
      );
    }
  }

  void refreshOffers() {
    fetchOffers();
  }
}
