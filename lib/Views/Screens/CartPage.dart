import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multivender_ecommerce_app/Controllers/UserCredController.dart';
import 'package:multivender_ecommerce_app/Models/OrderModel.dart';
import 'package:multivender_ecommerce_app/Models/ProductModel.dart';
import 'package:multivender_ecommerce_app/Models/StatusModel.dart';
import 'package:multivender_ecommerce_app/Models/UserModel.dart';
import 'package:multivender_ecommerce_app/Views/Component/Header.dart';
import 'package:multivender_ecommerce_app/Views/Component/MainButton.dart';
import 'package:multivender_ecommerce_app/Views/Component/MainCard.dart';
import 'package:multivender_ecommerce_app/Views/Component/MyTextField.dart';
import 'package:multivender_ecommerce_app/Views/FutureReturn/FlashBar.dart';
import 'package:provider/provider.dart';
import 'package:multivender_ecommerce_app/Controllers/SearchResultsDisplayController.dart';

import '../MyColors.dart';

class CartPage extends StatefulWidget {
  CartPage({
    @required this.pageController,
  });

  final PageController pageController;
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  TextEditingController _searchTextController = TextEditingController();
  List<ProductModel> cartData;
  List<MainCard> cartCards;

  bool _phoneNumberCheck(BuildContext context) {
    var mobile = Provider.of<UserCredController>(context, listen: false)
        .userModel
        .mobile;
    if (mobile == "" || mobile == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    cartData =
        Provider.of<UserCredController>(context, listen: false).userModel.cart;
    Provider.of<SearchResultDisplayController>(context, listen: false).reset();
    cartCards = List.generate(cartData.length, (index) {
      return MainCard(
        marginRight: 0,
        productModel: cartData[index],
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double statusBar = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: EdgeInsets.only(
          top: statusBar.h,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 28.w, right: 28.w),
                child: Column(
                  children: [
                    Header(
                      header: "Cart",
                    ),
                    MyTextFiled(
                        textController: _searchTextController,
                        myIcon: Icons.search,
                        hint: "Search",
                        focus: false,
                        search: true,
                        searchList: cartCards,
                        screenName: "Cart",
                        isPassword: false),
                    SizedBox(
                      height: 22.h,
                    ),
                  ],
                ),
              ),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Provider.of<SearchResultDisplayController>(context)
                                  .screenName ==
                              "Cart" &&
                          Provider.of<SearchResultDisplayController>(context)
                                  .isFound ==
                              true
                      ? Container(
                          height: 410.h,
                          width: 375.w,
                          padding: EdgeInsets.only(
                            bottom: 9.h,
                          ),
                          child: GridView.count(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            padding: EdgeInsets.only(
                                left: 28.w, right: 28.w, bottom: 100.h),
                            children: List.generate(
                                Provider.of<SearchResultDisplayController>(
                                        context)
                                    .results
                                    .length, (index) {
                              return Provider.of<SearchResultDisplayController>(
                                      context)
                                  .results[index];
                            }),
                          ),
                        )
                      : Container(
                          height: 410.h,
                          width: 375.w,
                          padding: EdgeInsets.only(
                            bottom: 9.h,
                          ),
                          child: GridView.count(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              padding: EdgeInsets.only(
                                  left: 28.w, right: 28.w, bottom: 100.h),
                              children: cartCards),
                        ),
                  Positioned(
                    bottom: 30.h,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 28.w),
                      child: MainButton(
                          text: "Checkout",
                          btnFunction: () async {
                            bool phoneCheckResults = _phoneNumberCheck(context);
                            if (!phoneCheckResults) {
                              Navigator.pushNamed(context, "/AddPhoneNumber");
                            } else {
                              flashBar(title: "Please Wait", message: 'It will take a second', context: context);
                              double totalPrice = 0.0;
                              cartData.forEach((element) {
                                totalPrice = element.price + totalPrice;
                              });
                              UserModel userModel =
                                  Provider.of<UserCredController>(context,
                                          listen: false)
                                      .userModel;
                              await OrderModel(
                                      user: Provider.of<UserCredController>(
                                              context,
                                              listen: false)
                                          .userModel,
                                      status: StatusModel().waiting,
                                      price: totalPrice,
                                      orderingDate: DateTime.now(),
                                      products: cartData)
                                  .addOrder();
                              await userModel.cleanCart();
                              widget.pageController.animateToPage(0,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                              flashBar(title: "Success", message: 'Your Order has been Made ... Wait for our call Soon!', context: context);
                            }
                          }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
