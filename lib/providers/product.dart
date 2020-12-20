import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;
  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite=false,
  });
  Future<void> toggleFavourite(String token,String userId) async{
    final oldStatus=isFavourite;
    isFavourite=!isFavourite;
    notifyListeners();
    final url="https://flutter-96219.firebaseio.com/userfavourites/$userId/$id.json?auth=$token";
    try{
      final response=await put(url,body:json.encode(
        isFavourite,
      ));
      if(response.statusCode>=400){
        isFavourite=oldStatus;
        notifyListeners();
      }
    }
    catch(error){
      isFavourite=oldStatus;
      notifyListeners();
    }

  }
}