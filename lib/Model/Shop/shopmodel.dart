class ShopModel {
  String? shop_code;
  String? name;
  String? branch;
  String? phone;
  String? route;
  String? distributor;
  String? executive;
  //phone TEXT,executive TEXT,distributor TEXT,route TEXT)")
  ShopModel(
      {this.shop_code,
      this.name,
      this.branch,
      this.phone,
      this.route,
      this.distributor,
      this.executive});
  Map<String, dynamic> tomap() {
    return {
      "shop_code": shop_code,
      "name": name,
      "branch": branch,
      "route": route,
      "phone": phone,
      "distributor": distributor,
      "executive": executive
    };
  }
}
