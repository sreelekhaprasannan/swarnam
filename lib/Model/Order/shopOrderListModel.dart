class NewOrderListShop {
  String? id;
  String? shop_code;
  String? distributor;
  String? item_code;
  String? item_group;
  String? item;
  String? rate;
  String? qty;
  String? latitude;
  String? longitude;
  int? isSubmited;
  NewOrderListShop(
      {this.id,
      this.distributor,
      this.shop_code,
      this.item_group,
      this.item_code,
      this.item,this.isSubmited,
      this.rate,
      this.qty,
      this.latitude,
      this.longitude});
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "item_code": item_code,
      "distributor": distributor,
      "shop_code": shop_code,
      "item_group": item_group,
      "item_name": item,
      "rate": rate,
      "qty": qty,
      "latitude": latitude,
      "longitude": longitude,
      "isSubmited":0
    };
  }
}
