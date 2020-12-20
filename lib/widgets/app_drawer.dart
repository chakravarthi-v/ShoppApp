import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Screens/ordersScreen.dart';
import 'package:shopapp/Screens/productsOverviewScreen.dart';
import 'package:shopapp/Screens/userProductScreen.dart';
import 'package:shopapp/helpers/custom_route.dart';
import 'package:shopapp/providers/auth.dart';
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(child: Column(children: <Widget>[
      AppBar(title: Text('Welcome'),automaticallyImplyLeading: false,),
      Divider(),
      ListTile(leading: Icon(Icons.shop),title: Text('Shop'),
      onTap: (){Navigator.of(context).pushReplacementNamed(productsOverviewScreen.routeName);},),
      Divider(),
      ListTile(leading: Icon(Icons.payment),title: Text('Orders'),
      onTap: (){Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);}),
      Divider(),
      ListTile(leading: Icon(
        Icons.edit),title: Text('Manage Products'),
          onTap: (){Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName);}),
      Divider(),
      ListTile(leading: Icon(Icons.exit_to_app),title: Text('Logout'),
          onTap: (){Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed('/');
        Provider.of<Auth>(context,listen:false).logout();}),
    ],),);
  }
}
