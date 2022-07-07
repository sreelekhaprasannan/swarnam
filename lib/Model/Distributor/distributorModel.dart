class DistributorModel {
  String? distributor_code;
  String? name;
  String? mobile;
  String? executive;
  DistributorModel(
      {this.distributor_code, this.name, this.mobile, this.executive});
  Map<String, dynamic> tomap() {
    return {
      "distributor_code": distributor_code,
      "name": name,
      "mobile": mobile,
      "executive": executive
    };
    //distributor_code TEXT,name TEXT,mobile TEXT,executive TEXT
  }
}
