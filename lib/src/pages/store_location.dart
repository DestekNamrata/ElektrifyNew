import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '/src/components/shops_location_item.dart';
import '/src/controllers/shop_controller.dart';
import '/src/themes/map_dark_theme.dart';
import '/src/themes/map_light_theme.dart';

class StoreLocation extends StatefulWidget {
  @override
  StoreLocationState createState() => StoreLocationState();
}

class StoreLocationState extends State<StoreLocation> {
  final ShopController controller = Get.put(ShopController());
  BitmapDescriptor? pinLocationIcon;
  Completer<GoogleMapController> _controller = Completer();
  bool loadGoogleMap = false;
  late double latitude, longitude;
  Map<MarkerId, Marker> markers = {};
  List<String> tabs = [
    "Near you".tr,
    "AC 3 pin".tr,
    "AC Type 1".tr,
    "AC Type 2".tr,
    "DC CHAdeMO".tr,
    "DC combo2".tr
  ];
  var tabIndex = 0.obs;
  @override
  void initState() {
    super.initState();
    setCustomMapPin();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        loadGoogleMap = true;
      });
    });
    latitude = controller.addressController.latitude.value;
    longitude = controller.addressController.longitude.value;
    Map<MarkerId, Marker> markerData = {};
    if (controller.shopList.length > 0)
      // ignore: curly_braces_in_flow_control_structures
      for (int i = 0; i < controller.shopList.length; i++) {
        print("------------------shoplist-------------------------");
        print(controller.shopList.toString());
        Map<String, dynamic> shop = controller.shopList[i];
        MarkerId _markerId = MarkerId('marker_id_$i');
        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            Marker _marker = Marker(
                icon: pinLocationIcon!,
                markerId: _markerId,
                position: LatLng(double.parse(shop['latitude'].toString()),
                    double.parse(shop['longtitude'].toString())),
                draggable: false,
                onTap: () {
                  controller.addToSavedShop(shop);
                });
            markerData[_markerId] = _marker;
          });
        });
      }

    setState(() {
      markers = markerData;
    });
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(0.3, 0.5)),
        'lib/assets/images/Chargestation.png');
  }

  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(latitude.toDouble(), longitude),
  //   zoom: 13.4746,
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Get.isDarkMode
            ? Color.fromRGBO(19, 20, 21, 1)
            : Color.fromRGBO(243, 243, 240, 1),
        body: SingleChildScrollView(
          child: Obx(() => Container(
                width: 1.sw,
                height: 1.sh,
                child: Stack(
                  children: <Widget>[
                    if (loadGoogleMap)
                      SizedBox(
                        width: 1.sw,
                        height: 1.sh,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          markers: Set<Marker>.of(markers.values),
                          initialCameraPosition: CameraPosition(
                            target: LatLng(latitude, longitude),
                            zoom: 12.4746,
                          ),
                          //  _kGooglePlex,
                          onMapCreated: (GoogleMapController controller) {
                            controller.setMapStyle(json.encode(Get.isDarkMode
                                ? MAP_DARK_THEME
                                : MAP_LIGHT_THEME));
                            _controller.complete(controller);
                          },
                        ),
                      ),
                    Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 1.sw,
                          height: 400,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              color: Get.isDarkMode
                                  ? const Color.fromRGBO(37, 48, 63, 1)
                                  : Colors.white,
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                    color: Color.fromRGBO(153, 153, 153, 0.2),
                                    offset: Offset(0, 4),
                                    blurRadius: 70,
                                    spreadRadius: 0)
                              ]),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: 60,
                                height: 5,
                                margin: EdgeInsets.only(top: 10, bottom: 13),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Color.fromRGBO(175, 175, 175, 1)),
                              ),
                              Container(
                                height: 40,
                                width: 1.sw,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1,
                                            color: Get.isDarkMode
                                                ? const Color.fromRGBO(
                                                    130, 139, 150, 0.14)
                                                : const Color.fromRGBO(
                                                    136, 136, 126, 0.14)))),
                                child: Center(
                                  child: TextField(
                                    controller: TextEditingController(
                                        text: controller
                                            .addressController.searchText.value)
                                      ..selection = TextSelection.fromPosition(
                                        TextPosition(
                                            offset: controller.addressController
                                                .searchText.value.length),
                                      ),
                                    textAlignVertical: TextAlignVertical.center,
                                    onChanged: (text) => controller
                                        .addressController
                                        .onChangeAddressSearchText(text),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Search".tr,
                                        prefixIcon: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            const IconData(0xf0cd,
                                                fontFamily: 'MIcon'),
                                            size: 18.sp,
                                            color: Get.isDarkMode
                                                ? const Color.fromRGBO(
                                                    130, 139, 150, 1)
                                                : const Color.fromRGBO(
                                                    136, 136, 126, 1),
                                          ),
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: () => controller
                                              .addressController
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
                                        hintStyle: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.sp,
                                            letterSpacing: -0.5,
                                            color: Get.isDarkMode
                                                ? const Color.fromRGBO(
                                                    130, 139, 150, 1)
                                                : const Color.fromRGBO(
                                                    136, 136, 126, 0.14))),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SizedBox(
                                          height: 34,
                                          width: 0.9.sw,
                                          child: ListView.builder(
                                              itemCount: tabs.length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return Obx(() => InkWell(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 20),
                                                        margin: const EdgeInsets
                                                            .only(right: 8),
                                                        height: 34,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: tabIndex
                                                                            .value ==
                                                                        index
                                                                    ? const Color
                                                                            .fromRGBO(
                                                                        69,
                                                                        165,
                                                                        36,
                                                                        1)
                                                                    : Get
                                                                            .isDarkMode
                                                                        ? const Color.fromRGBO(
                                                                            26,
                                                                            34,
                                                                            44,
                                                                            1)
                                                                        : const Color.fromRGBO(
                                                                            233,
                                                                            233,
                                                                            230,
                                                                            1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            40)),
                                                        child:
                                                            // call api for brands
                                                            //showBrands();
                                                            Text(
                                                          tabs[index],
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Inter',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14.sp,
                                                              letterSpacing:
                                                                  -0.5,
                                                              color: tabIndex
                                                                          .value ==
                                                                      index
                                                                  ? Colors.white
                                                                  : Get
                                                                          .isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : const Color
                                                                              .fromRGBO(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          1)),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        tabIndex.value = index;

                                                        //call brand wise stations API
                                                        //https://{{demo_url}}/api/m/brands/shops
                                                      },
                                                    ));
                                              }))),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 250,
                                width: 1.sw,
                                child: ListView.builder(
                                    itemCount: controller.shopList.length,
                                    padding: const EdgeInsets.only(left: 20),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> shop =
                                          controller.shopList[index];

                                      return ShopLocationItem(
                                        onTap: () async {
                                          print(
                                              "------------------shoplist-------------------------");
                                          print(controller.shopList.toString());
                                          final GoogleMapController?
                                              mapController =
                                              await _controller.future;
                                          try {
                                            mapController!.animateCamera(
                                                CameraUpdate.newCameraPosition(
                                              CameraPosition(
                                                bearing: 0,
                                                target: LatLng(
                                                    double.parse(
                                                        shop['latitude']
                                                            .toString()),
                                                    double.parse(
                                                        shop['longtitude']
                                                            .toString())),
                                                zoom: 17.0,
                                              ),
                                            ));

                                            controller.addToSavedShop(shop);
                                          } catch (e) {}
                                        },
                                        name: shop['language']['name'],
                                        address: shop['language']['address'],
                                        rating:
                                            "5", //shop['rating'].toString(),
                                        backImage: shop['backimage_url'],
                                        logoImage: shop['logo_url'],
                                      );
                                    }),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              )),
        ));
  }

  // Added by Aditi on 22-3-22
  /*showBrands() async {
    // https://{{demo_url}}/api/m/brand/get
    //
    // id_shop:4
    // id_brand_category:0
    // limit:5
    // offset:0
    String url = "$GLOBAL_URL/brand/get";

    try {
      var parameter = {
        'id_shop': 4,
        'id_brand_category':0,
        'limit':5,
        'offset':0
      };

      Response response =
          await post(Uri.parse(url),  body: parameter)
          .timeout(Duration(seconds: timeOut));

      if (response.statusCode == 200) {
        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        // String msg = getdata["message"];

        if (!error) {
          print(getdata.toString());

          tabs.clear();
          Data data = getdata["data"];
          for(var i in data.name)
            {
              data[i].
            }
          var brand = data["name"];
          print("redeemList $brand");
          var tempList = (tabs as List)
              .map((goldRedeemList) =>
          new BrandsModel.fromJson(data).toList();

          tranList.addAll(tempList);

          //offset = offset + perPage;
        }
      }

    } on TimeoutException catch (_) {
     // setSnackbar(getTranslated(context, 'somethingMSg')!);

    }
  }*/
}
