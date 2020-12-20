import 'package:flutter/material.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/widgets/productItem.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  ProductsGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final productData= Provider.of<Products>(context);
    final products=showFavs ?productData.favoutitetems:productData.items;
    if(products.length==0){ return Center(child: Text('You have no favourites :('),);}
    else{
      return GridView.builder(itemCount: products.length,
        padding: const EdgeInsets.all(10.0),
        gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3/2,),
        itemBuilder:(ctx,i)=>ChangeNotifierProvider.value(
          value:products[i],
          child: productItem(),),
      );}
  }
}