import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shopapp/providers/cart.dart';

class OrderItem{
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({@required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime});
}
class Orders with ChangeNotifier{
  final String authToken;
  final String userId;
  Orders(this.authToken,this.userId,this._orders);
  List<OrderItem> _orders=[];
  List<OrderItem> get orders{
    return [..._orders];
  }
  Future<void> fetchAndSetOrder() async{
    final url="https://flutter-96219.firebaseio.com/orders/$userId.json?auth=$authToken";
    final response=await get(url);
    final List<OrderItem> loadedOrders=[];
    final extractedData=json.decode(response.body) as Map<String,dynamic>;
    print(extractedData);
    print(-2);
    if(extractedData==null){
      return;
    }
    extractedData.forEach((orderId,orderData) {
      print(-3);
      loadedOrders.add(OrderItem(id:orderId, amount:orderData['amount']+.0,
          dateTime:DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>).map((e) =>CartItem(
            id: e['id'],title:e['title'],quantity: e['quantity'],price: e['price'],
          )).toList(),
          ));
      print(-4);
    });
    _orders=loadedOrders.reversed.toList();
    print(-1);
    notifyListeners();
}
  Future<void> addOrder(List<CartItem> cartProducts,double total) async{
    final url="https://flutter-96219.firebaseio.com/orders/$userId.json?auth=$authToken";
    final timeStamp=DateTime.now();
    print(-2);
    final response=await post(url,body: json.encode({
        'amount':total,
        'dateTime':timeStamp.toIso8601String(),
        'products':cartProducts.map((e)=>{
          'id':e.id,
          'title':e.title,
          'quantity':e.quantity,
          'price':e.price

    }).toList()
    }));
    print(-1);
    _orders.insert(0, OrderItem(
        id:json.decode(response.body)['name'],amount: total,products:cartProducts,dateTime:timeStamp));
  notifyListeners();
  }
}