import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products.dart';

class productDetailScreen extends StatelessWidget {
  static const routeName=' /product-detail';
  @override
  Widget build(BuildContext context) {
    final productID=ModalRoute.of(context).settings.arguments as String;
    final loadedProducts=Provider.of<Products>(context, listen: false).findById(productID);
    return Scaffold(
      //appBar: AppBar(title: Text(loadedProducts.title),),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(title:Text(loadedProducts.title),
              background: Hero(tag: loadedProducts.id,
                  child: Image.network(loadedProducts.imageUrl,fit: BoxFit.cover,)),),
          ),
          SliverList(delegate: SliverChildListDelegate([
            SizedBox(height: 10),
            Text('₹${loadedProducts.price}',style: TextStyle(color: Colors.grey,fontSize: 20),textAlign: TextAlign.center,),
            SizedBox(height: 10,),
            Container(width: double.infinity,child: Text(loadedProducts.description,
              textAlign: TextAlign.center,softWrap: true,),padding: EdgeInsets.symmetric(horizontal: 10),),
            SizedBox(height: 800,),
          ]),),
        ],

      ),
    );
  }
}
