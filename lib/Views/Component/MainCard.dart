import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multivender_ecommerce_app/Controllers/CurrentProductRateController.dart';
import 'package:multivender_ecommerce_app/Controllers/UserCredController.dart';
import 'package:multivender_ecommerce_app/Models/ProductModel.dart';
import 'package:multivender_ecommerce_app/Models/UserRateModel.dart';
import 'package:multivender_ecommerce_app/Views/MyColors.dart';
import 'package:multivender_ecommerce_app/Views/Screens/Details.dart';
import 'package:provider/provider.dart';

class MainCard extends StatelessWidget {

  MainCard({
    @required this.marginRight,
    @required this.productModel,
});

  final double marginRight;
  final ProductModel productModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){

        List<UserRateModel> rates = Provider.of<UserCredController>(context,listen: false).userModel.rates;
        for (var i = 0; i < rates.length; i++) {
          if (rates[i].to.name == productModel.name) {
            Provider.of<CurrentProductRateController>(context,listen: false).setCurrentRate(rate: rates[i].rate);
            break;
          }else{
            Provider.of<CurrentProductRateController>(context,listen: false).setCurrentRate(rate: 0);
          }
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Details(productModel: productModel)),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: marginRight.w),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 150.r,
              width: 150.r,
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: widgetColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Container(
                height: 150.r,
                width: 150.r,
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(productModel.image),fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),
            Positioned(
              bottom: -1.r,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 7.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: widgetColor,
                    ),
                    child: Text(
                      productModel.name,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          fontSize: 14.sp
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
