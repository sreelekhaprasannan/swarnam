class ItemListModel {
  String? item_code;
  String? item_name;
  String? item_qty;
  String? item_price;
  ItemListModel(
      {this.item_code, this.item_name, this.item_qty, this.item_price});
  Map<String, dynamic> toMap() {
    return {
      "item_code": item_code,
      "item_name": item_name,
      "item_qty": item_qty,
      "item_price": item_price
    };
  }
}
