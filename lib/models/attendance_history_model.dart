class AttendanceHistoryResponse {
  final String status;
  final AttendanceSummary summary;
  final List<AttendanceRecord> records;

  AttendanceHistoryResponse({
    required this.status,
    required this.summary,
    required this.records,
  });

  factory AttendanceHistoryResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceHistoryResponse(
      status: json['status'],
      summary: AttendanceSummary.fromJson(json['summary']),
      records: (json['records'] as List)
          .map((record) => AttendanceRecord.fromJson(record))
          .toList(),
    );
  }
}

class AttendanceSummary {
  final int? totalDays;
  final int? present;
  final int? absent;
  final String? todayCheckIn;
  final String? todayCheckOut;
  final String? workingHoursToday;

  AttendanceSummary({
    required this.totalDays,
    required this.present,
    required this.absent,
    this.todayCheckIn,
    this.todayCheckOut,
    this.workingHoursToday,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      totalDays: json['total_days'],
      present: json['present'],
      absent: json['absent'],
      todayCheckIn: json['today_check_in']?.toString(),
      todayCheckOut: json['today_check_out']?.toString(),
      workingHoursToday: json['working_hours_today']?.toString(),
    );
  }
}

class AttendanceRecord {
  final String employeeName;
  final String date;
  final String checkIn;
  final String? checkOut;
  final String checkInLocation;
  final String? checkOutLocation;
  final String checkInCoordinates;
  final String? checkOutCoordinates;
  final String notes;
  final String checkinImage;
  final String? checkoutImage;
  final String? workedHours;

  AttendanceRecord({
    required this.employeeName,
    required this.date,
    required this.checkIn,
    this.checkOut,
    required this.checkInLocation,
    this.checkOutLocation,
    required this.checkInCoordinates,
    this.checkOutCoordinates,
    required this.notes,
    required this.checkinImage,
    this.checkoutImage,
    this.workedHours,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      employeeName: json['employee_name']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      checkIn: json['check_in']?.toString() ?? '',
      checkOut: json['check_out']?.toString(),
      checkInLocation: json['check_in_location']?.toString() ?? '',
      checkOutLocation: json['check_out_location']?.toString(),
      checkInCoordinates: json['check_in_coordinates']?.toString() ?? '',
      checkOutCoordinates: json['check_out_coordinates']?.toString(),
      notes: json['notes']?.toString() ?? '',
      checkinImage: json['checkin_image']?.toString() ?? '',
      checkoutImage: json['checkout_image']?.toString(),
      workedHours: json['worked_hours']?.toString(),
    );
  }
}