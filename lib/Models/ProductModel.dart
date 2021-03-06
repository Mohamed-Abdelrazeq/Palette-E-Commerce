import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';

class ProductModel{
  ProductModel({
    this.name,
    this.description,
    this.image,
    this.price,
    this.category,
    this.available,
});

  String name;
  String description;
  String image ;
  double price;
  String category;
  bool available;
  String id;
  List<double> rates = [];

  CollectionReference _products = FirebaseFirestore.instance.collection('products');

  //Working
  Future<void> addProduct() async {

    flutterLocalNotificationsPlugin.show(
        0,
        "Product Added",
        "$name Now is our most recent Product , Congrats!!",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name, channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));

    id = "$category $name";
    bool isUnique = await _checkUniqueProductInTheStore(name);
    if(isUnique){
      await _products.doc(" $category $name").set({
        "id" : id,
        "name" : name,
        "description" : description,
        "images" : image,
        "price" : price,
        "category" : category,
        "available" : available,
        "rates" : rates,
      })
          .then((value) => print("Products Added"))
          .catchError((error) => print("Failed to add product: $error"));
    }else{
      print("Product already exists");
    }
  }
  //Working
  Future<bool> _checkUniqueProductInTheStore(String key) async {
    List<ProductModel> myProductsList = [];
    await _products.where('name',isEqualTo: key).get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        myProductsList.add(ProductModel().toObject(doc.data()));
      });
    });
    if(myProductsList.isEmpty){
      return true;
    }else{
      return false;
    }
  }
  //Working
  Future<void> readCategoryProducts(String key) async {
    List<ProductModel> myProductsList = [];
    await _products.where('category',isEqualTo: key).get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        myProductsList.add(ProductModel().toObject(doc.data()));
      });
    });
    print("done");
    print(myProductsList);
    return myProductsList;
  }
  //Working
  Future<List<ProductModel>> readAllProducts() async {
    List<ProductModel> myProductsList = [];
    await _products.get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        myProductsList.add(ProductModel().toObject(doc.data()));
      });
    });
    return myProductsList;
  }
  //Working
  Future<void> updateProduct({String key,var value}) async {
    id = " $category $name";
    await _products.doc(id)
        .update({key : value})
        .then((value) => print("Product Updated"))
        .catchError((error) => print("Failed to update product: $error"));
  }
  //Working
  Future<void> deleteProduct() async {
    await _products
        .doc(id)
        .delete()
        .then((value) => print("Product Deleted"))
        .catchError((error) => print("Failed to delete product : $error"));
  }
  //Working
  ProductModel toObject(Map json){
    ProductModel myProduct = ProductModel(name: json["name"], description: json["description"]  ,price:  json["price"].toDouble(), category: json["category"], available: json["available"]);
    myProduct.id = json["id"];
    myProduct.image = json["images"];
    List myRates = json["rates"];
    List<double> listD = [];
    if(myRates != null){
      myRates.forEach((element) {
        listD.add(element.toDouble());
      });
    }
    myProduct.rates = listD;
    return myProduct;
  }
  //Working
  Map<String, dynamic> toMap() {
    return {
      "name" : name,
      "description" : description,
      "images" : image,
      "price" : price,
      "category" : category,
      "available" : available,
      "rates" : rates,
    };
  }
  //UnderEvaluation
  Future<void> addRate({double newRate, double oldRate}) async {
    if(rates == []){
      print("[] is a freaking null");
    }
    if(oldRate == 0){
      rates.add(newRate);
    }else {
      if(rates != null){
        rates.remove(oldRate);
      }
      rates.add(newRate);
    }
    id = " $category $name";
    print(id);
    print(rates);
    await _products.doc(id)
        .update({"rates" : rates})
        .catchError((error) => print("Failed to update product: $error"));
  }
}

