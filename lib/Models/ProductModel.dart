import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'RateModel.dart';
import 'StoreModel.dart';

class ProductModel{
  ProductModel({
    @required this.name,
    @required this.description,
    @required this.image1URL,
    @required this.image2URL,
    @required this.image3URL,
    @required this.price,
    @required this.store,
    @required this.category,
    @required this.status,
    @required this.available,
});

  String name;
  String description;
  String image1URL;
  String image2URL;
  String image3URL;
  double price;
  StoreModel store;
  String category;
  List<RateModel> ratesList = [];
  String status;
  bool available;
  String id;

  CollectionReference products = FirebaseFirestore.instance.collection('products');

  //Working
  Future<void> addProduct() async {
    id = "${store.name} $category $name";
    await products.doc("${store.name} $category $name").set({
      "id" : id,
      "name" : name,
      "description" : description,
      "image1URL" : image1URL,
      "image2URL" : image2URL,
      "image3URL" : image3URL,
      "price" : price,
      "store" : store.toMap(),
      "category" : category,
      "ratesList" : ratesList,
      "status" : status,
      "available" : available,
    })
        .then((value) => print("Products Added"))
        .catchError((error) => print("Failed to add product: $error"));
  }
  //Working
  Future<void> readCategoryProducts(String key) async {
    int counter = 0;
    products.where('category',isEqualTo: key).get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(counter);
        counter = counter + 1;
        print("===========================================");
        print(doc["id"]);
        print("===========================================");
      });
    });
  }
  //Debugging
  Future<void> readStoreProducts(String key) async {
    int counter = 0;
    products.where('store.name',isEqualTo: key ).get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(counter);
        counter = counter + 1;
        print("===========================================");
        print(doc["id"]);
        print("===========================================");
      });
    });
  }
  //Working
  Future<void> updateProduct({String key,var value}) async {
    await products.doc(id)
        .update({key : value})
        .then((value) => print("Product Updated"))
        .catchError((error) => print("Failed to update product: $error"));
  }
  //Working
  Future<void> deleteProduct() async {
    await products
        .doc(id)
        .delete()
        .then((value) => print("Product Deleted"))
        .catchError((error) => print("Failed to delete product : $error"));
  }

}