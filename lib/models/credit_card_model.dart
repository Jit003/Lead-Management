class Lead {
  final int id;
  final int employeeId;
  final int teamLeadId;
  final String name;
  final String phone;
  final String email;
  final String? dob;
  final String? location;
  final String? companyName;
  final String? leadAmount;
  final String? salary;
  final String? successPercentage;
  final String? expectedMonth;
  final String? remarks;
  final String status;
  final bool isPersonalLead;
  final String? turnoverAmount;
  final String? vintageYear;
  final String bankName;
  final String leadType;
  final String? voiceRecording;
  final String createdAt;
  final String updatedAt;
  final Employee employee;
  final TeamLead teamLead;
  final List<History> histories;

  Lead({
    required this.id,
    required this.employeeId,
    required this.teamLeadId,
    required this.name,
    required this.phone,
    required this.email,
    this.dob,
    this.location,
    this.companyName,
    this.leadAmount,
    this.salary,
    this.successPercentage,
    this.expectedMonth,
    this.remarks,
    required this.status,
    required this.isPersonalLead,
    this.turnoverAmount,
    this.vintageYear,
    required this.bankName,
    required this.leadType,
    this.voiceRecording,
    required this.createdAt,
    required this.updatedAt,
    required this.employee,
    required this.teamLead,
    required this.histories,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      employeeId: json['employee_id'] is int ? json['employee_id'] : int.tryParse(json['employee_id'].toString()) ?? 0,
      teamLeadId: json['team_lead_id'] is int ? json['team_lead_id'] : int.tryParse(json['team_lead_id'].toString()) ?? 0,
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      dob: json['dob'],
      location: json['location'],
      companyName: json['company_name'],
      leadAmount: json['lead_amount']?.toString(),
      salary: json['salary']?.toString(),
      successPercentage: json['success_percentage']?.toString(),
      expectedMonth: json['expected_month'],
      remarks: json['remarks'],
      status: json['status'],
      isPersonalLead: json['is_personal_lead'] ?? false,
      turnoverAmount: json['turnover_amount']?.toString(),
      vintageYear: json['vintage_year']?.toString(),
      bankName: json['bank_name'] ?? '',
      leadType: json['lead_type'],
      voiceRecording: json['voice_recording'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      employee: json['employee'] != null
          ? Employee.fromJson(json['employee'])
          : Employee(
        id: 0,
        name: '',
        email: '',
        phone: '',
        designation: '',
        department: '',
        profilePhoto: null,
        address: '',
      ),
      teamLead: json['team_lead'] != null
          ? TeamLead.fromJson(json['team_lead'])
          : TeamLead(
        id: 0,
        name: '',
        email: '',
        phone: '',
        designation: '',
        department: '',
        profilePhoto: null,
        address: '',
      ),
      histories: (json['histories'] as List?)?.map((history) => History.fromJson(history)).toList() ?? [],
    );
  }
}

class Employee {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String designation;
  final String department;
  final String? profilePhoto;
  final String address;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.designation,
    required this.department,
    this.profilePhoto,
    required this.address,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      designation: json['designation'],
      department: json['department'] ?? '',
      profilePhoto: json['profile_photo'],
      address: json['address'] ?? '',
    );
  }
}

class TeamLead {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String designation;
  final String department;
  final String? profilePhoto;
  final String? address;

  TeamLead({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.designation,
    required this.department,
    this.profilePhoto,
    this.address,
  });

  factory TeamLead.fromJson(Map<String, dynamic> json) {
    return TeamLead(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      designation: json['designation'],
      department: json['department'] ?? '',
      profilePhoto: json['profile_photo'],
      address: json['address'],
    );
  }
}

class History {
  final int id;
  final int leadId;
  final int userId;
  final String action;
  final String status;
  final int? forwardedTo;
  final String comments;
  final String createdAt;
  final String updatedAt;

  History({
    required this.id,
    required this.leadId,
    required this.userId,
    required this.action,
    required this.status,
    this.forwardedTo,
    required this.comments,
    required this.createdAt,
    required this.updatedAt,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'],
      leadId: json['lead_id'],
      userId: json['user_id'],
      action: json['action'],
      status: json['status'],
      forwardedTo: json['forwarded_to'],
      comments: json['comments'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class LeadsResponse {
  final String status;
  final String message;
  final LeadsData data;

  LeadsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LeadsResponse.fromJson(Map<String, dynamic> json) {
    return LeadsResponse(
      status: json['status'],
      message: json['message'],
      data: LeadsData.fromJson(json['data']),
    );
  }
}

class LeadsData {
  final List<Lead> leads;

  LeadsData({required this.leads});

  factory LeadsData.fromJson(Map<String, dynamic> json) {
    return LeadsData(
      leads: (json['leads'] as List)
          .map((lead) => Lead.fromJson(lead))
          .toList(),
    );
  }
}