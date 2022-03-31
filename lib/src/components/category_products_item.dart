// ignore_for_file: use_key_in_widget_constructors

import 'package:elektrify/src/controllers/category_controller.dart';
import 'package:elektrify/src/pages/chargedetails.dart';
import 'package:elektrify/src/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '/src/controllers/product_controller.dart';
import '/src/models/product.dart';

class CategoryProductItem extends GetView<ProductController> {
  final Product? product;
  final Function()? onClick;
  int? qrData;
  bool? isSelected;

  CategoryProductItem({this.product,this.onClick,this.qrData,this.isSelected});

  @override
  Widget build(BuildContext context) {
    int now = DateTime.now().toUtc().millisecondsSinceEpoch;
    bool timerStarted = product!.startTime! <= now && product!.endTime! >= now;
    CategoryController categoryController=Get.put(CategoryController());
    return
      Card(
        // color: isSelected?Colors.green:Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 1,
      shadowColor: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child:
        ListTile(
          selectedColor: Colors.green,
          selectedTileColor: Colors.green,
          selected: false,
          onTap: () {
            controller.activeProduct.value.id;
            categoryController.qrData=product!.id;

            if (categoryController.qrData != null) {
              Get.to(
                ChargeingDetails(qrdata: categoryController.qrData!),
              );
            }

            // Get.to(Home(qrdata: product!.id), arguments: [
            //   {},
            // ]);
            // Get.to(Home(qrdata:categoryController.qrData));
            // qrData=null;
          },
          dense: true,
          isThreeLine: true,
          leading: Image.network(
            "${product?.image}",
            width: 0.2.sw,
            fit: BoxFit.fitHeight,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${product?.name}',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                          fontSize: 14.sp,
                          color: Colors.black)),
                  Container(
                    height: 25,
                    width: 0.25.sw,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: product?.status == 1 //available
                            ? Colors.green
                            : product?.status == 2 //currently using
                                ? Colors.yellow
                                : product?.status == 3 //notworking
                                    ? Colors.red
                                    : Colors.black), //faulty
                    child: Center(
                      child: Text("${product?.statusName}",
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                              color: Colors.white)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Text('${product?.chargingType}',
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 18.sp,
                      color: Colors.black)),
              SizedBox(height: 10.h),
            ],
          ),
          subtitle: Row(
            children: [
              const Icon(
                Icons.access_time_filled_sharp,
                color: Colors.black,
              ),
              SizedBox(width: 10.w),
              Text("\u20b9 ${product?.price}/h ",
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300,
                      fontSize: 18.sp,
                      color: Colors.black)),
              SizedBox(width: 15.w),
              Icon(
                const IconData(0xf239, fontFamily: 'MaterialIcons'),
                size: 20.sp,
                color: Get.isDarkMode
                    ? const Color.fromRGBO(130, 139, 150, 1)
                    : const Color.fromRGBO(100, 200, 100, 1),
              ),
              SizedBox(width: 10.w),
              Text(
                "${product?.power} kw ",
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300,
                    fontSize: 18.sp,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
