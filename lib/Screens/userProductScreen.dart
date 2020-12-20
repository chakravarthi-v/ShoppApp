import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Screens/editProductScreen.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/userProductWidget.dart';

class UserProductScreen extends StatefulWidget {
  static const routeName='/user-products';

  @override
  _UserProductScreenState createState() => _UserProductScreenState();
}

class _UserProductScreenState extends State<UserProductScreen> {
  Future<void> _refreshProducts(BuildContext context) async{
    await Provider.of<Products>(context,listen: false).fetchProducts(true);
  }


  @override
  Widget build(BuildContext context) {
    //final productsData=Provider.of<Products>(context,listen: false);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: Text('Your products'),actions: <Widget>[
        IconButton(icon: Icon(Icons.add),onPressed: (){
          Navigator.of(context).pushNamed(EditProductScreen.routeName);
        },),
      ],),
      body:FutureBuilder(
        future: _refreshProducts(context) ,
        builder:(ctx,snapshot)=> snapshot.connectionState==ConnectionState.waiting?
            Center(child: CircularProgressIndicator(),)
            :RefreshIndicator(onRefresh:()=>_refreshProducts(context),
              child: Consumer<Products>(
                builder: (ctx,productsData,_)=>
                 Padding(
                  padding: EdgeInsets.all(8),
                  child:productsData.items.length==0?Center(child: Text('You have not yet added any products to sell!:('),)
                      :ListView.builder(itemBuilder: (_,i)=>
                        Column(children: [
                          UserProductItem(productsData.items[i].id,productsData.items[i].title,productsData.items[i].imageUrl),
                          Divider(),
                    ],),
                itemCount: productsData.items.length,),
                 ),
              ),
        ),
      ),
    );
  }
}
