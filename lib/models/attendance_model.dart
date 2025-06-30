class AttendanceRecord {
  final int? id;
  final int? employeeId;
  final String? date;
  final String? checkIn;
  final String? checkOut;
  final String? checkInLocation;
  final String? checkOutLocation;
  final String? checkInCoordinates;
  final String? checkOutCoordinates;
  final String? checkinImage;
  final String? checkoutImage;
  final String? notes;
  final String? reason;
  final String? lastLocationUpdate;
  final bool? isWithinGeofence;
  final String? createdAt;
  final String? updatedAt;

  AttendanceRecord({
    this.id,
    this.employeeId,
    this.date,
    this.checkIn,
    this.checkOut,
    this.checkInLocation,
    this.checkOutLocation,
    this.checkInCoordinates,
    this.checkOutCoordinates,
    this.checkinImage,
    this.checkoutImage,
    this.notes,
    this.reason,
    this.lastLocationUpdate,
    this.isWithinGeofence,
    this.createdAt,
    this.updatedAt,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: _parseInt(json['id']),
      employeeId: _parseInt(json['employee_id']),
      date: json['date']?.toString(),
      checkIn: json['check_in']?.toString() ?? json['checkIn']?.toString(),
      checkOut: json['check_out']?.toString() ?? json['checkOut']?.toString(),
      checkInLocation: json['check_in_location']?.toString() ??
          json['checkInLocation']?.toString(),
      checkOutLocation: json['check_out_location']?.toString() ??
          json['checkOutLocation']?.toString(),
      checkInCoordinates: json['check_in_coordinates']?.toString() ??
          json['checkInCoordinates']?.toString(),
      checkOutCoordinates: json['check_out_coordinates']?.toString() ??
          json['checkOutCoordinates']?.toString(),
      checkinImage:
          json['checkin_image']?.toString() ?? json['checkInImage']?.toString(),
      checkoutImage: json['checkout_image']?.toString() ??
          json['checkOutImage']?.toString(),
      notes: json['notes']?.toString(),
      reason: json['reason']?.toString(),
      lastLocationUpdate: json['last_location_update']?.toString(),
      isWithinGeofence: json['is_within_geofence'] is bool
          ? json['is_within_geofence']
          : json['isWithinGeofence'] is bool
              ? json['isWithinGeofence']
              : null,
      createdAt:
          json['created_at']?.toString() ?? json['createdAt']?.toString(),
      updatedAt:
          json['updated_at']?.toString() ?? json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'date': date,
      'check_in': checkIn,
      'check_out': checkOut,
      'check_in_location': checkInLocation,
      'check_out_location': checkOutLocation,
      'check_in_coordinates': checkInCoordinates,
      'check_out_coordinates': checkOutCoordinates,
      'checkin_image': checkinImage,
      'checkout_image': checkoutImage,
      'notes': notes,
      'reason': reason,
      'last_location_update': lastLocationUpdate,
      'is_within_geofence': isWithinGeofence,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  AttendanceRecord copyWith({
    int? id,
    int? employeeId,
    String? date,
    String? checkIn,
    String? checkOut,
    String? checkInLocation,
    String? checkOutLocation,
    String? checkInCoordinates,
    String? checkOutCoordinates,
    String? checkinImage,
    String? checkoutImage,
    String? notes,
    String? reason,
    String? lastLocationUpdate,
    bool? isWithinGeofence,
    String? createdAt,
    String? updatedAt,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      date: date ?? this.date,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      checkInLocation: checkInLocation ?? this.checkInLocation,
      checkOutLocation: checkOutLocation ?? this.checkOutLocation,
      checkInCoordinates: checkInCoordinates ?? this.checkInCoordinates,
      checkOutCoordinates: checkOutCoordinates ?? this.checkOutCoordinates,
      checkinImage: checkinImage ?? this.checkinImage,
      checkoutImage: checkoutImage ?? this.checkoutImage,
      notes: notes ?? this.notes,
      reason: reason ?? this.reason,
      lastLocationUpdate: lastLocationUpdate ?? this.lastLocationUpdate,
      isWithinGeofence: isWithinGeofence ?? this.isWithinGeofence,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AttendanceResponse {
  final String status;
  final String message;
  final String? buttonAction;
  final AttendanceRecord? data;

  AttendanceResponse({
    required this.status,
    required this.message,
    this.buttonAction,
    this.data,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      status: json['status']?.toString() ?? 'error',
      message: json['message']?.toString() ?? 'Unknown error',
      buttonAction: json['button_action']?.toString(),
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? AttendanceRecord.fromJson(json['data'])
          : null,
    );
  }

  @override
  String toString() {
    return 'AttendanceResponse(status: $status, message: $message, buttonAction: $buttonAction, data: $data)';
  }
}

class AttendanceStatusResponse {
  final String status;
  late final String message;
  final String buttonAction;
  final String? checkInTime;
  final String? checkOutTime;
  final int workedHours;
  final double? latitude;
  final double? longitude;
  final bool? isWithinGeofence;

  AttendanceStatusResponse({
    required this.status,
    required this.message,
    required this.buttonAction,
    this.checkInTime,
    this.checkOutTime,
    required this.workedHours,
    this.latitude,
    this.longitude,
    this.isWithinGeofence,
  });

  factory AttendanceStatusResponse.fromJson(Map<String, dynamic> json) {
    double? lat;
    double? lng;
    if (json['check_in_coordinates'] is String &&
        json['check_in_coordinates'].contains(',')) {
      final coords = json['check_in_coordinates'].split(',');
      lat = coords.isNotEmpty ? double.tryParse(coords[0].trim()) : null;
      lng = coords.length > 1 ? double.tryParse(coords[1].trim()) : null;
    } else {
      lat = (json['latitude'] is int
              ? json['latitude'].toDouble()
              : json['latitude']) ??
          null;
      lng = (json['longitude'] is int
              ? json['longitude'].toDouble()
              : json['longitude']) ??
          null;
    }

    return AttendanceStatusResponse(
      status: json['status']?.toString() ?? 'error',
      message: json['message']?.toString() ?? 'Unknown error',
      buttonAction: json['button_action']?.toString() ?? 'checkin',
      checkInTime: json['check_in_time']?.toString() ??
          json['checkInTime']?.toString() ??
          json['check_in']?.toString(),
      checkOutTime: json['check_out_time']?.toString() ??
          json['checkOutTime']?.toString() ??
          json['check_out']?.toString(),
      workedHours: _parseInt(json['worked_hours']) ?? 0,
      latitude: lat,
      longitude: lng,
      isWithinGeofence: json['is_within_geofence'] is bool
          ? json['is_within_geofence']
          : json['isWithinGeofence'] is bool
              ? json['isWithinGeofence']
              : null,
    );
  }

  @override
  String toString() {
    return 'AttendanceStatusResponse(status: $status, message: $message, buttonAction: $buttonAction, checkInTime: $checkInTime, checkOutTime: $checkOutTime, workedHours: $workedHours, latitude: $latitude, longitude: $longitude, isWithinGeofence: $isWithinGeofence)';
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class GeofenceSettingsResponse {
  final String status;
  final String buttonAction;
  final GeofenceData? data;

  GeofenceSettingsResponse({
    required this.status,
    required this.buttonAction,
    this.data,
  });

  factory GeofenceSettingsResponse.fromJson(Map<String, dynamic> json) {
    return GeofenceSettingsResponse(
      status: json['status']?.toString() ?? 'error',
      buttonAction: json['button_action']?.toString() ?? 'none',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? GeofenceData.fromJson(json['data'])
          : null,
    );
  }

  @override
  String toString() {
    return 'GeofenceSettingsResponse(status: $status, buttonAction: $buttonAction, data: $data)';
  }
}

class GeofenceData {
  final String officeName;
  final double latitude;
  final double longitude;
  final double radius;

  var isWithinGeofence;

  GeofenceData({
    required this.officeName,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  factory GeofenceData.fromJson(Map<String, dynamic> json) {
    return GeofenceData(
      officeName: json['office_name']?.toString() ?? '',
      latitude: (json['latitude'] is int
              ? json['latitude'].toDouble()
              : json['latitude']) ??
          0.0,
      longitude: (json['longitude'] is int
              ? json['longitude'].toDouble()
              : json['longitude']) ??
          0.0,
      radius: (json['radius'] is int
              ? json['radius'].toDouble()
              : json['radius']) ??
          0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'office_name': officeName,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
    };
  }
}

class AttendanceLocationResponse {
  final String? currentCoordinates;
  final String? currentLocation;
  final double? latitude;
  final double? longitude;

  AttendanceLocationResponse({
    this.currentCoordinates,
    this.currentLocation,
    this.latitude,
    this.longitude,
  });

  factory AttendanceLocationResponse.fromJson(Map<String, dynamic> json) {
    double? lat;
    double? lng;
    if (json['current_coordinates'] is String &&
        json['current_coordinates'].contains(',')) {
      final coords = json['current_coordinates'].split(',');
      lat = coords.isNotEmpty ? double.tryParse(coords[0].trim()) : null;
      lng = coords.length > 1 ? double.tryParse(coords[1].trim()) : null;
    }

    return AttendanceLocationResponse(
      currentCoordinates: json['current_coordinates']?.toString(),
      currentLocation: json['current_location']?.toString(),
      latitude: lat,
      longitude: lng,
    );
  }

  @override
  String toString() {
    return 'AttendanceLocationResponse(currentCoordinates: $currentCoordinates, currentLocation: $currentLocation, latitude: $latitude, longitude: $longitude)';
  }
}
