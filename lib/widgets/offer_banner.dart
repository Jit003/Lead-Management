import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/dashboard_controller.dart';
import '../controller/offer_controller.dart';
import '../models/offer_model.dart';

class OfferBanner extends StatelessWidget {
   OfferBanner({Key? key}) : super(key: key);
  final OffersController controller = Get.put(OffersController());
   final DashboardController dashboardController =
   Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingBanner();
      }

      if (!controller.hasOffers.value) {
        return const SizedBox.shrink();
      }

      return RefreshIndicator(
        onRefresh: () async {
          await dashboardController.loadDashboardData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 0),
                height: 110,
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: controller.offers.length,
                  itemBuilder: (context, index) {
                    final offer = controller.offers[index];
                    return _buildOfferCard(offer, context);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

   Widget _buildOfferCard(Offers offer, BuildContext context) {
     return GestureDetector(
       onTap: () => controller.goToOfferDetails(offer),
       child: Container(
         margin: const EdgeInsets.symmetric(horizontal: 4),
         height: 180,
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(16),
           boxShadow: [
             BoxShadow(
               color: Colors.black.withOpacity(0.1),
               blurRadius: 10,
               offset: const Offset(0, 4),
             ),
           ],
         ),
         child: ClipRRect(
           borderRadius: BorderRadius.circular(16),
           child: Stack(
             fit: StackFit.expand,
             children: [
               // Background Image
               if (offer.attachment != null && offer.attachment!.isNotEmpty)
                 Image.network(
                   offer.attachment![0],
                   fit: BoxFit.cover,
                   errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[300]),
                   loadingBuilder: (context, child, loadingProgress) {
                     if (loadingProgress == null) return child;
                     return Container(
                       color: Colors.grey[200],
                       child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                     );
                   },
                 ),

               // Gradient overlay
               Container(
                 decoration: const BoxDecoration(
                   gradient: LinearGradient(
                     begin: Alignment.topLeft,
                     end: Alignment.bottomRight,
                     colors: [
                       Color(0xAA667eea),
                       Color(0xAA764ba2),
                     ],
                   ),
                 ),
               ),

               // Offer content
               Padding(
                 padding: const EdgeInsets.all(20),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     // Header row
                     Row(
                       children: [
                         Container(
                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                           decoration: BoxDecoration(
                             color: Colors.white.withOpacity(0.2),
                             borderRadius: BorderRadius.circular(12),
                           ),
                           child: const Text(
                             'SPECIAL OFFER',
                             style: TextStyle(
                               color: Colors.white,
                               fontSize: 10,
                               fontWeight: FontWeight.bold,
                               letterSpacing: 0.5,
                             ),
                           ),
                         ),
                         const Spacer(),
                         Icon(
                           Icons.arrow_forward_ios,
                           color: Colors.white.withOpacity(0.8),
                           size: 16,
                         ),
                       ],
                     ),
                     const SizedBox(height: 15),

                     // Title
                     Text(
                       offer.title ?? 'Special Offer',
                       style: const TextStyle(
                         color: Colors.white,
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                       ),
                       maxLines: 1,
                       overflow: TextOverflow.ellipsis,
                     ),
                   ],
                 ),
               ),
             ],
           ),
         ),
       ),
     );
   }

  Widget _buildLoadingBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
