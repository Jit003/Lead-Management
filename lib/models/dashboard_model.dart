class DashboardModel {
  String? status;
  String? message;
  Data? data;

  DashboardModel({this.status, this.message, this.data});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  User? user;
  Aggregates? aggregates;
  LeadTypeBreakdown? leadTypeBreakdown;
  AuthorizedLeads? futureLeads;
  FiltersApplied? filtersApplied;

  Data(
      {this.user,
        this.aggregates,
        this.leadTypeBreakdown,
        this.futureLeads,
        this.filtersApplied});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    aggregates = json['aggregates'] != null
        ? new Aggregates.fromJson(json['aggregates'])
        : null;
    leadTypeBreakdown = json['lead_type_breakdown'] != null
        ? new LeadTypeBreakdown.fromJson(json['lead_type_breakdown'])
        : null;
    futureLeads = json['future_leads'] != null
        ? new AuthorizedLeads.fromJson(json['future_leads'])
        : null;
    filtersApplied = json['filters_applied'] != null
        ? new FiltersApplied.fromJson(json['filters_applied'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.aggregates != null) {
      data['aggregates'] = this.aggregates!.toJson();
    }
    if (this.leadTypeBreakdown != null) {
      data['lead_type_breakdown'] = this.leadTypeBreakdown!.toJson();
    }
    if (this.futureLeads != null) {
      data['future_leads'] = this.futureLeads!.toJson();
    }
    if (this.filtersApplied != null) {
      data['filters_applied'] = this.filtersApplied!.toJson();
    }
    return data;
  }
}

class User {
  String? name;
  String? designation;

  User({this.name, this.designation});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    designation = json['designation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['designation'] = this.designation;
    return data;
  }
}

class Aggregates {
  TotalLeads? totalLeads;
  TotalLeads? personalLeads;
  AuthorizedLeads? authorizedLeads;
  AuthorizedLeads? loginLeads;
  AuthorizedLeads? approvedLeads;
  TotalLeads? disbursedLeads;
  TotalLeads? rejectedLeads;

  Aggregates(
      {this.totalLeads,
        this.personalLeads,
        this.authorizedLeads,
        this.loginLeads,
        this.approvedLeads,
        this.disbursedLeads,
        this.rejectedLeads});

  Aggregates.fromJson(Map<String, dynamic> json) {
    totalLeads = json['total_leads'] != null
        ? new TotalLeads.fromJson(json['total_leads'])
        : null;
    personalLeads = json['personal_leads'] != null
        ? new TotalLeads.fromJson(json['personal_leads'])
        : null;
    authorizedLeads = json['authorized_leads'] != null
        ? new AuthorizedLeads.fromJson(json['authorized_leads'])
        : null;
    loginLeads = json['login_leads'] != null
        ? new AuthorizedLeads.fromJson(json['login_leads'])
        : null;
    approvedLeads = json['approved_leads'] != null
        ? new AuthorizedLeads.fromJson(json['approved_leads'])
        : null;
    disbursedLeads = json['disbursed_leads'] != null
        ? new TotalLeads.fromJson(json['disbursed_leads'])
        : null;
    rejectedLeads = json['rejected_leads'] != null
        ? new TotalLeads.fromJson(json['rejected_leads'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.totalLeads != null) {
      data['total_leads'] = this.totalLeads!.toJson();
    }
    if (this.personalLeads != null) {
      data['personal_leads'] = this.personalLeads!.toJson();
    }
    if (this.authorizedLeads != null) {
      data['authorized_leads'] = this.authorizedLeads!.toJson();
    }
    if (this.loginLeads != null) {
      data['login_leads'] = this.loginLeads!.toJson();
    }
    if (this.approvedLeads != null) {
      data['approved_leads'] = this.approvedLeads!.toJson();
    }
    if (this.disbursedLeads != null) {
      data['disbursed_leads'] = this.disbursedLeads!.toJson();
    }
    if (this.rejectedLeads != null) {
      data['rejected_leads'] = this.rejectedLeads!.toJson();
    }
    return data;
  }
}

class TotalLeads {
  int? count;
  dynamic totalAmount;

  TotalLeads({this.count, this.totalAmount});

  TotalLeads.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['total_amount'] = this.totalAmount;
    return data;
  }
}

class AuthorizedLeads {
  int? count;
  dynamic totalAmount;

  AuthorizedLeads({this.count, this.totalAmount});

  AuthorizedLeads.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['total_amount'] = this.totalAmount;
    return data;
  }
}

class LeadTypeBreakdown {
  PersonalLoan? personalLoan;
  BusinessLoan? businessLoan;
  PersonalLoan? homeLoan;
  CreditcardLoan? creditcardLoan;

  LeadTypeBreakdown(
      {this.personalLoan,
        this.businessLoan,
        this.homeLoan,
        this.creditcardLoan});

  LeadTypeBreakdown.fromJson(Map<String, dynamic> json) {
    personalLoan = json['personal_loan'] != null
        ? new PersonalLoan.fromJson(json['personal_loan'])
        : null;
    businessLoan = json['business_loan'] != null
        ? new BusinessLoan.fromJson(json['business_loan'])
        : null;
    homeLoan = json['home_loan'] != null
        ? new PersonalLoan.fromJson(json['home_loan'])
        : null;
    creditcardLoan = json['creditcard_loan'] != null
        ? new CreditcardLoan.fromJson(json['creditcard_loan'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.personalLoan != null) {
      data['personal_loan'] = this.personalLoan!.toJson();
    }
    if (this.businessLoan != null) {
      data['business_loan'] = this.businessLoan!.toJson();
    }
    if (this.homeLoan != null) {
      data['home_loan'] = this.homeLoan!.toJson();
    }
    if (this.creditcardLoan != null) {
      data['creditcard_loan'] = this.creditcardLoan!.toJson();
    }
    return data;
  }
}

class PersonalLoan {
  int? count;
  dynamic totalAmount;
  List<Leads>? leads;

  PersonalLoan({this.count, this.totalAmount, this.leads});

  PersonalLoan.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    totalAmount = json['total_amount'];
    if (json['leads'] != null) {
      leads = <Leads>[];
      json['leads'].forEach((v) {
        leads!.add(new Leads.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['total_amount'] = this.totalAmount;
    if (this.leads != null) {
      data['leads'] = this.leads!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Leads {
  int? id;
  String? name;
  String? leadAmount;
  String? status;
  String? expectedMonth;
  String? createdAt;
  String? location;
  Employee? employee;

  Leads(
      {this.id,
        this.name,
        this.leadAmount,
        this.status,
        this.expectedMonth,
        this.createdAt,
        this.location,
        this.employee});

  Leads.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    leadAmount = json['lead_amount'];
    status = json['status'];
    expectedMonth = json['expected_month'];
    createdAt = json['created_at'];
    location = json['location'];
    employee = json['employee'] != null
        ? new Employee.fromJson(json['employee'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['lead_amount'] = this.leadAmount;
    data['status'] = this.status;
    data['expected_month'] = this.expectedMonth;
    data['created_at'] = this.createdAt;
    data['location'] = this.location;
    if (this.employee != null) {
      data['employee'] = this.employee!.toJson();
    }
    return data;
  }
}

class Employee {
  String? name;
  String? profilePhotoUrl;
  String? panCardUrl;
  String? aadharCardUrl;
  String? signatureUrl;

  Employee(
      {this.name,
        this.profilePhotoUrl,
        this.panCardUrl,
        this.aadharCardUrl,
        this.signatureUrl});

  Employee.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profilePhotoUrl = json['profile_photo_url'];
    panCardUrl = json['pan_card_url'];
    aadharCardUrl = json['aadhar_card_url'];
    signatureUrl = json['signature_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['profile_photo_url'] = this.profilePhotoUrl;
    data['pan_card_url'] = this.panCardUrl;
    data['aadhar_card_url'] = this.aadharCardUrl;
    data['signature_url'] = this.signatureUrl;
    return data;
  }
}

class BusinessLoan {
  int? count;
  dynamic totalAmount;
  List<Leads>? leads; // ✅ Change here

  BusinessLoan({this.count, this.totalAmount, this.leads});

  BusinessLoan.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    totalAmount = json['total_amount'];
    if (json['leads'] != null) {
      leads = <Leads>[];
      json['leads'].forEach((v) {
        leads!.add(Leads.fromJson(v)); // ✅ Correct usage
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['total_amount'] = totalAmount;
    if (leads != null) {
      data['leads'] = leads!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class CreditcardLoan {
  AuthorizedLeads? applied;
  AuthorizedLeads? approved;
  AuthorizedLeads? rejected;

  CreditcardLoan({this.applied, this.approved, this.rejected});

  CreditcardLoan.fromJson(Map<String, dynamic> json) {
    applied = json['applied'] != null
        ? new AuthorizedLeads.fromJson(json['applied'])
        : null;
    approved = json['approved'] != null
        ? new AuthorizedLeads.fromJson(json['approved'])
        : null;
    rejected = json['rejected'] != null
        ? new AuthorizedLeads.fromJson(json['rejected'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.applied != null) {
      data['applied'] = this.applied!.toJson();
    }
    if (this.approved != null) {
      data['approved'] = this.approved!.toJson();
    }
    if (this.rejected != null) {
      data['rejected'] = this.rejected!.toJson();
    }
    return data;
  }
}

class FiltersApplied {
  String? leadType;
  String? status;
  String? dateFilter;
  String? startDate;
  String? endDate;
  String? expectedMonth;

  FiltersApplied(
      {this.leadType,
        this.status,
        this.dateFilter,
        this.startDate,
        this.endDate,
        this.expectedMonth});

  FiltersApplied.fromJson(Map<String, dynamic> json) {
    leadType = json['lead_type'];
    status = json['status'];
    dateFilter = json['date_filter'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    expectedMonth = json['expected_month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lead_type'] = this.leadType;
    data['status'] = this.status;
    data['date_filter'] = this.dateFilter;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['expected_month'] = this.expectedMonth;
    return data;
  }
}