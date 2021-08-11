import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multivender_ecommerce_app/Views/MyColors.dart';

class Header extends StatelessWidget {
  const Header({
    @required this.header,
  }) ;

  final String header;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 22.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: (){
              Navigator.pushNamed(context, "/AccountPage");
            },
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                  color: widgetColor,
                  borderRadius: BorderRadius.circular(18.r),
                  image: DecorationImage(
                      image: AssetImage("images/Woman.png")
                  )
              ),
            ),
          ),
          Text(
            header,
            style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white
            ),
          ),
          InkWell(
            onTap: (){
              Navigator.pushNamed(context, "/NotificationsPage");
            },
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: widgetColor,
                borderRadius: BorderRadius.circular(18.r),

              ),
              child: Center(child: Icon(Icons.notifications_none,size: 20.r,color: white60,)),
            ),
          ),
        ],
      ),
    );
  }
}
