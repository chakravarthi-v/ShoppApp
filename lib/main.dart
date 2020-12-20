import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Screens/authScreen.dart';
import 'package:shopapp/Screens/cartScreen.dart';
import 'package:shopapp/Screens/editProductScreen.dart';
import 'package:shopapp/Screens/ordersScreen.dart';
import 'package:shopapp/Screens/productDetailScreen.dart';
import 'package:shopapp/Screens/productsOverviewScreen.dart';
import 'package:shopapp/Screens/splash_screen.dart';
import 'package:shopapp/Screens/userProductScreen.dart';
import 'package:shopapp/helpers/custom_route.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/providers/products.dart';


void main()=>runApp(MyApp());
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
        ChangeNotifierProvider(
          create: (ctx)=>Auth(),),
        ChangeNotifierProxyProvider<Auth,Products>(
        update: (ctx,auth,previousProducts)=>Products(
            auth.token,
            previousProducts==null?[]:previousProducts.items,
            auth.userId),),
        ChangeNotifierProvider(
        create: (ctx)=>Cart(),),
      ChangeNotifierProxyProvider<Auth,Orders>(
        update: (ctx,auth,previousOrders)=>Orders(
            auth.token,
            auth.userId,
            previousOrders==null?[]:previousOrders.orders),
      ),
    ],
        child:Consumer<Auth>(builder:(ctx,auth, child) => MaterialApp(
          title: 'Myshop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android:CustomPageTransitionBuilder(),
              TargetPlatform.iOS:CustomPageTransitionBuilder(),
            })
          ),
          home:auth.isAuth?productsOverviewScreen():
          FutureBuilder(future:auth.tryAutoLogin() ,
            builder: (ctx,authResultSnapshot)=>
            authResultSnapshot.connectionState==ConnectionState.waiting
                ?SplashScreen()
                :AuthScreen(),),
          routes: {
            productDetailScreen.routeName: (ctx)=>productDetailScreen(),
            CartScreen.routeName: (ctx)=>CartScreen(),
            OrderScreen.routeName: (ctx)=>OrderScreen(),
            productsOverviewScreen.routeName: (ctx)=>productsOverviewScreen(),
            UserProductScreen.routeName: (ctx)=>UserProductScreen(),
            EditProductScreen.routeName: (ctx)=>EditProductScreen(),
          },
        ),)
        );
  }
}
