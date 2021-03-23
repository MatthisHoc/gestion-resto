import 'package:flutter/material.dart';
import 'package:manger_land/models/restaurant.dart';
import 'package:manger_land/models/user.dart';
import 'package:manger_land/routes/addRestaurant.dart';
import 'package:manger_land/routes/manageRestaurant.dart';
import 'package:manger_land/widgets/AppBar.dart';

class MyRestaurantsRoute extends StatefulWidget {
  @override
  _MyRestaurantsRouteState createState() => _MyRestaurantsRouteState();
}

class _MyRestaurantsRouteState extends State<MyRestaurantsRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Mes restaurants"),
      body: UserRestaurantsList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.teal[400],
        onPressed: () async {
          await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddRestaurantRoute()));
          Navigator.pop(context);
        },
      ),
    );
  }
}

class UserRestaurantsList extends StatefulWidget {
  @override
  _UserRestaurantsListState createState() => _UserRestaurantsListState();
}

class _UserRestaurantsListState extends State<UserRestaurantsList> {
  List<Restaurant> _ownedRestaurants = List<Restaurant>();
  List<Restaurant> _workingRestaurants = List<Restaurant>();

  @override
  Widget build(BuildContext context) {
    if (_ownedRestaurants.isEmpty) {
      Restaurant.getFromOwner(User.loggedUser).then((value) {
        setState(() {
          _ownedRestaurants = value;
        });
      });
      Restaurant.getFromWorker(User.loggedUser).then((value) {
        setState(() {
          _workingRestaurants = value;
        });
      });
    }

    if (_ownedRestaurants.isEmpty && _workingRestaurants.isEmpty) {
      return Center(
        child: Text(
          "Vous n'avez pas encore de restaurants",
          style: TextStyle(
            color: Colors.black54,
            fontSize: 20.0,
          ),
        ),
      );
    } else {
      return ListView.separated(
        padding: EdgeInsets.all(5.0),
        itemCount: _ownedRestaurants.length + _workingRestaurants.length,
        separatorBuilder: (ctxt, i) {
          return Divider();
        },
        itemBuilder: (ctxt, i) {
          var restaurant = (i < _ownedRestaurants.length)
              ? _ownedRestaurants[i]
              : _workingRestaurants[i - _ownedRestaurants.length];
          return MaterialButton(
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ManageRestaurantRoute(
                      restaurant, i < _ownedRestaurants.length)));
              // Refresh list to match any changes
              setState(() {
                _ownedRestaurants = List<Restaurant>();
              });
            },
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  (restaurant.image == null)
                      ? Text("")
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.memory(
                            restaurant.image,
                            fit: BoxFit.cover,
                            height: 150.0,
                          ),
                        ),
                  SizedBox(height: 20.0),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                        child: Text(
                          restaurant.name,
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(100.0, 0.0, 0.0, 0.0),
                        child: Text(
                          (i < _ownedRestaurants.length)
                              ? "Propriétaire"
                              : "Travailleur",
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      restaurant.address,
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
        },
      );
    }
  }
}
