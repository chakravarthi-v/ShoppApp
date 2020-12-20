import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Screens/productDetailScreen.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/product.dart';

class productItem extends StatelessWidget {
  /*final String id;
  final String title;
  final String imageUrl;*/
  
  //productItem({@required this.id,@required this.title,@required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    final prod=Provider.of<Product>(context);
    final cart=Provider.of<Cart>(context,listen: false);
    final token=Provider.of<Auth>(context,listen:false);
    return Consumer<Product>(
      builder: (ctx,product,child)=>ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(onTap: (){
            Navigator.of(context).pushNamed(productDetailScreen.routeName,arguments:prod.id);
            },
              child:Hero(
                tag: product.id,
                child: FadeInImage(
                  placeholder: AssetImage('assets/images/pic.png'),
                  image: NetworkImage(prod.imageUrl),
                  fit:BoxFit.cover ,),
              )),
          footer: GridTileBar(
            leading: IconButton(icon: Icon(prod.isFavourite?Icons.favorite:Icons.favorite_border),
              color: Theme.of(context).accentColor,onPressed: (){prod.toggleFavourite(token.token,token.userId);},),
            trailing: IconButton(icon: Icon(Icons.shopping_cart), color: Theme.of(context).accentColor,
              onPressed: (){cart.addItem(prod.id, prod.price, prod.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(content: Text('Added item to cart!'),
                action: SnackBarAction(label:'Undo' ,onPressed: (){cart.removeSingleItem(prod.id);},),
              duration: Duration(seconds: 2),)); },),
            backgroundColor: Colors.black87,title: Text(prod.title,textAlign: TextAlign.center,),
          ),
        ),
      ),
    );
  }
}
