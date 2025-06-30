class FinanceDashboardData {
  final UserProfile user;
  final LeadStats leadStats;
  final List<QuickAction> quickActions;
  final List<LoanProduct> loanProducts;

  FinanceDashboardData({
    required this.user,
    required this.leadStats,
    required this.quickActions,
    required this.loanProducts,
  });

  factory FinanceDashboardData.fromJson(Map<String, dynamic> json) {
    return FinanceDashboardData(
      user: UserProfile.fromJson(json['user']),
      leadStats: LeadStats.fromJson(json['lead_stats']),
      quickActions: (json['quick_actions'] as List)
          .map((action) => QuickAction.fromJson(action))
          .toList(),
      loanProducts: (json['loan_products'] as List)
          .map((product) => LoanProduct.fromJson(product))
          .toList(),
    );
  }
}

class UserProfile {
  final String name;
  final String email;
  final String profileImage;
  final String designation;

  UserProfile({
    required this.name,
    required this.email,
    required this.profileImage,
    required this.designation,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      email: json['email'],
      profileImage: json['profile_image'],
      designation: json['designation'],
    );
  }
}

class LeadStats {
  final LeadCategory totalLeads;
  final LeadCategory approvedLeads;
  final LeadCategory disbursedLeads;
  final LeadCategory loginLeads;

  LeadStats({
    required this.totalLeads,
    required this.approvedLeads,
    required this.disbursedLeads,
    required this.loginLeads,
  });

  factory LeadStats.fromJson(Map<String, dynamic> json) {
    return LeadStats(
      totalLeads: LeadCategory.fromJson(json['total_leads']),
      approvedLeads: LeadCategory.fromJson(json['approved_leads']),
      disbursedLeads: LeadCategory.fromJson(json['disbursed_leads']),
      loginLeads: LeadCategory.fromJson(json['login_leads']),
    );
  }
}

class LeadCategory {
  final int count;
  final String amount;

  LeadCategory({
    required this.count,
    required this.amount,
  });

  factory LeadCategory.fromJson(Map<String, dynamic> json) {
    return LeadCategory(
      count: json['count'],
      amount: json['amount'].toString(),
    );
  }
}

class QuickAction {
  final String title;
  final String icon;
  final String route;
  final String color;

  QuickAction({
    required this.title,
    required this.icon,
    required this.route,
    required this.color,
  });

  factory QuickAction.fromJson(Map<String, dynamic> json) {
    return QuickAction(
      title: json['title'],
      icon: json['icon'],
      route: json['route'],
      color: json['color'],
    );
  }
}

class LoanProduct {
  final String title;
  final String subtitle;
  final String icon;
  final String route;
  final String color;
  final String interestRate;

  LoanProduct({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    required this.color,
    required this.interestRate,
  });

  factory LoanProduct.fromJson(Map<String, dynamic> json) {
    return LoanProduct(
      title: json['title'],
      subtitle: json['subtitle'],
      icon: json['icon'],
      route: json['route'],
      color: json['color'],
      interestRate: json['interest_rate'],
    );
  }
}
