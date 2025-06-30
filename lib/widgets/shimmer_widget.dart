import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LeadStatShimmer extends StatelessWidget {
  final bool isFullWidth;

  const LeadStatShimmer({Key? key, this.isFullWidth = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: isFullWidth ? double.infinity : null,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title bar (simulating text)
            Container(height: 15, width: isFullWidth ? 150 : 90, color: Colors.white),

            // Count number
            Container(height: 20, width: isFullWidth ? 60 : 40, color: Colors.white),

            // Amount
            Container(height: 20, width: isFullWidth ? 100 : 70, color: Colors.white),
            const Spacer(),

            // Bottom row simulating icons and percentage/trend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(height: 20, width: 24, color: Colors.white),
                Container(height: 20, width: isFullWidth ? 60 : 40, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}