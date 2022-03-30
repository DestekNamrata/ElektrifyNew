import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '/src/components/appbar.dart';
import '/src/components/empty.dart';
import '/src/components/order_history_dialog.dart';
import '/src/components/order_history_info.dart';
import '/src/components/order_history_item.dart';
import '/src/components/order_history_tab.dart';
import '/src/components/shadows/order_history_item_shadow.dart';
import '/src/controllers/auth_controller.dart';
import '/src/controllers/chat_controller.dart';
import '/src/controllers/language_controller.dart';
import '/src/controllers/order_controller.dart';
import '/src/models/chat_user.dart';

class OrderHistory extends StatefulWidget {
  @override
  OrderHistoryState createState() => OrderHistoryState();
}

class OrderHistoryState extends State<OrderHistory>
    with TickerProviderStateMixin {
  TabController? tabController;
  final AuthController authController = Get.put(AuthController());
  final OrderController orderController = Get.put(OrderController());
  final LanguageController languageController = Get.put(LanguageController());
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();

    tabController = new TabController(length: 3, vsync: this);
  }

  void showSheet(item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (_, controller) {
            return SingleChildScrollView(
              child: OrderHistoryDialog(
                data: item,
              ),
              controller: controller,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? Color.fromRGBO(19, 20, 21, 1)
          : Color.fromRGBO(243, 243, 240, 1),
      appBar: AppBar(
        
        title: Text(
          "My orders".tr,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        // backwardsCompatibility: true,
        // hasBack: true,
        actions: [OrderHistoryInfo()],
        // actions: OrderHistoryInfo(),
      ),
      body: SizedBox(
        height: 1.sh - appBarHeight,
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: 1.sw,
                height: 60,
                decoration: BoxDecoration(
                    color: Get.isDarkMode
                        ? Color.fromRGBO(26, 34, 44, 1)
                        : Color.fromRGBO(249, 249, 246, 1)),
                child: TabBar(
                    controller: tabController,
                    indicatorColor: Color.fromRGBO(69, 165, 36, 1),
                    indicatorWeight: 2,
                    labelColor: Get.isDarkMode
                        ? Color.fromRGBO(255, 255, 255, 1)
                        : Color.fromRGBO(0, 0, 0, 1),
                    unselectedLabelColor: Get.isDarkMode
                        ? Color.fromRGBO(130, 139, 150, 1)
                        : Color.fromRGBO(136, 136, 126, 1),
                    labelStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      letterSpacing: -0.4,
                    ),
                    onTap: (index) {
                      setState(() {
                        tabIndex = index;
                      });

                      orderController.load.value = true;
                      orderController.ordersList.value = [];
                    },
                    tabs: [
                      Tab(
                          child: OrderHistoryTab(
                        name: "Completed".tr,
                        type: 1,
                      )),
                      Tab(
                          child: OrderHistoryTab(
                              name: "Open".tr,
                              type: 2,
                              count: orderController.newOrderCount.value)),
                      Tab(
                          child: OrderHistoryTab(
                        name: "Cancelled".tr,
                        type: 3,
                      )),
                    ]),
              ),
              Container(
                child: [
                  Container(
                    width: 1.sw,
                    height: 1.sh - 165,
                    child: tabIndex == 0
                        ? FutureBuilder<List>(
                            future: orderController.getOrderHistory(
                                authController.user.value!,
                                4,
                                languageController.activeLanguageId.value),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                return snapshot.data!.isEmpty
                                    ? Empty(message: "No completed orders".tr)
                                    : ListView.builder(
                                        itemCount: snapshot.data!.length,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 20),
                                        itemBuilder: (context, index) {
                                          Map<String, dynamic> data =
                                              snapshot.data![index];

                                          return OrderHistoryItem(
                                            shopName: data['shop']['language']
                                                ['name'],
                                            status: 4,
                                            orderId: data['id'],
                                            orderDate: orderController
                                                .getTime(data['created_at']),
                                            amount: double.parse(
                                                data['total_sum'].toString()),
                                          );
                                        });
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }

                              return ListView.builder(
                                  itemCount: 4,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 20),
                                  itemBuilder: (context, index) {
                                    return OrderHistoryItemShadow();
                                  });
                            })
                        : Container(),
                  ),
                  Container(
                    width: 1.sw,
                    height: 1.sh - 165,
                    child: tabIndex == 1
                        ? FutureBuilder<List>(
                            future: orderController.getOrderHistory(
                                authController.user.value!,
                                1,
                                languageController.activeLanguageId.value),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                return snapshot.data!.isEmpty
                                    ? Empty(message: "No uncompleted orders".tr)
                                    : ListView.builder(
                                        itemCount: snapshot.data!.length,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 20),
                                        itemBuilder: (context, index) {
                                          Map<String, dynamic> data =
                                              snapshot.data![index];
                                          return OrderHistoryItem(
                                            shopName: data['shop']['language']
                                                ['name'],
                                            status: 1,
                                            onTapBtn: () {
                                              if (data['delivery_boy'] !=
                                                  null) {
                                                ChatController chatController =
                                                    Get.put(ChatController());
                                                chatController.user.value =
                                                    ChatUser(
                                                        imageUrl:
                                                            data['delivery_boy']
                                                                ['image_url'],
                                                        name:
                                                            "${data['delivery_boy']['name']} ${data['delivery_boy']['surname']}",
                                                        id: data['delivery_boy']
                                                            ['id'],
                                                        role: 2);
                                              }

                                              orderController
                                                  .setActiveOrder(data);

                                              showSheet(data);
                                            },
                                            orderId: data['id'],
                                            orderDate: orderController
                                                .getTime(data['created_at']),
                                            amount: double.parse(
                                                data['total_sum'].toString()),
                                          );
                                        });
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }

                              return ListView.builder(
                                  itemCount: 4,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 20),
                                  itemBuilder: (context, index) {
                                    return OrderHistoryItemShadow();
                                  });
                            })
                        : Container(),
                  ),
                  Container(
                    width: 1.sw,
                    height: 1.sh - 165,
                    child: tabIndex == 2
                        ? FutureBuilder<List>(
                            future: orderController.getOrderHistory(
                                authController.user.value!,
                                5,
                                languageController.activeLanguageId.value),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                return snapshot.data!.isEmpty
                                    ? Empty(message: "No canceled orders".tr)
                                    : ListView.builder(
                                        itemCount: snapshot.data!.length,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 20),
                                        itemBuilder: (context, index) {
                                          Map<String, dynamic> data =
                                              snapshot.data![index];

                                          return OrderHistoryItem(
                                            shopName: data['shop']['language']
                                                ['name'],
                                            orderId: data['id'],
                                            status: 5,
                                            orderDate: orderController
                                                .getTime(data['created_at']),
                                            amount: double.parse(
                                                data['total_sum'].toString()),
                                          );
                                        });
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }

                              return ListView.builder(
                                  itemCount: 4,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 20),
                                  itemBuilder: (context, index) {
                                    return OrderHistoryItemShadow();
                                  });
                            })
                        : Container(),
                  ),
                ][tabIndex],
              )
            ],
          ),
        ),
      ),
    );
  }
}
