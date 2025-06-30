class AttendanceStatus {
  String? status;
  String? message;
  String? buttonAction;
  String? checkInTime;
  String? checkOutTime;
  double? workedHours;

  AttendanceStatus(
      {this.status,
        this.message,
        this.buttonAction,
        this.checkInTime,
        this.checkOutTime,
        this.workedHours});

  AttendanceStatus.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    buttonAction = json['button_action'];
    checkInTime = json['check_in_time'];
    checkOutTime = json['check_out_time'];
    workedHours = json['worked_hours'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['button_action'] = this.buttonAction;
    data['check_in_time'] = this.checkInTime;
    data['check_out_time'] = this.checkOutTime;
    data['worked_hours'] = this.workedHours;
    return data;
  }
}