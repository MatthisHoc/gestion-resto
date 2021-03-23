class PriceTag {
  double price;
  int tagId;
  int buyableId;
  String buyableType;

  static PriceTag fromJson(Map data) {
    var priceTag = PriceTag();
    priceTag.tagId = data["id"];
    priceTag.price = data["price"];
    priceTag.buyableType = data["buyable-type"];
    priceTag.buyableId = data["buyable-id"];

    return priceTag;
  }
}
