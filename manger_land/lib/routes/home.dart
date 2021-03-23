import 'package:flutter/material.dart';
import 'package:manger_land/models/restaurant.dart';
import 'package:manger_land/models/user.dart';
import 'package:manger_land/routes/restaurant.dart';
import 'package:manger_land/routes/myRestaurants.dart';
import 'login.dart';
import 'orders.dart';
import 'package:manger_land/widgets/AppBar.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  final _restaurantsListKey = GlobalKey<_RestaurantsListState>();

  @override
  Widget build(BuildContext context) {
    if (User.loggedUser == null) {
      // On next tick go to login screen
      Future.microtask(
        () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginRoute(),
          ),
        ),
      );

      return Scaffold(
        body: Center(
            child: Container(
          color: Colors.white,
        )),
      );
    } else {
      final _homeMessage = "Bonjour " + User.loggedUser.firstName;
      return Scaffold(
        appBar: CustomAppBar(_homeMessage),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        User.loggedUser.firstName +
                            " " +
                            User.loggedUser.lastName,
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        User.loggedUser.email,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 35.0,
                      ),
                      Row(
                        textDirection: TextDirection.rtl,
                        children: <Widget>[
                          MaterialButton(
                            child: Text(
                              "Deconnexion",
                              style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline),
                            ),
                            onPressed: () {
                              // Reset logged user and go to login screen
                              User.loggedUser = null;
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => LoginRoute()));
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.teal[400],
                ),
              ),
              ListTile(
                title: Text("Mes commandes"),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => OrdersRoute()));
                },
              ),
              ListTile(
                title: Text("Mes restaurants"),
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MyRestaurantsRoute()));
                  _restaurantsListKey.currentState.refresh();
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: RestaurantsList(key: _restaurantsListKey),
        ),
      );
    }
  }
}

class RestaurantsList extends StatefulWidget {
  RestaurantsList({Key key}) : super(key: key);

  @override
  _RestaurantsListState createState() => _RestaurantsListState();
}

class _RestaurantsListState extends State<RestaurantsList> {
  List<Restaurant> _restaurants = List<Restaurant>();

  void refresh() {
    setState(() {
      _restaurants = List<Restaurant>();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve all restaurants and set the value
    if (_restaurants.isEmpty) {
      Restaurant.getAll().then((value) {
        setState(() {
          _restaurants = value;
        });
      });
    }

    return ListView.separated(
      padding: EdgeInsets.all(5.0),
      itemCount: _restaurants.length,
      separatorBuilder: (ctxt, i) {
        return Divider();
      },
      itemBuilder: (context, i) {
        if (_restaurants.isNotEmpty) {
          return MaterialButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RestaurantRoute(_restaurants[i])));
            },
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  (_restaurants[i].image == null)
                      ? Text("")
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.memory(
                            _restaurants[i].image,
                            fit: BoxFit.cover,
                            height: 150.0,
                          ),
                        ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: Text(
                      _restaurants[i].name,
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      _restaurants[i].owner.firstName +
                          " " +
                          _restaurants[i].owner.lastName +
                          "\n" +
                          _restaurants[i].address,
                      style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return null;
        }
      },
    );
  }
}
