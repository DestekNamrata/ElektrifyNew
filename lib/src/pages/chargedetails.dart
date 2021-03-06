import 'package:elektrify/src/controllers/cart_controller.dart';
import 'package:elektrify/src/pages/pamentmethod.dart';
import 'package:elektrify/src/requests/chargeingdetails_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ChargeingDetails extends StatefulWidget {
  int? qrdata;
  ChargeingDetails({Key? key, this.qrdata}) : super(key: key);
  @override
  _ChargeingDetailsState createState() => _ChargeingDetailsState();
}

class _ChargeingDetailsState extends State<ChargeingDetails> {
  CartController cartController = CartController();
  // bool _value = false;
  // int val = -1;
  TextEditingController controllerAmount = TextEditingController();
  TextEditingController controllerTime = TextEditingController();
  var chargeingDetailsList = {};
  var language = {};
  var images = {};
  String? imageurl;
  String? name;
  String? chargingtype;
  int? price;
  String? power;
  int? discountprice = 0;
  int? amount = 0;
  int? time = 0;
  int? total = 0;
  var productId;
  var startTime, endTime, totalAmt, date;
  @override
  void initState() {
    super.initState();
    print('-----------------${widget.qrdata.toString()}');
    DateTime datetime = new DateTime.now();
    date = datetime.year.toString() +
        "-" +
        datetime.month.toString() +
        "-" +
        datetime.day.toString();
    getChagrgingDetaild();
  }

  getChagrgingDetaild() async {
    var response = await chargeingdetailsrequest(1, widget.qrdata);
    setState(() {
      imageurl = response['data']['images'][0]['image_url']!;
      name = response['data']['language']['name'];
      chargingtype = response['data']['charging_type'];
      price = response['data']['price'];
      power = response['data']['power'];
      productId = response['data']['id'];
      discountprice = response['data']['discount_price'] ?? 0;
      print("------imageurl-----------$imageurl");
      print("------name-----------$name");
      print("------chargingtype-----------$chargingtype");
      print("------price-----------$price");
      print("------power-----------$power");
      print("------discountprice-----------$discountprice");
    });
  }

  void calculateTime() {
    DateTime now = DateTime.now();
    startTime = now.hour.toString() +
        ":" +
        now.minute.toString() +
        ":" +
        now.second.toString();
    DateTime end = now.add(new Duration(hours: int.parse(controllerTime.text)));
    endTime = end.hour.toString() +
        ":" +
        end.minute.toString() +
        ":" +
        end.second.toString();
    print("startTime:-" + startTime + " " + "endTime:-" + endTime.toString());
  }

  void calculateTimeAsPerAmount() {
    DateTime now = DateTime.now();
    startTime = now.hour.toString() +
        ":" +
        now.minute.toString() +
        ":" +
        now.second.toString();

    totalAmt = int.parse(controllerAmount.text) / price!;
    int totalMin = getminutesFromString(totalAmt.toDouble());
    DateTime end = now.add(new Duration(minutes: totalMin));
    endTime = end.hour.toString() +
        ":" +
        end.minute.toString() +
        ":" +
        end.second.toString();
    print("startTime:-" + startTime + " " + "endTime:-" + endTime.toString());
  }

  int getminutesFromString(double value) {
    if (value < 0) return 0;
    int flooredValue = value.floor();
    double decimalValue = value - flooredValue;
    // String hourValue = getHourString(flooredValue);
    String minuteString = getMinuteString(decimalValue);
    int totalMin = (flooredValue * 60) + int.parse(minuteString);
    print(totalMin);
    // return '$hourValue:$minuteString';
    cartController.duration.value = totalMin;
    print("duration ${cartController.duration.value}");
    return totalMin;
  }

  String getMinuteString(double decimalValue) {
    return '${(decimalValue * 60).toInt()}'.padLeft(2, '0');
  }

  String getHourString(int flooredValue) {
    return '${flooredValue % 24}'.padLeft(2, '0');
  }

  int _radioValue1 = 1;
  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue1 = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? Colors.white
          // Color.fromRGBO(19, 20, 21, 1)
          : Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0.5,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        backgroundColor: Get.isDarkMode ? Colors.white : Colors.white,
        title: const Text(
          'Charge Details',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: imageurl == null
          ? Container(
              width: 1.sw,
              height: 1.sh,
              alignment: Alignment.center,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    0.5.sw,
                  ),
                  child: const SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      color: Color.fromRGBO(69, 165, 36, 1),
                    ),
                  )))
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Selected charge port',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 0.02.sh),
                    Card(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                width: 60,
                                height: 80,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Image.network(imageurl!,
                                      width: 60, height: 70),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 0.05.sw),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$name',
                                  style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.black)),
                              Text("$chargingtype",
                                  style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.black))
                            ],
                          ),
                          SizedBox(width: 0.18.sw),
                          Expanded(child: Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_filled_sharp,
                                      color: Colors.black,
                                      size: 18,
                                    ),
                                    SizedBox(width: 10.w),
                                    Text("\u20b9 $price/h",
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w300,
                                            fontSize: 18.sp,
                                            color: Colors.black)),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(
                                      const IconData(0xf239,
                                          fontFamily: 'MaterialIcons'),
                                      size: 20.sp,
                                      color: Get.isDarkMode
                                          ? const Color.fromRGBO(
                                              130, 139, 150, 1)
                                          : const Color.fromRGBO(
                                              100, 200, 100, 1),
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      "$power kw ",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w300,
                                          fontSize: 18.sp,
                                          color: Colors.black),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                    SizedBox(height: 0.02.sh),
                    const Text('Choose charge type',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 0.02.sh),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Radio<int>(
                                  value: 1,
                                  groupValue: _radioValue1,
                                  onChanged: (int? value) {
                                    setState(() {
                                      _radioValue1 = value!;
                                    });
                                  },
                                ),
                                const Text(
                                  'Amount',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                Radio<int>(
                                  value: 2,
                                  groupValue: _radioValue1,
                                  onChanged: (int? value) {
                                    setState(() {
                                      _radioValue1 = value!;
                                    });
                                  },
                                ),
                                const Text(
                                  'Time',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                            _radioValue1 == 1
                                ? TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        hintText: "Enter the Amount",
                                        prefix: Text('\u20b9',
                                            style: TextStyle(fontSize: 18))),
                                    controller: controllerAmount,
                                    onChanged: (value) {
                                      setState(() {
                                        amount = int.parse(
                                            controllerAmount.text.toString());
                                        cartController.amount.value = amount!;
                                      });

                                      print(controllerAmount.text.toString());
                                    },
                                  )
                                : TextField(
                                    decoration: const InputDecoration(
                                        hintText: "Enter the Time",
                                        suffix: Text('hr',
                                            style: TextStyle(fontSize: 18))),
                                    controller: controllerTime,
                                    onChanged: (value) {
                                      setState(() {
                                        time = price! *
                                            int.parse(controllerTime.text);
                                      });

                                      print(controllerTime.text.toString());
                                    },
                                  ),
                            SizedBox(height: 0.02.sh),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 0.02.sh),
                    const Text('Bill Details',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 0.02.sh),
                    Card(
                        child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
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
                            Text(_radioValue1 == 1 ? "Amount" : "Time",
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
                                _radioValue1 == 1
                                    ? "\u20b9 ${amount!}.00"
                                    : "\u20b9 ${time!}",
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
                            Text("\u20b9 -$discountprice .00",
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
                            const Text("\u20b9 0.00",
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
                                _radioValue1 == 1
                                    ? "\u20b9 ${total = discountprice! + amount!}.00"
                                    : "\u20b9 ${total = discountprice! + time!}.00",
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
              ),
            ),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 140,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.security, color: Colors.amber.shade600),
                Text("100 % Safe & Secure Payment",
                    style: TextStyle(color: Colors.grey.shade500)),
              ],
            ),
            const SizedBox(height: 10),
            TextButton(
                child: const Text("Continue",
                    style: const TextStyle(fontSize: 14, color: Colors.white)),
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.fromLTRB(90, 10, 90, 15)),
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                            side: const BorderSide(color: Colors.green)))),
                onPressed: () async {
                  if (_radioValue1 == 1) {
                    if (controllerAmount.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Please enter amount");
                    } else {
                      calculateTimeAsPerAmount();
                      cartController.amount.value = amount!;
                      cartController.discount.value = discountprice!;
                      cartController.port.value = "$name";
                      cartController.type.value = "$chargingtype";
                      cartController.total.value = 200;
                      //updated by ND
                      String result = await cartController.orderAvailabilityApi(
                          startTime, endTime, date, productId);
                      if (result == "true") {
                        Get.to(PaymentMethod(
                            startTime: startTime,
                            endTime: endTime,
                            date: date,
                            duration: cartController.duration.value,
                            productId: productId,
                            amount: amount));
                      } else {
                        Fluttertoast.showToast(
                            msg: "Port is already booked,choose another");
                      }
                      // await cartController
                      //     .orderAvailabilityApi(startTime,endTime,date,productId)
                      //     .whenComplete(() => Get.to(
                      //   PaymentMethod(startTime: startTime,endTime:endTime,date:date),));
                    }
                  } else {
                    if (controllerTime.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Please enter time");
                    } else {
                      calculateTime();
                      // Get.toNamed("/PaymentMethod");
                      //updated by ND
                      String result = await cartController.orderAvailabilityApi(
                          startTime, endTime, date, productId);
                      if (result == "true") {
                        Get.to(PaymentMethod(
                            startTime: startTime,
                            endTime: endTime,
                            date: date,
                            productId: productId,
                            amount: time));
                      } else {
                        Fluttertoast.showToast(
                            msg: "Not Available,Please select another time");
                      }
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentMethod(start)));
                    }
                  }
                  cartController.calculateAmount();
                }),
          ],
        ),
      ),
    );
  }
}
