class ApplyLeaveResponse {
  String? status;
  String? message;
  Data? data;

  ApplyLeaveResponse({this.status, this.message, this.data});

  ApplyLeaveResponse.fromJson(Map<String, dynamic> json) {
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
  int? userId;
  String? leaveType;
  String? startDate;
  String? endDate;
  int? totalDays;
  String? reason;
  int? appliedTo;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.userId,
        this.leaveType,
        this.startDate,
        this.endDate,
        this.totalDays,
        this.reason,
        this.appliedTo,
        this.updatedAt,
        this.createdAt,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    leaveType = json['leave_type'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    totalDays = json['total_days'];
    reason = json['reason'];
    appliedTo = json['applied_to'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['leave_type'] = this.leaveType;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['total_days'] = this.totalDays;
    data['reason'] = this.reason;
    data['applied_to'] = this.appliedTo;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}