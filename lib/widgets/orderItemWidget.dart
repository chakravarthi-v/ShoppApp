import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:intl/intl.dart';
class OrderItemWidget extends StatefulWidget {
  final OrderItem order;
  OrderItemWidget(this.order);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  var _expanded=false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded?min(widget.order.products.length*20.0+110,200):95,
      child: Card(margin: EdgeInsets.all(10),
        child: Column(children:<Widget> [
          ListTile(title: Text('₹${widget.order.amount}'),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(icon:Icon(_expanded?Icons.expand_less:Icons.expand_more),
          onPressed: (){
              setState(() {
                _expanded=!_expanded;
              });
          },),),
          AnimatedContainer(duration: Duration(milliseconds: 300),
            padding:EdgeInsets.symmetric(horizontal: 15,vertical: 4),
            height:_expanded? min(widget.order.products.length*20.0+10,100):0,
            child: ListView(children:widget.order.products.map((e) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(e.title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                Text('${e.quantity}x ₹${e.price}',style: TextStyle(fontSize: 18,color: Colors.grey),)
              ],
            )).toList(),),)
        ],),),
    );
  }
}
