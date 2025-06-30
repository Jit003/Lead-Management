import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/constant/app_color.dart';
import 'package:kredipal/widgets/custom_app_bar.dart';
import '../controller/task_controller.dart';
import '../widgets/task_widget/task_card_widget.dart';
import '../widgets/task_widget/task_stat_card.dart';

class TaskScreen extends StatelessWidget {
  final TaskController controller = Get.put(TaskController());

  TaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Tasks',
        actions: [
          IconButton(onPressed: (){
            controller.fetchTasks();
          }, icon: const Icon(Icons.refresh))
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Stats Section
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColor.appBarColor,
                    AppColor.appBarColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.appBarColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.analytics,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Task Overview',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Obx(() => controller.isLoading.value
                      ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildStatCard(
                        'Total',
                        controller.totalTasksCount.toString(),
                        Colors.white,
                        Icons.task_alt,
                      ),
                      buildStatCard(
                        'Pending',
                        controller.getTasksCountByStatus('pending').toString(),
                        Colors.orange,
                        Icons.pending_actions,
                      ),
                      buildStatCard(
                        'In Progress',
                        controller.getTasksCountByStatus('in_progress').toString(),
                        Colors.blue,
                        Icons.trending_up,
                      ),
                      buildStatCard(
                        'Completed',
                        controller.getTasksCountByStatus('completed').toString(),
                        Colors.green,
                        Icons.check_circle,
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ),

          // Filter chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: controller.filterOptions.map((filter) {
                    final isSelected = controller.selectedFilter.value == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(
                          filter == 'all' ? 'All Tasks' : filter.replaceAll('_', ' ').capitalize!,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        backgroundColor: Colors.grey.shade200,
                        selectedColor: AppColor.appBarColor,
                        onSelected: (selected) {
                          controller.selectedFilter.value = filter;
                        },
                        elevation: 2,
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )),
            ),
          ),

          // Task list
          Obx(() {
            if (controller.isLoading.value) {
              return const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (controller.error.value.isNotEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 60, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load tasks',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.error.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => controller.fetchTasks(),
                        child: Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.appBarColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final filteredTasks = controller.getFilteredTasks();

            if (filteredTasks.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.task_alt, size: 60, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'No tasks found',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final task = filteredTasks[index];
                  return buildTaskCard(task);
                },
                childCount: filteredTasks.length,
              ),
            );
          }),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  // Build enhanced stat card

  // Show task update dialog



  // Build beautiful task card
}
