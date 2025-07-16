import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/forward_lead_controller.dart';

class ForwardDropdown extends StatelessWidget {
  final Function(String) onForwarded;

  const ForwardDropdown({
    Key? key,
    required this.onForwarded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForwardDropdownController());


    return Obx(() {
      final selected = controller.selectedOption.value;
      final forwarded = controller.isForwarded.value;
      final options = controller.options.toList(); // create a copy to avoid mutation issues

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!forwarded)
            const Padding(
              padding: EdgeInsets.only(left: 20, bottom: 8, top: 8),
              child: Text(
                'Swipe Right to Forward:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
            ),

          // ✅ Show forwarded card only
          if (forwarded && selected != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      selected,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade800,
                      ),
                    ),
                  ),
                  const Text(
                    'Forwarded',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

          // ✅ Show Dismissible options if not forwarded yet
          if (!forwarded)
            ...options.map((option) {
              return Dismissible(
                key: ValueKey(option),
                direction: DismissDirection.startToEnd,
                background: Container(
                  padding: const EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.send, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Forward',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                onDismissed: (_) {
                  // ✅ Update state
                  controller.selectOption(option);
                  controller.onForward(onForwarded);

                  // ✅ Remove from options list
                  controller.options.remove(option);

                  // ✅ Mark as forwarded
                  controller.isForwarded.value = true;
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.orange,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.forward_to_inbox, color: Colors.deepOrange),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.deepOrange),
                    ],
                  ),
                ),
              );
            }).toList(),
        ],
      );
    });
  }
}
