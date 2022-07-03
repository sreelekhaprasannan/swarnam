class NewOrderListShop {
  String? id;
  String? shop_name;
  String? shop_code;
  String? item_code;
  String? item_group;
  String? item;
  String? rate;
  String? qty;
  NewOrderListShop(
      {this.id,
      this.shop_name,
      this.shop_code,
      this.item_group,
      this.item_code,
      this.item,
      this.rate,
      this.qty});
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "shop_name": shop_name,
      "item_code": item_code,
      "shop_code": shop_code,
      "item_group": item_group,
      "item_name": item,
      "rate": rate,
      "qty": qty
    };
  }
}
