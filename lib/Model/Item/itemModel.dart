class ItemModel {
  String? item_code;
  String? item_name;
  String? item_group;
  double? item_Price;
  ItemModel({this.item_code, this.item_name, this.item_group, this.item_Price, required });
  Map<String, dynamic> tomap() {
    return {
      "item_code": item_code,
      "item_name": item_name,
      "item_group": item_group,
      "item_price": item_Price
    };
  }
  //item_name TEXT,item_group TEXT,item_price TEXT
}
