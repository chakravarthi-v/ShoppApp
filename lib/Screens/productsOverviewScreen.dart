import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Screens/cartScreen.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/badge.dart';
import 'file:///D:/flut-projects/shopapp/lib/providers/product.dart';
import 'package:shopapp/widgets/productsGrid.dart';
enum filterOption{
  Favourite,
  All,
}

class productsOverviewScreen extends StatefulWidget {
  static const routeName='Homepage';

  @override
  _productsOverviewScreenState createState() => _productsOverviewScreenState();
}

class _productsOverviewScreenState extends State<productsOverviewScreen> {
  bool _showOnlyfavourites=false;
  var _isInit=true;
  var _isLoading=false;

  @override
  void didChangeDependencies() {
    if(_isInit){
      setState(() {
        _isLoading=true;
      });

      Provider.of<Products>(context).fetchProducts().then((value){setState(() {
        _isLoading=false;
      });});
    }
    _isInit=false;
    super.didChangeDependencies();
  }
  @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MyShop'), actions: <Widget>[
        PopupMenuButton(icon: Icon(Icons.more_vert,),
          onSelected: (filterOption selectedValue){
          setState(() {
            if(selectedValue==filterOption.Favourite){
              _showOnlyfavourites=true;
            }
            else{
              _showOnlyfavourites=false;
            }
          });

          },
          itemBuilder:(_)=>[
            PopupMenuItem(child: Text('Only favourites'),value: filterOption.Favourite,),
            PopupMenuItem(child: Text('Show All'),value: filterOption.All,)
          ] ,),
        Consumer<Cart>(builder:(context, value, child) =>
            Badge(child:child, value: value.Itemcount.toString(),),
          child: IconButton(icon: Icon(Icons.shopping_cart,),onPressed: (){
            Navigator.of(context).pushNamed(CartScreen.routeName);
          },),
        ),

      ],),
      drawer: AppDrawer(),
      body: _isLoading?Center(child:CircularProgressIndicator()):ProductsGrid(_showOnlyfavourites),
    );
  }
}


