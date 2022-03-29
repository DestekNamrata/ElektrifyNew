import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:elektrify/src/models/user.dart';
import 'package:elektrify/src/pages/chargedetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart' as GooglePlace;

import '/config/global_config.dart';
import '/src/components/location_search_item.dart';
import '/src/controllers/address_controller.dart';
import '/src/themes/map_dark_theme.dart';
import '/src/themes/map_light_theme.dart';

class LocationPage extends GetView<AddressController> {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(MAP_DEFAULT_LATITUDE, MAP_DEFAULT_LONGITUDE),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    controller.mapController = Completer();
    User? user = controller.authController.user.value;

    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? Color.fromRGBO(19, 20, 21, 1)
          : Color.fromRGBO(243, 243, 240, 1),
      body: Obx(() => Container(
            width: 1.sw,
            height: 1.sh,
            child: Stack(
              children: <Widget>[
                Container(
                  width: 1.sw,
                  height: 1.sh,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    onTap: (LatLng data) {
                      controller.moveToCoords(data.latitude, data.longitude);
                      // controller.getPlaceName(data.latitude, data.longitude);
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    markers: Set<Marker>.of(controller.markers.values),
                    padding: EdgeInsets.only(top: 600, right: 0),
                    zoomControlsEnabled: false,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController mapcontroller) {
                      mapcontroller.setMapStyle(json.encode(
                          Get.isDarkMode ? MAP_DARK_THEME : MAP_LIGHT_THEME));
                      if (!controller.mapController!.isCompleted)
                        controller.mapController!.complete(mapcontroller);
                    },
                  ),
                ),
                Positioned(
                    top: 53,
                    left: 10,
                    right: 25,
                    child: Column(
                      children: <Widget>[
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 0.1.sw,
                              height: 0.045.sh,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  border: Border.all(
                                      width: 3,
                                      color: Get.isDarkMode
                                          ? Color.fromRGBO(130, 139, 150, 0.1)
                                          : Colors.green),
                                  borderRadius: BorderRadius.circular(40)),
                              child: InkWell(
                                  onTap: () {
                                    Get.toNamed("/profile");
                                  },
                                  child: user!.imageUrl!.length > 4
                                      ?
                                  ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: CachedNetworkImage(
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.fill,
                                            imageUrl:
                                                "$GLOBAL_IMAGE_URL${user.imageUrl}",
                                            placeholder: (context, url) =>
                                                Container(
                                              width: 40,
                                              height: 40,
                                              alignment: Alignment.center,
                                              child: Icon(
                                                const IconData(0xee4b,
                                                    fontFamily: 'MIcon'),
                                                color: Colors.white,
                                                size: 20.sp,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ))
                                      : Icon(
                                          const IconData(0xf25c,
                                              fontFamily: 'MIcon'),
                                          color: Get.isDarkMode
                                              ? Color.fromRGBO(255, 255, 255, 1)
                                              : Color.fromRGBO(0, 0, 0, 1),
                                          size: 20,
                                        )),
                            ),
                            Expanded(
                                child:
                            Container(
                              margin: const EdgeInsets.only(left: 5),
                              width: 1.sw - 100,
                              decoration: BoxDecoration(
                                  boxShadow: const <BoxShadow>[
                                    BoxShadow(
                                        color:
                                            Color.fromRGBO(169, 169, 150, 0.13),
                                        offset: Offset(0, 2),
                                        blurRadius: 2,
                                        spreadRadius: 0)
                                  ],
                                  color: Get.isDarkMode
                                      ? Color.fromRGBO(37, 48, 63, 1)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(25)),
                              child: TextField(
                                controller: TextEditingController(
                                    text: controller.searchText.value)
                                  ..selection = TextSelection.fromPosition(
                                    TextPosition(
                                        offset:
                                            controller.searchText.value.length),
                                  ),
                                textAlignVertical: TextAlignVertical.center,
                                onChanged: (text) =>
                                    controller.onChangeAddressSearchText(text),
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp,
                                    letterSpacing: -0.4,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      const IconData(0xf0d1,
                                          fontFamily: 'MIcon'),
                                      size: 22.sp,
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () => controller
                                        .onChangeAddressSearchText(""),
                                    icon: Icon(
                                      const IconData(0xeb99,
                                          fontFamily: 'MIcon'),
                                      size: 20.sp,
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            ),

                            // scanner
                            Container(
                              // width: 0.1.sw,
                              // height: 0.045.sh,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 8.0),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  border: Border.all(
                                      width: 3,
                                      color: Get.isDarkMode
                                          ? Color.fromRGBO(130, 139, 150, 0.1)
                                          : Colors.green),
                                  // borderRadius: BorderRadius.circular(50)
                              ),
                              child: InkWell(
                                  onTap: () async{
                                    var qrdata = await FlutterBarcodeScanner.scanBarcode(
                                        "red", "Cancel", true, ScanMode.QR);

                                    print('-------------------${qrdata.toString()}');
                                    // check when coming from cancel button=-1
                                    if(qrdata!="-1"){
                                      Future.delayed(Duration(milliseconds: 100),
                                              () {
                                            Get.to(
                                                ChargeingDetails(
                                                  qrdata: int.parse(qrdata.trim()),
                                                ),
                                                arguments: [
                                                  {},
                                                ]);
                                            // Do something
                                          });
                                    }else{
                                      Get.back();
                                    }

                                  },
                                  child: Icon(Icons.qr_code_2_rounded,
                                    color: Colors.black,
                                    size: 35,
                                  ),
                            ),
    //                         Container(
    //                           width: 0.05.sw,
    //                           height: 0.045.sh,
    //                           alignment: Alignment.center,
    //                           margin: const EdgeInsets.only(right: 5, top: 0),
    //                           decoration: BoxDecoration(
    //                             color: Colors.green,
    //                             border: Border.all(
    //                                 width: 3,
    //                                 color: Get.isDarkMode
    //                                     ? Color.fromRGBO(130, 139, 150, 0.1)
    //                                     : Colors.green),
    //                             //borderRadius: BorderRadius.circular(50)
    //                           ),
    //                           child: InkWell(
    //                             child:Icon(
    //                               Icons.qr_code_2_rounded,
    //                               color: Colors.black,
    //                               size: 35,
    //                             ),
    //                             onTap: () async {
    // // Get.toNamed("/profile");
    //                               var qrdata =
    //                                   await FlutterBarcodeScanner.scanBarcode(
    //                                       "red", "Cancel", true, ScanMode.QR);
    //
    //                               print(
    //                                   '-------------------${qrdata.toString()}');
    //                               Future.delayed(Duration(milliseconds: 100),
    //                                   () {
    //                                 Get.to(
    //                                     ChargeingDetails(
    //                                       qrdata: int.parse(qrdata.trim()),
    //                                     ),
    //                                     arguments: [
    //                                       {},
    //                                     ]);
    //                                 // Do something
    //                               });
    //                             },
    //                             //      )
    //                           ),
                            )
                          ],
                        ),
                        if (controller.isSearch.value)
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                      color:
                                          Color.fromRGBO(169, 169, 150, 0.13),
                                      offset: Offset(0, 2),
                                      blurRadius: 2,
                                      spreadRadius: 0)
                                ],
                                color: Get.isDarkMode
                                    ? Color.fromRGBO(37, 48, 63, 1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: controller.predictions.map((element) {
                                int index =
                                    controller.predictions.indexOf(element);
                                GooglePlace.AutocompletePrediction prediction =
                                    element;

                                return LocationSearchItem(
                                  mainText:
                                      prediction.structuredFormatting!.mainText,
                                  address: prediction
                                      .structuredFormatting!.secondaryText,
                                  onClickRaw: (text) =>
                                      controller.getLatLngFromName(text),
                                  onClickIcon: (text) =>
                                      controller.onChangeSearchText(text),
                                  isLast: index ==
                                      (controller.predictions.length - 1),
                                );
                              }).toList(),
                            ),
                          )
                      ],
                    )),
              ],
            ),
          )),
      floatingActionButton: TextButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.all(0))),
        onPressed: controller.currentLocation,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 2,
                    spreadRadius: 0,
                    color: Color.fromRGBO(166, 166, 166, 0.25))
              ],
              borderRadius: BorderRadius.circular(30),
              color: Get.isDarkMode
                  ? Color.fromRGBO(37, 48, 63, 1)
                  : Colors.white),
          alignment: Alignment.center,
          child: Icon(
            const IconData(0xef88, fontFamily: 'MIcon'),
            color: Get.isDarkMode ? Colors.white : Colors.black,
            size: 32.sp,
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: TextButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.all(0))),
            child: Container(
              width: 1.sw - 30,
              height: 60,
              alignment: Alignment.center,
              child: Text(
                "Enter location".tr,
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                    color: Color.fromRGBO(255, 255, 255, 1)),
              ),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(69, 165, 36, 1),
                  borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: () {
              Get.toNamed("/shopsLocation");
            }),
      ),
    );
  }
}
