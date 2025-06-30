class SalarySlipModel {
  String? status;
  List<Data>? data;

  SalarySlipModel({this.status, this.data});

  SalarySlipModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  String? month;
  String? basic;
  String? hra;
  String? allowance;
  String? deductions;
  String? netSalary;
  Null? pdfPath;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.userId,
        this.month,
        this.basic,
        this.hra,
        this.allowance,
        this.deductions,
        this.netSalary,
        this.pdfPath,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    month = json['month'];
    basic = json['basic'];
    hra = json['hra'];
    allowance = json['allowance'];
    deductions = json['deductions'];
    netSalary = json['net_salary'];
    pdfPath = json['pdf_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['month'] = this.month;
    data['basic'] = this.basic;
    data['hra'] = this.hra;
    data['allowance'] = this.allowance;
    data['deductions'] = this.deductions;
    data['net_salary'] = this.netSalary;
    data['pdf_path'] = this.pdfPath;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}