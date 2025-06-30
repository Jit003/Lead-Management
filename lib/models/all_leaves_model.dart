class AllLeavesModel {
  String? status;
  List<Leaves>? leaves;

  AllLeavesModel({this.status, this.leaves});

  AllLeavesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['leaves'] != null) {
      leaves = <Leaves>[];
      json['leaves'].forEach((v) {
        leaves!.add(new Leaves.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.leaves != null) {
      data['leaves'] = this.leaves!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Leaves {
  int? id;
  int? userId;
  String? leaveType;
  String? startDate;
  String? endDate;
  String? reason;
  String? status;
  int? appliedTo;
  int? totalDays;
  String? createdAt;
  String? updatedAt;

  Leaves(
      {this.id,
        this.userId,
        this.leaveType,
        this.startDate,
        this.endDate,
        this.reason,
        this.status,
        this.appliedTo,
        this.totalDays,
        this.createdAt,
        this.updatedAt});

  Leaves.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    leaveType = json['leave_type'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    reason = json['reason'];
    status = json['status'];
    appliedTo = json['applied_to'];
    totalDays = json['total_days'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['leave_type'] = this.leaveType;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['reason'] = this.reason;
    data['status'] = this.status;
    data['applied_to'] = this.appliedTo;
    data['total_days'] = this.totalDays;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}