import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:elektrify/src/models/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/cart_controller.dart';

class TimerScreen extends StatefulWidget {
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
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<TimerScreen> {
  CartController cartController = CartController();
  String paymentId = "";
  bool _value = false;
  int val = -1;
  final AuthController authController = Get.put(AuthController());
  final CountDownController _controller = CountDownController();

  // var user = Rxn<User>();
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
                      height: 0.01.sh,
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
          Container(
              child: CircularCountDownTimer(
            // Countdown duration in Seconds.
            duration: cartController.duration.value,

            // Countdown initial elapsed Duration in Seconds.
            initialDuration: 0,

            // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
            controller: _controller,

            // Width of the Countdown Widget.
            width: MediaQuery.of(context).size.width / 2,

            // Height of the Countdown Widget.
            height: MediaQuery.of(context).size.height / 3.5,

            // Ring Color for Countdown Widget.
            ringColor: Colors.grey[300]!,

            // Ring Gradient for Countdown Widget.
            ringGradient: null,

            // Filling Color for Countdown Widget.
            fillColor: Colors.orange[500]!,

            // Filling Gradient for Countdown Widget.
            fillGradient: null,

            // Background Color for Countdown Widget.
            backgroundColor: Colors.white,

            // Background Gradient for Countdown Widget.
            backgroundGradient: null,

            // Border Thickness of the Countdown Ring.
            strokeWidth: 20.0,

            // Begin and end contours with a flat edge and no extension.
            strokeCap: StrokeCap.round,

            // Text Style for Countdown Text.
            textStyle: const TextStyle(
              fontSize: 33.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),

            // Format for the Countdown Text.
            textFormat: CountdownTextFormat.S,

            // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
            isReverse: true,

            // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
            isReverseAnimation: true,

            // Handles visibility of the Countdown Text.
            isTimerTextShown: true,

            // Handles the timer start.
            autoStart: true,

            // This Callback will execute when the Countdown Starts.
            onStart: () {
              // Here, do whatever you want
              debugPrint('Countdown Started');
            },

            // This Callback will execute when the Countdown Ends.
            onComplete: () {
              // Here, do whatever you want
              debugPrint('Countdown Ended');
            },
          )),
          Card(
              margin: const EdgeInsets.only(top: 20),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Text("Charge Type :",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400)),
                      Text(
                          (cartController.paymentType.value == 2)
                              ? "Cash"
                              : "RazorPay",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                  SizedBox(
                    height: 0.01.sh,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Text("Charge Fare :",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400)),
                      Text(
                          // _radioValue1 == 1
                          // ? "\u20b9 ${amount!}.00"
                          //     : "\u20b9 ${time!}",
                          /*cartController.calculateAmount(),*/ "${cartController.amount}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                  SizedBox(
                    height: 0.01.sh,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Text("Offer apply  :",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.w400)),
                      Text(
                          /*"\u20b9 -$discountprice .00"*/ "${cartController.proccessPercentage}",
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                  SizedBox(
                    height: 0.01.sh,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Text("Tax :",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400)),
                      Text("${cartController.tax}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 0.8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Text("Total :",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                      Text(
                          /* _radioValue1 == 1
  ? "\u20b9 ${total = discountprice! + amount!}.00"
      : "\u20b9 ${total = discountprice! + time!}.00"*/
                          "${cartController.total}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                ]),
              )),
        ],
      ),
    );
  }
}
