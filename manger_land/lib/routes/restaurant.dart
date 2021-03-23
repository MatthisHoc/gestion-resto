import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:manger_land/models/priceTag.dart';
import 'package:manger_land/models/restaurant.dart';
import 'package:manger_land/models/menu.dart';
import 'package:manger_land/models/food.dart';
import 'package:manger_land/widgets/AppBar.dart';
import 'package:manger_land/models/order.dart';
import 'package:manger_land/widgets/priceFormat.dart';

class RestaurantRoute extends StatefulWidget {
  final Restaurant restaurant;

  RestaurantRoute(this.restaurant);

  @override
  _RestaurantRouteState createState() => _RestaurantRouteState(restaurant);
}

class _RestaurantRouteState extends State<RestaurantRoute> {
  final Restaurant restaurant;
  List<Food> _foods = List<Food>();
  List<Menu> _menus = List<Menu>();
  final Order pendingOrder = Order();
  final GlobalKey<_ShoppingCartButtonState> _cartButtonKey =
      GlobalKey<_ShoppingCartButtonState>();
  final GlobalKey<_OrderListState> _orderListKey = GlobalKey<_OrderListState>();
  bool _showOrder = false;

  Food getFoodFromPriceTag(PriceTag priceTag) {
    if (priceTag.buyableType == Food.foodBuyableTypeName) {
      for (var element in _foods) {
        if (element.buyableId == priceTag.buyableId) {
          return element;
        }
      }
    }

    return null;
  }

  Menu getMenuFromPriceTag(PriceTag priceTag) {
    if (priceTag.buyableType == Menu.menuBuyableTypeName) {
      for (var element in _menus) {
        if (element.buyableId == priceTag.buyableId) {
          return element;
        }
      }
    }

    return null;
  }

  void _openOrderMenu() {
    if (this.mounted) {
      setState(() {
        _showOrder = !_showOrder;
      });
    }
  }

  void removedElementToOrder() {
    _cartButtonKey.currentState.refresh();
    _orderListKey.currentState.refresh();
  }

  void addedElementToOrder() {
    _cartButtonKey.currentState?.refresh();
    _orderListKey.currentState?.refresh();
  }

  _RestaurantRouteState(this.restaurant);

  @override
  Widget build(BuildContext context) {
    if (_foods.isEmpty) {
      Food.getAll(restaurant).then((foods) {
        if (this.mounted) {
          setState(() {
            _foods = foods;
          });
        }
        Menu.getAll(restaurant, foods).then((menus) {
          if (this.mounted) {
            setState(() {
              _menus = menus;
            });
          }
        });
      });
    }

    pendingOrder.restaurant = restaurant;

    final ShoppingCartButton shoppingCartButton =
        ShoppingCartButton(pendingOrder, _openOrderMenu, key: _cartButtonKey);

    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
            restaurant.name,
            actions: <Widget>[
              shoppingCartButton,
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Show restaurant image
              Material(
                elevation: 5.0,
                child: Image.memory(
                  restaurant.image,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
              ),
              // Split content
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.teal[400],
                  child: MaterialButton(
                    padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                    child: Text(
                      "Commander",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      if (pendingOrder.priceTags.isNotEmpty) {
                        pendingOrder.place();
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Expanded(child: MenuList(_menus, pendingOrder, this)),
              Expanded(
                  child: FoodTypeList(restaurant, _foods, pendingOrder, this)),
            ],
          ),
        ),
        Visibility(
          visible: _showOrder,
          child: Positioned(
            right: 30.0,
            top: 100.0,
            child: Material(
              elevation: 10.0,
              child: Container(
                width: 250.0,
                height: 300.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: OrderList(pendingOrder, this, key: _orderListKey),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OrderList extends StatefulWidget {
  final Order _pendingOrder;
  final _RestaurantRouteState _routeState;
  OrderList(this._pendingOrder, this._routeState, {Key key}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState(_pendingOrder, _routeState);
}

class _OrderListState extends State<OrderList> {
  Order _pendingOrder;
  _RestaurantRouteState _routeState;

  _OrderListState(this._pendingOrder, this._routeState);

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_pendingOrder.priceTags.length == 0) {
      return Center(
        child: Text(
          "Vous n'avez pas encore ajouté d'éléments dans votre panier",
          style: TextStyle(color: Colors.black54, fontSize: 16.0),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return Column(
        children: <Widget>[
          SizedBox(height: 25.0),
          Text(
            PriceFormat.format(_pendingOrder.price) + "€",
            style: TextStyle(fontSize: 18.0),
          ),
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, i) {
                  TextStyle style =
                      TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300);
                  PriceTag priceTag = _pendingOrder.priceTags[i];
                  Menu menu;
                  Food food;
                  (priceTag.buyableType == Menu.menuBuyableTypeName)
                      ? menu = _routeState.getMenuFromPriceTag(priceTag)
                      : food = _routeState.getFoodFromPriceTag(priceTag);
                  return FlatButton(
                    child: ListTile(
                      title: (food == null)
                          ? Text(menu.name, style: style)
                          : Text(food.name, style: style),
                      trailing: Text(PriceFormat.format(priceTag.price) + "€",
                          style: style),
                    ),
                    onPressed: () {
                      _pendingOrder.removeElement(_pendingOrder.priceTags[i]);
                      _routeState.removedElementToOrder();
                    },
                  );
                },
                separatorBuilder: (context, i) =>
                    Divider(thickness: 1.0, height: 1.0),
                itemCount: _pendingOrder.priceTags.length),
          ),
        ],
      );
    }
  }
}

class ShoppingCartButton extends StatefulWidget {
  final Order _pendingOrder;
  final void Function() _onPressed;
  ShoppingCartButton(this._pendingOrder, this._onPressed, {Key key})
      : super(key: key);

  @override
  _ShoppingCartButtonState createState() =>
      _ShoppingCartButtonState(_pendingOrder, _onPressed);
}

class _ShoppingCartButtonState extends State<ShoppingCartButton> {
  Order _pendingOrder;
  void Function() _onPressed;
  _ShoppingCartButtonState(this._pendingOrder, this._onPressed);

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Stack(
        children: <Widget>[
          Icon(
            Icons.shopping_cart_rounded,
            color: Colors.white,
            size: 33.0,
          ),
          Positioned(
            left: 14.0,
            top: 14.0,
            child: Container(
              width: 18.0,
              height: 18.0,
              decoration: BoxDecoration(
                color: (_pendingOrder != null &&
                        _pendingOrder.priceTags.length > 0)
                    ? Colors.teal[200]
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Text(
                (_pendingOrder != null)
                    ? _pendingOrder.priceTags.length.toString()
                    : "",
                style: TextStyle(
                  color: (_pendingOrder != null &&
                          _pendingOrder.priceTags.length > 0)
                      ? Colors.white
                      : Colors.transparent,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      shape: CircleBorder(
        side: BorderSide(
          width: 0.0,
          color: Colors.transparent,
        ),
      ),
      onPressed: _onPressed,
    );
  }
}

class MenuList extends StatelessWidget {
  final List<Menu> menus;
  final Order _pendingOrder;
  final _RestaurantRouteState _parent;
  MenuList(this.menus, this._pendingOrder, this._parent);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: menus.length,
      itemBuilder: (context, i) {
        return Container(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(5.0),
            child: Container(
              padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          menus[i].name,
                          style: TextStyle(
                            fontSize: 23.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          PriceFormat.format(menus[i].price) + "€",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AddButton(() {
                    _pendingOrder.addElement(menus[i]);
                    _parent.addedElementToOrder();
                  }),
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (ctx, i) {
        return Divider();
      },
    );
  }
}

class AddButton extends StatelessWidget {
  final onPressed;
  AddButton(this.onPressed);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      splashColor: Colors.teal[50],
      onPressed: onPressed,
      child: Text(
        '+',
        style: TextStyle(
          color: Colors.black,
          fontSize: 24.0,
          fontWeight: FontWeight.w200,
        ),
      ),
      shape: CircleBorder(
        side: BorderSide(width: 1.0, color: Colors.grey[400]),
      ),
    );
  }
}

class FoodTypeList extends StatelessWidget {
  final Restaurant restaurant;
  final List<Food> foods;
  final Order _pendingOrder;
  final _RestaurantRouteState _parent;
  FoodTypeList(this.restaurant, this.foods, this._pendingOrder, this._parent);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        separatorBuilder: (context, index) => SizedBox(height: 10.0),
        itemCount: restaurant.foodTypes.length,
        itemBuilder: (ctx, typeIndex) {
          return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Text(
                    restaurant.foodTypes[typeIndex].item2,
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    height: 110,
                    child: FoodList(
                        Food.ofType(foods, restaurant.foodTypes[typeIndex]),
                        _pendingOrder,
                        _parent),
                  ),
                ],
              ));
        });
  }
}

class FoodList extends StatelessWidget {
  final List<Food> foods;
  final Order _pendingOrder;
  final _RestaurantRouteState _parent;
  FoodList(this.foods, this._pendingOrder, this._parent);
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: foods.length,
      itemBuilder: (ctx, foodIndex) {
        return Container(
          padding: EdgeInsets.all(5),
          child: Material(
            borderRadius: BorderRadius.circular(5.0),
            elevation: 3.0,
            child: SizedBox(
              width: 200.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    foods[foodIndex].name,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    PriceFormat.format(foods[foodIndex].price) + "€",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  AddButton(() {
                    _pendingOrder.addElement(foods[foodIndex]);
                    _parent.addedElementToOrder();
                  }),
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(
        width: 10.0,
      ),
    );
  }
}
