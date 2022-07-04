import 'package:flutter/cupertino.dart';

class ItemListModel {
  TextEditingController qtyController = TextEditingController();
  String? item_code;
  String? item_name;
  String? item_qty;
  String? item_price;
  String? item_group;
  ItemListModel(
      {this.item_code,
      required this.qtyController,
      this.item_name,
      this.item_qty,
      this.item_price,
      this.item_group});
  Map<String, dynamic> toMap() {
    return {
      "item_code": item_code,
      "item_name": item_name,
      "item_qty": qtyController.text,
      "item_price": item_price,
      "item_group": item_group
    };
  }
}
