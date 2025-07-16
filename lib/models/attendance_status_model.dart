class AttendanceStatus {
  String? status;
  String? message;
  String? buttonAction;
  String? checkInTime;
  String? checkOutTime;
  double? workedHours;
  int? attendanceId; // 👈 ADD THIS


  AttendanceStatus({
    this.status,
    this.message,
    this.buttonAction,
    this.checkInTime,
    this.checkOutTime,
    this.workedHours,
    this.attendanceId,

  });

  AttendanceStatus.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    buttonAction = json['button_action'];
    checkInTime = json['check_in_time'];
    checkOutTime = json['check_out_time'];

    // ✅ Safely handle both int and double
    workedHours = json['worked_hours'] != null
        ? (json['worked_hours'] as num).toDouble()
        : null;
    attendanceId = json['attendance_id']; // 👈 HERE

  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'button_action': buttonAction,
      'check_in_time': checkInTime,
      'check_out_time': checkOutTime,
      'worked_hours': workedHours,
    };
  }
}
