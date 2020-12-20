import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/orderItemWidget.dart';

class OrderScreen extends StatefulWidget {
  static const routeName='/orders';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading=false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async{
      setState(() {
        _isLoading=true;
      });
      print(1);
      await Provider.of<Orders>(context,listen:false).fetchAndSetOrder();
      setState(() {
        _isLoading=false;
      });
      print(2);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final orders=Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Orders'),),
      drawer: AppDrawer(),
      body: _isLoading?Center(child: CircularProgressIndicator(),):orders.orders.length==0?Center(child: Text('You have not ordered anything yet! :('),):
      ListView.builder(itemCount: orders.orders.length,itemBuilder: (ctx,i)=>
       OrderItemWidget(orders.orders[i])),
    );
  }
}
 