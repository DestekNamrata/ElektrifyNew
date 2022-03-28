import 'package:elektrify/src/controllers/product_controller.dart';
import 'package:elektrify/src/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class TimerScreen extends GetView<ProductController> {
  final Product? product;
  final bool? iSimilar;
  TimerScreen({this.product, this.iSimilar = false});
  int now = DateTime.now().toUtc().millisecondsSinceEpoch;
  bool timerStarted = true;
  // bool height = (product!.isCountDown == 1 && timerStarted);
  // String currencySymbol =
  //     controller.currencyController.getActiveCurrencySymbol();

  // String unit = product!.unit ?? "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const Padding(
          padding: EdgeInsets.all(5.0),
          child: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 0.03.sh),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('EV port Phonix mall',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 0.02.sh,
                    ),
                    ListTile(
                      leading: Image.asset(
                        "lib/assets/images/ACType2.png",
                        height: 60,
                        width: 60,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Text("Charger-1, Port-1",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                          const Text("AC-3 pin-1",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(),
        ],
      ),
    );
  }
}
