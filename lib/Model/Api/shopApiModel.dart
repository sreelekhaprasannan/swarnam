class shopApiModel {
  String? name;
  String? branch;
  String? mobileno;
  String? shop_code;
  shopApiModel({this.name, this.branch, this.mobileno, this.shop_code});
  Map<String, dynamic> tomap() {
    return {
      "shop_name": name,
      "branch": branch,
      "mobile_no": mobileno,
      "shop_code": shop_code
    };
  }
}
