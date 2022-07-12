class VisitedShop {
  String? shop_code;
  String? executive;
  String? longitude;
  String? latitude;
  VisitedShop(this.shop_code, this.executive, this.latitude, this.longitude);
  Map<String, dynamic> tomap() {
    return {
      "shop_code": shop_code,
      "executive": executive,
      "latitude": latitude,
      "longitude": longitude
    };
  }
}
