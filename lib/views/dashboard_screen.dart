
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/constant/app_color.dart';
import 'package:kredipal/constant/app_images.dart';
import 'package:kredipal/controller/allleads_controller.dart';
import 'package:kredipal/controller/login-controller.dart';
import 'package:kredipal/views/add_leads.dart';
import 'package:kredipal/views/credit_card_screen.dart';
import 'package:kredipal/views/task_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../controller/dashboard_controller.dart';
import '../widgets/shimmer_widget.dart';
import 'emi_cal_page.dart';
import 'filtered_leads_screens.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _EnhancedDashboardScreenState();
}

class _EnhancedDashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late PageController _motivationController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final AllLeadsController leadsController = Get.put(AllLeadsController());
  final AuthController authController = Get.find<AuthController>();
  final DashboardController dashboardController =
      Get.put(DashboardController());

  @override
  void initState() {
    super.initState();
    _motivationController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _motivationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final horizontalPadding = isTablet ? 24.0 : 16.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // Enhanced Sliver App Bar
          SliverAppBar(
            expandedHeight: 100,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColor.appBarColor,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColor.appBarColor,
                      AppColor.appBarColor,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Header Content
                    Positioned(
                      top: 50,
                      left: horizontalPadding,
                      right: horizontalPadding,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildHeaderContent(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                   _showNotifications();
                  },
                  icon: Stack(
                    children: [
                      const Icon(Icons.notifications_outlined,
                          color: Colors.white, size: 24),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints:
                              const BoxConstraints(minWidth: 1, minHeight: 1),
                          child: const Text(
                            '3',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Dashboard Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: 16),
              child: Column(
                children: [
                  // Filter Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterButton('ALL', 'all', Icons.all_inbox,
                                Colors.blue, dashboardController),
                            _buildFilterButton(
                                'Personal Loan',
                                'personal_loan',
                                Icons.person,
                                Colors.purple,
                                dashboardController),
                            _buildFilterButton(
                                'Business Loan',
                                'business_loan',
                                Icons.business_center,
                                Colors.green,
                                dashboardController),
                            _buildFilterButton('Home Loan', 'home_loan',
                                Icons.home, Colors.orange, dashboardController),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // All Leads Card
                      Obx(() =>
                          buildAllLeadsCard(
                            icon: Icons.analytics_outlined,
                            totalLeadsTitle: "Total Leads",
                            totalLeadsCount: "${dashboardController.dashboardData.value.data?.aggregates?.totalLeads?.count ?? '0'}",
                            totalAmountTitle: "Total Amount",
                            totalAmount: dashboardController.formatCurrency(
                              dashboardController.dashboardData.value.data?.aggregates?.totalLeads?.totalAmount,
                            ),
                          )
                      ),

                      const SizedBox(height: 16),

                      // Month Dropdown
                      _buildExpectedMonthDropdown(dashboardController),
                    ],
                  ),

                  // Lead Status Section
                  _buildEnhancedLeadStatusSection(isTablet),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColor.appBarColor.withOpacity(0.75),
                          AppColor.appBarColor.withOpacity(0.75),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Credit Card Statistics",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() => _buildStatColumn(
                              "Ongoing",
                              '${dashboardController.dashboardData.value.data?.leadTypeBreakdown?.creditcardLoan?.applied?.count ?? '0'}',
                            )),

                            Obx(() => _buildStatColumn(
                              "Approved",
                              '${dashboardController.dashboardData.value.data?.leadTypeBreakdown?.creditcardLoan?.approved?.count ?? '0'}',
                            )),

                            Obx(() => _buildStatColumn(
                              "Rejected",
                              '${dashboardController.dashboardData.value.data?.leadTypeBreakdown?.creditcardLoan?.rejected?.count ?? '0'}',
                            )),


                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                 Obx(()=> buildFutureLeadsCard(
                   'Future Reference Leads',
                   '${dashboardController.dashboardData.value.data?.futureLeads?.count ?? '0'}',
                     onViewAll: () {
                       final controller = Get.find<AllLeadsController>();
                       final futureLeads = controller.filteredLeads
                           .where((lead) => lead.status?.toLowerCase() == 'future_lead')
                           .toList();

                       Get.to(() => FilteredLeadsScreen(), arguments: futureLeads);
                     }


                 ),),

                  const SizedBox(
                    height: 20,
                  ),

                  _buildEnhancedLoanProductsSection(isTablet),


                  // Quick Actions Section
                  _buildEnhancedQuickActionsSection(isTablet),

                  // Recent Activities & Market Insights
                  if (isTablet)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildRecentActivities()),
                        const SizedBox(width: 16),
                        Expanded(child: _buildMarketInsights()),
                      ],
                    )
                  else ...[
                    _buildRecentActivities(),
                  ],

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAllLeadsCard({
    required String totalLeadsTitle,
    required String totalLeadsCount,
    required String totalAmountTitle,
    required String totalAmount,
    IconData? icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.appBarColor.withOpacity(0.75),
            AppColor.appBarColor.withOpacity(0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon container
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.orange,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
          ],

          // Content
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Total Leads
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      totalLeadsTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      totalLeadsCount,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                // Total Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      totalAmountTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      totalAmount,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }




  Widget buildFutureLeadsCard(
      String title,
      String count, {
        String? amount,
        VoidCallback? onViewAll,
      }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.appBarColor.withOpacity(0.75),
            AppColor.appBarColor.withOpacity(0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                count,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          if (onViewAll != null) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: onViewAll,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: const Text("View All"),
              ),
            ),
          ],
        ],
      ),
    );
  }


  Widget _buildHeaderContent() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage(AppImages.profileImg),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final userName = dashboardController.dashboardData.value.data?.user?.name;

                if (userName == null || userName.isEmpty) {
                  // Show shimmer while loading
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 150,
                      height: 24,
                      color: Colors.white54, // Simulates the text container
                    ),
                  );
                }

                // Show actual text when loaded
                return Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }),


              const SizedBox(height: 4),
              Obx(() => Text(
                    dashboardController
                            .dashboardData.value.data?.user?.designation ??
                        '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton(String label, String leadTypeValue, IconData icon,
      Color iconColor, DashboardController controller) {
    return Obx(() => GestureDetector(
          onTap: () {
            controller.selectedLeadType.value = leadTypeValue;
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: controller.selectedLeadType.value == leadTypeValue
                  ? Colors.white
                  : Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: controller.selectedLeadType.value == leadTypeValue
                    ? Colors.orange
                    : Colors.grey.shade300,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: controller.selectedLeadType.value == leadTypeValue
                      ? iconColor
                      : Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: controller.selectedLeadType.value == leadTypeValue
                        ? Colors.black87
                        : Colors.grey.shade600,
                    fontWeight:
                        controller.selectedLeadType.value == leadTypeValue
                            ? FontWeight.w600
                            : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildExpectedMonthDropdown(DashboardController controller) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return Obx(() {
      final selectedMonth = controller.expectedMonth.value;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: DropdownButton<String>(
          value: months.contains(selectedMonth) ? selectedMonth : null,
          items: months.map((month) {
            return DropdownMenuItem(
              value: month,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  month,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null && val != controller.expectedMonth.value) {
              controller.expectedMonth.value = val;
              controller.loadDashboardData(); // optional, if you want to call it manually
            }
          },
          isExpanded: true,
          underline: const SizedBox(),
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Select Month",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          icon: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Icon(
              Icons.arrow_drop_down,
              color: Colors.grey.shade600,
              size: 24,
            ),
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          elevation: 4,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade800,
          ),
        ),
      );
    });
  }

  Widget _buildEnhancedLoanProductsSection(bool isTablet) {
    return Obx(() {
      if (dashboardController.isLoading.value) {
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      final loanProducts = [
        {
          'title': 'Personal Loan',
          'icon': Icons.person_outline_rounded,
          'color': const Color(0xFF3B82F6),
          'onTap': () =>
              Get.to(() => AddLeadsPage(preselectedLeadType: 'personal_loan')),
        },
        {
          'title': 'Business Loan',
          'icon': Icons.business_center_outlined,
          'color': const Color(0xFF10B981),
          'onTap': () =>
              Get.to(() => AddLeadsPage(preselectedLeadType: 'business_loan')),
        },
        {
          'title': 'Home Loan',
          'icon': Icons.home_outlined,
          'color': const Color(0xFFF59E0B),
          'onTap': () =>
              Get.to(() => AddLeadsPage(preselectedLeadType: 'home_loan')),
        },
        {
          'title': 'Credit Card',
          'icon': Icons.credit_card_outlined,
          'color': const Color(0xFF8B5CF6),
          'onTap': () => Get.to(
              () => AddLeadsPage(preselectedLeadType: 'creditcard_loan')),
        },
      ];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Action',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isTablet ? 4 : 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 16,
              childAspectRatio: isTablet ? 1.1 : 1.4,
            ),
            itemCount: loanProducts.length,
            itemBuilder: (context, index) {
              final product = loanProducts[index];
              return _buildEnhancedLoanProductCard(product);
            },
          ),
        ],
      );
    });
  }

  Widget _buildEnhancedLoanProductCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            product['color'].withOpacity(0.01),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 1,
          ),
        ],
        border: Border.all(color: product['color'].withOpacity(0.2), width: 0.5),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: product['onTap'],
          borderRadius: BorderRadius.circular(20),
          splashColor: product['color'].withOpacity(0.2),
          highlightColor: product['color'].withOpacity(0.1),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        product['color'].withOpacity(0.15),
                        product['color'].withOpacity(0.3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: product['color'].withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    product['icon'],
                    color: product['color'],
                    size: 26,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  product['title'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildEnhancedQuickActionsSection(bool isTablet) {
    final quickActions = [
      {
        'title': 'EMI Calculator',
        'icon': Icons.calculate_outlined,
        'color': const Color(0xFF3B82F6),
        'onTap': () => Get.to(() => EmiCalculatorPage()),
      },
      {
        'title': 'Credit Card',
        'icon': Icons.credit_score_outlined,
        'color': const Color(0xFF10B981),
        'onTap': () {
          Get.to(() => const CreditCardLeadsListPage());
        },
      },
      {
        'title': 'Documents',
        'icon': Icons.description_outlined,
        'color': const Color(0xFFF59E0B),
        'onTap': () => _showComingSoon('Document Manager'),
      },
      {
        'title': 'Support',
        'icon': Icons.support_agent_outlined,
        'color': const Color(0xFF8B5CF6),
        'onTap': () => _showComingSoon('Customer Support'),
      },
      {
        'title': 'Task',
        'icon': Icons.track_changes_outlined,
        'color': const Color(0xFFDC2626),
        'onTap': () {
          Get.to(() => TaskScreen());
        },
      },
      {
        'title': 'Reports',
        'icon': Icons.analytics_outlined,
        'color': const Color(0xFF059669),
        'onTap': () => _showComingSoon('Analytics Reports'),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isTablet ? 6 : 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9),
      itemCount: quickActions.length,
      itemBuilder: (context, index) {
        final action = quickActions[index];
        return _buildEnhancedQuickActionCard(action);
      },
    );
  }

  Widget _buildEnhancedQuickActionCard(Map<String, dynamic> action) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: action['onTap'],
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: action['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    action['icon'],
                    color: action['color'],
                    size: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  action['title'],
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedLeadStatusSection(bool isTablet) {
    return Obx(() {
      if (dashboardController.isLoading.value) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isTablet ? 4 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isTablet ? 1.2 : 1.4,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return const LeadStatShimmer();
          },
        );
      }

      final aggregates =
          dashboardController.dashboardData.value.data?.aggregates;

      if (aggregates == null) {
        return const Center(child: Text('No data available'));
      }

      final leadStats = [
        {
          'title': 'Personal',
          'count': aggregates.personalLeads?.count?.toString() ?? '0',
          'amount': dashboardController.formatCurrency(
              aggregates.personalLeads?.totalAmount?.toString() ?? '0'),
          'icon': Icons.people_outline,
          'color': const Color(0xFF3B82F6),
        },
        {
          'title': 'Authorized',
          'count': aggregates.authorizedLeads?.count?.toString() ?? '0',
          'amount': dashboardController.formatCurrency(
              aggregates.authorizedLeads?.totalAmount?.toString() ?? '0'),
          'icon': Icons.verified_user,
          'color': const Color(0xFF10B981),
        },
        {
          'title': 'Login',
          'count': aggregates.loginLeads?.count?.toString() ?? '0',
          'amount': dashboardController.formatCurrency(
              aggregates.loginLeads?.totalAmount?.toString() ?? '0'),
          'icon': Icons.login,
          'color': const Color(0xFFF59E0B),
        },
        {
          'title': 'Approved',
          'count': aggregates.approvedLeads?.count?.toString() ?? '0',
          'amount': dashboardController.formatCurrency(
              aggregates.approvedLeads?.totalAmount?.toString() ?? '0'),
          'icon': Icons.check_circle,
          'color': const Color(0xFF059669),
        },
        {
          'title': 'Disbursed',
          'count': aggregates.disbursedLeads?.count?.toString() ?? '0',
          'amount': dashboardController.formatCurrency(
              aggregates.disbursedLeads?.totalAmount?.toString() ?? '0'),
          'icon': Icons.attach_money,
          'color': const Color(0xFF8B5CF6),
        },
        {
          'title': 'Rejected',
          'count': aggregates.rejectedLeads?.count?.toString() ?? '0',
          'amount': dashboardController.formatCurrency(
              aggregates.rejectedLeads?.totalAmount?.toString() ?? '0'),
          'icon': Icons.cancel_outlined,
          'color': const Color(0xFFDC2626),
        },
      ];

      return Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isTablet ? 4 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: isTablet ? 1.2 : 1.2,
            ),
            itemCount: leadStats.length,
            itemBuilder: (context, index) {
              final stat = leadStats[index];
              return _buildEnhancedLeadStatCard(stat);
            },
          ),
          // Credit Card Section
        ],
      );
    });
  }

  Widget _buildEnhancedLeadStatCard(Map<String, dynamic> stat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                stat['count'].toString().padLeft(2, '0'),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: stat['color'],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: stat['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  stat['icon'],
                  color: stat['color'],
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "${stat['title']} Leads",
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat['amount'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.history_rounded,
                  color: Color(0xFF10B981),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Recent Activities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildActivityItem(
            'Personal loan approved for ₹5L',
            '2 hours ago',
            Icons.check_circle_outline,
            const Color(0xFF10B981),
          ),
          _buildActivityItem(
            'New business loan application',
            '4 hours ago',
            Icons.business_center_outlined,
            const Color(0xFF3B82F6),
          ),
          _buildActivityItem(
            'Credit card disbursed',
            '1 day ago',
            Icons.credit_card_outlined,
            const Color(0xFF8B5CF6),
          ),
          _buildActivityItem(
            'Home loan documentation completed',
            '2 days ago',
            Icons.description_outlined,
            const Color(0xFFF59E0B),
          ),
          _buildActivityItem(
            'Customer meeting scheduled',
            '3 days ago',
            Icons.event_outlined,
            const Color(0xFFDC2626),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketInsights() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.insights_outlined,
                  color: Color(0xFF8B5CF6),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Market Insights',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInsightItem(
            'Interest Rates',
            'Personal loans down by 0.5%',
            Icons.trending_down,
            const Color(0xFF10B981),
          ),
          _buildInsightItem(
            'Market Demand',
            'Home loans up by 12%',
            Icons.trending_up,
            const Color(0xFF3B82F6),
          ),
          _buildInsightItem(
            'Credit Score',
            'Average score improved',
            Icons.credit_score,
            const Color(0xFF8B5CF6),
          ),
          _buildInsightItem(
            'Approval Rate',
            '85% success rate this month',
            Icons.check_circle,
            const Color(0xFFF59E0B),
          ),
          _buildInsightItem(
            'New Products',
            'Green loans now available',
            Icons.eco,
            const Color(0xFF059669),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
      String title, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(
      String title, String description, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildNotificationItem(
                    'New loan application received',
                    'Personal loan for ₹3L from John Doe',
                    '5 min ago',
                    Icons.notification_important,
                    const Color(0xFF3B82F6),
                  ),
                  _buildNotificationItem(
                    'Loan approved successfully',
                    'Business loan for ₹10L has been approved',
                    '1 hour ago',
                    Icons.check_circle,
                    const Color(0xFF10B981),
                  ),
                  _buildNotificationItem(
                    'Document verification pending',
                    'Home loan application needs documents',
                    '2 hours ago',
                    Icons.warning,
                    const Color(0xFFF59E0B),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String title, String description, String time,
      IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming Soon!'),
        backgroundColor: const Color(0xFF3B82F6),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  String _formatCurrency(dynamic amount) {
    if (amount == null) return '₹0';
    try {
      double value =
          amount is String ? double.parse(amount) : amount.toDouble();
      if (value >= 10000000) {
        return '₹${(value / 10000000).toStringAsFixed(1)}Cr';
      } else if (value >= 100000) {
        return '₹${(value / 100000).toStringAsFixed(1)}L';
      } else if (value >= 1000) {
        return '₹${(value / 1000).toStringAsFixed(1)}K';
      } else {
        return '₹${value.toStringAsFixed(0)}';
      }
    } catch (_) {
      return '₹0';
    }
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
