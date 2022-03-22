import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:samkuev/src/components/card_item.dart';
import 'package:samkuev/src/components/checkout_head.dart';
import 'package:samkuev/src/controllers/cart_controller.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({Key? key}) : super(key: key);

  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  CartController cartController = CartController();

  bool _value = false;
  int val = -1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cartController = CartController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? Colors.white
          // Color.fromRGBO(19, 20, 21, 1)
          : Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        backgroundColor: Get.isDarkMode ? Colors.white : Colors.white,
        title: const Text(
          'Select Payments Methods',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 0.02.sh),
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              "Pay through",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 0.02.sh),
          Card(
            child: Container(
              constraints: BoxConstraints(minHeight: 0.3.sh),
              margin: EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? Color.fromRGBO(37, 48, 63, 1)
                      : Colors.white),
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CheckoutHead(text: "Payment method".tr),
                    // InkWell(
                    //   child: CardItem(
                    //     title: "Stripe",
                    //     isActive: cartController.paymentType.value == 3,
                    //   ),
                    //   onTap: () {
                    //     setState(() {
                    //       cartController.paymentType.value = 3;
                    //     });
                    //     // cartController.paymentType.value = 3;
                    //     showModalBottomSheet(
                    //       context: context,
                    //       isScrollControlled: true,
                    //       backgroundColor: Colors.transparent,
                    //       builder: (_) {
                    //         return DraggableScrollableSheet(
                    //           expand: false,
                    //           builder: (_, controller) {
                    //             return AddCard(
                    //               scrollController: controller,
                    //             );
                    //           },
                    //         );
                    //       },
                    //     );
                    //   },
                    // ),
                    InkWell(
                      child: CardItem(
                        title: "Cash",
                        icon: const IconData(0xedf0, fontFamily: 'MIcon'),
                        isActive: cartController.paymentType.value == 1,
                      ),
                      onTap: () {
                        setState(() {
                          cartController.paymentType.value = 1;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
            // color: Colors.white,
            // child: Column(
            //   children: [
            //     InkWell(
            //       child: CardItem(
            //         title: "Stripe",
            //         isActive: cartController.paymentType.value == 3,
            //       ),
            //       onTap: () {
            //         cartController.paymentType.value = 3;
            //         showModalBottomSheet(
            //           context: context,
            //           isScrollControlled: true,
            //           backgroundColor: Colors.transparent,
            //           builder: (_) {
            //             return DraggableScrollableSheet(
            //               expand: false,
            //               builder: (_, controller) {
            //                 return AddCard(
            //                   scrollController: controller,
            //                 );
            //               },
            //             );
            //           },
            //         );
            //       },
            //     ),
            //     InkWell(
            //       child: CardItem(
            //         title: "Cash",
            //         icon: const IconData(0xedf0, fontFamily: 'MIcon'),
            //         isActive: cartController.paymentType.value == 1,
            //       ),
            //       onTap: () {
            //         cartController.paymentType.value = 1;
            //       },
            //     ),
            // Row(
            //   children: [
            //     Radio(
            //       value: 1,
            //       groupValue: val,
            //       onChanged: (value) {
            //         setState(() {
            //           val = val;
            //         });
            //       },
            //       activeColor: Colors.green,
            //     ),
            //     const Text("Razorpay",
            //         style: TextStyle(
            //             fontFamily: 'Inter',
            //             fontWeight: FontWeight.w400,
            //             fontSize: 16,
            //             color: Colors.black)),
            //   ],
            // ),
            //   const Divider(color: Colors.grey),
            //   Row(
            //     children: [
            //       Radio(
            //         value: 1,
            //         groupValue: val,
            //         onChanged: (value) {
            //           setState(() {
            //             val = val;
            //           });
            //         },
            //         activeColor: Colors.green,
            //       ),
            //       const Text("Paytm",
            //           style: TextStyle(
            //               fontFamily: 'Inter',
            //               fontWeight: FontWeight.w400,
            //               fontSize: 16,
            //               color: Colors.black)),
            //     ],
            //   )
            //   ],
            // ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 140,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.security, color: Colors.amber.shade600),
                Text("100 % Safe & Secure Payment",
                    style: TextStyle(color: Colors.grey.shade500)),
              ],
            ),
            SizedBox(height: 10),
            TextButton(
                child: Text("Proceed to pay",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.fromLTRB(90, 15, 90, 15)),
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                            side: BorderSide(color: Colors.green)))),
                onPressed: () async {
                  await cartController
                      .orderSave()
                      .whenComplete(() => Get.toNamed("/PaymentDone"));

                  // Get.toNamed("/PaymentDone");
                }),
          ],
        ),
      ),
    );
  }
}
