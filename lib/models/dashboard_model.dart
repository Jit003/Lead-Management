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
  TotalLeads? futureLeads;
  CreditcardStatistics? creditcardStatistics;
  List<AllLeads>? allLeads;
  FiltersApplied? filtersApplied;

  Data(
      {this.user,
        this.aggregates,
        this.futureLeads,
        this.creditcardStatistics,
        this.allLeads,
        this.filtersApplied});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    aggregates = json['aggregates'] != null
        ? new Aggregates.fromJson(json['aggregates'])
        : null;
    futureLeads = json['future_leads'] != null
        ? new TotalLeads.fromJson(json['future_leads'])
        : null;
    creditcardStatistics = json['creditcard_statistics'] != null
        ? new CreditcardStatistics.fromJson(json['creditcard_statistics'])
        : null;
    if (json['all_leads'] != null) {
      allLeads = <AllLeads>[];
      json['all_leads'].forEach((v) {
        allLeads!.add(new AllLeads.fromJson(v));
      });
    }
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
    if (this.futureLeads != null) {
      data['future_leads'] = this.futureLeads!.toJson();
    }
    if (this.creditcardStatistics != null) {
      data['creditcard_statistics'] = this.creditcardStatistics!.toJson();
    }
    if (this.allLeads != null) {
      data['all_leads'] = this.allLeads!.map((v) => v.toJson()).toList();
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
  TotalLeads? personalLoan;
  TotalLeads? businessLoan;
  TotalLeads? homeLoan;
  TotalLeads? personalLeads;
  TotalLeads? authorizedLeads;
  TotalLeads? loginLeads;
  TotalLeads? approvedLeads;
  TotalLeads? disbursedLeads;
  TotalLeads? rejectedLeads;

  Aggregates(
      {this.totalLeads,
        this.personalLoan,
        this.businessLoan,
        this.homeLoan,
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
    personalLoan = json['personal_loan'] != null
        ? new TotalLeads.fromJson(json['personal_loan'])
        : null;
    businessLoan = json['business_loan'] != null
        ? new TotalLeads.fromJson(json['business_loan'])
        : null;
    homeLoan = json['home_loan'] != null
        ? new TotalLeads.fromJson(json['home_loan'])
        : null;
    personalLeads = json['personal_leads'] != null
        ? new TotalLeads.fromJson(json['personal_leads'])
        : null;
    authorizedLeads = json['authorized_leads'] != null
        ? new TotalLeads.fromJson(json['authorized_leads'])
        : null;
    loginLeads = json['login_leads'] != null
        ? new TotalLeads.fromJson(json['login_leads'])
        : null;
    approvedLeads = json['approved_leads'] != null
        ? new TotalLeads.fromJson(json['approved_leads'])
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
    if (this.personalLoan != null) {
      data['personal_loan'] = this.personalLoan!.toJson();
    }
    if (this.businessLoan != null) {
      data['business_loan'] = this.businessLoan!.toJson();
    }
    if (this.homeLoan != null) {
      data['home_loan'] = this.homeLoan!.toJson();
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
  String? totalAmount;

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

class CreditcardStatistics {
  Ongoing? ongoing;
  Ongoing? approved;
  Ongoing? rejected;
  Ongoing? future;

  CreditcardStatistics(
      {this.ongoing, this.approved, this.rejected, this.future});

  CreditcardStatistics.fromJson(Map<String, dynamic> json) {
    ongoing =
    json['ongoing'] != null ? new Ongoing.fromJson(json['ongoing']) : null;
    approved = json['approved'] != null
        ? new Ongoing.fromJson(json['approved'])
        : null;
    rejected = json['rejected'] != null
        ? new Ongoing.fromJson(json['rejected'])
        : null;
    future =
    json['future'] != null ? new Ongoing.fromJson(json['future']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ongoing != null) {
      data['ongoing'] = this.ongoing!.toJson();
    }
    if (this.approved != null) {
      data['approved'] = this.approved!.toJson();
    }
    if (this.rejected != null) {
      data['rejected'] = this.rejected!.toJson();
    }
    if (this.future != null) {
      data['future'] = this.future!.toJson();
    }
    return data;
  }
}

class Ongoing {
  int? count;

  Ongoing({this.count});

  Ongoing.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    return data;
  }
}

class AllLeads {
  int? id;
  String? name;
  String? leadType;
  String? leadAmount;
  String? status;
  String? expectedMonth;
  String? createdAt;
  String? location;
  Employee? employee;

  AllLeads(
      {this.id,
        this.name,
        this.leadType,
        this.leadAmount,
        this.status,
        this.expectedMonth,
        this.createdAt,
        this.location,
        this.employee});

  AllLeads.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    leadType = json['lead_type'];
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
    data['lead_type'] = this.leadType;
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

class FiltersApplied {
  String? leadType;
  String? status;
  int? year;
  String? expectedMonth;

  FiltersApplied({this.leadType, this.status, this.year, this.expectedMonth});

  FiltersApplied.fromJson(Map<String, dynamic> json) {
    leadType = json['lead_type'];
    status = json['status'];
    year = json['year'];
    expectedMonth = json['expected_month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lead_type'] = this.leadType;
    data['status'] = this.status;
    data['year'] = this.year;
    data['expected_month'] = this.expectedMonth;
    return data;
  }
}