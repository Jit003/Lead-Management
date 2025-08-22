class OffersModel {
  String? status;
  String? message;
  Data? data;

  OffersModel({this.status, this.message, this.data});

  OffersModel.fromJson(Map<String, dynamic> json) {
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
  List<Offers>? offers;
  FiltersApplied? filtersApplied;

  Data({this.offers, this.filtersApplied});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['offers'] != null) {
      offers = <Offers>[];
      json['offers'].forEach((v) {
        offers!.add(new Offers.fromJson(v));
      });
    }
    filtersApplied = json['filters_applied'] != null
        ? new FiltersApplied.fromJson(json['filters_applied'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.offers != null) {
      data['offers'] = this.offers!.map((v) => v.toJson()).toList();
    }
    if (this.filtersApplied != null) {
      data['filters_applied'] = this.filtersApplied!.toJson();
    }
    return data;
  }
}

class Offers {
  int? id;
  String? title;
  String? description;
  List<String>? attachment;
  Sender? sender;
  String? createdAt;
  String? updatedAt;

  Offers(
      {this.id,
        this.title,
        this.description,
        this.attachment,
        this.sender,
        this.createdAt,
        this.updatedAt});

  Offers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    attachment = json['attachment'].cast<String>();
    sender =
    json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['attachment'] = this.attachment;
    if (this.sender != null) {
      data['sender'] = this.sender!.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Sender {
  int? id;
  String? name;
  String? email;

  Sender({this.id, this.name, this.email});

  Sender.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    return data;
  }
}

class FiltersApplied {
  String? filter;
  String? startDate;
  String? endDate;

  FiltersApplied({this.filter, this.startDate, this.endDate});

  FiltersApplied.fromJson(Map<String, dynamic> json) {
    filter = json['filter'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filter'] = this.filter;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    return data;
  }
}