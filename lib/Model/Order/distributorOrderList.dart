class NewOrderListDistributor {
  String? id;
  String? distributor_name;
  String? item_group;
  String? item_code;
  String? item;
  String? rate;
  String? qty;
  NewOrderListDistributor(
      {this.id,
      this.distributor_name,
      this.item_group,
      this.item,
      this.item_code,
      this.rate,
      this.qty});
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "distributor_name": distributor_name,
      "item_group": item_group,
      "item_name": item,
      "item_code":item_code,
      "rate": rate,
      "qty": qty
    };
  }
}
