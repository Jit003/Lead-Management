import 'package:flutter/material.dart';
import 'package:kredipal/constant/app_color.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color textColor;
  final bool isLoading;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor = Colors.white,
    this.isLoading = false,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    // Create a slightly darker shade of the button color for the gradient
    final Color darkShade = HSLColor.fromColor(AppColor.btnColor)
        .withLightness(
        (HSLColor.fromColor(AppColor.btnColor).lightness - 0.1)
            .clamp(0.0, 1.0))
        .toColor();

    // Create a slightly lighter shade of the button color for the gradient
    final Color lightShade = HSLColor.fromColor(AppColor.btnColor)
        .withLightness(
        (HSLColor.fromColor(AppColor.btnColor).lightness + 0.1)
            .clamp(0.0, 1.0))
        .toColor();

    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColor.btnColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColor.btnColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: Colors.white.withOpacity(0.1),
          highlightColor: Colors.white.withOpacity(0.05),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isLoading
                    ? [
                  AppColor.btnColor.withOpacity(0.8),
                  AppColor.btnColor.withOpacity(0.8)
                ]
                    : [lightShade, AppColor.btnColor, darkShade],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isLoading
                    ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      textColor.withOpacity(0.9),
                    ),
                    backgroundColor: Colors.white.withOpacity(0.2),
                  ),
                )
                    : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: textColor.withOpacity(0.8),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
