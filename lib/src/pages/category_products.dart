import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '/src/components/category_item.dart';
import '/src/components/category_products_item.dart';
import '/src/components/empty.dart';
import '/src/components/shadows/category_item_shadow.dart';
import '/src/components/shadows/category_product_item_shadow.dart';
import '/src/controllers/category_controller.dart';
import '/src/models/category.dart';
import '/src/models/product.dart';

class CategoryProducts extends GetView<CategoryController> {
  final CategoryController categoryController = Get.put(CategoryController());
  int id = 3;
  Widget loading() {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CategoryProductItemShadow(),
            // CategoryProductItemShadow()
          ],
        ),
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: <Widget>[
        //     CategoryProductItemShadow(),
        //     // CategoryProductItemShadow()
        //   ],
        // ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      id = categoryController.activeCategory.value.id ?? 3;

      return SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        controller: controller.scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          width: 0.9.sw,
                          height: 0.06.sh,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(60)),
                          child: FutureBuilder<List<Category>>(
                            future: controller.getCategories(id, -1, 0),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<Category> categories = snapshot.data!;
                                return ListView.builder(
                                    itemCount: categories.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return CategoryItem(
                                        name: categories[index].name,
                                        id: categories[index].id,
                                        // isActive:
                                        //     controller.activeCategory.value ==
                                        //         categories[index],
                                        onClick: () =>
                                            controller.onChangeProductType(
                                                categories[index]),
                                      );
                                    });
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }
                              return ListView.builder(
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return CategoryItemShadow();
                                  });
                            },
                          )))
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 2.sh,
              child: FutureBuilder<List<Product>>(
                future: controller.getCategoryProducts(id, false),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      (!controller.load.value ||
                          controller.categoryProductList[id]!.isNotEmpty)) {
                    List<Widget> row = [];
                    if (snapshot.hasData) {
                      List<Product> products = snapshot.data ?? [];
                      return products.isNotEmpty
                          ? ListView.builder(
                              itemCount: products.length,
                              scrollDirection: Axis.vertical,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              itemBuilder: (context, index) {
                                Product product = products[index];
                                print(product.toString());
                                return Expanded(
                                  child: CategoryProductItem(
                                    product: products[index],
                                  ),
                                );
                              })
                          // added on 11-3-22
                          // : row.isEmpty
                          //     ? Empty(message: "No products".tr)
                          //     : Container(
                          //         padding: const EdgeInsets.symmetric(
                          //             horizontal: 15),
                          //         child: Column(
                          //           children: row.toList(),
                          //         ),
                          //       );
                          : Container(
                              child: Text(
                              "No data found",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ));
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    // for (int i = 0; i < products.length; i++) {
                    //   subRow.add(CategoryProductItem(
                    //     product: products[i],
                    //   ));

                    //   if ((i + 1) % 2 == 0 || (i + 1) == products.length) {
                    //     row.add(Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: subRow.toList(),
                    //     ));

                    //     subRow = [];
                    //   }
                    // }

                    return row.isEmpty
                        ? Empty(message: "No products".tr)
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              children: row.toList(),
                            ),
                          );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } /* else {
                    return Container(
                        child: Text(
                      "Select Categories",
                      style: TextStyle(color: Colors.black, fontSize: 10),
                    ));
                  }*/
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: loading(),
                  );
                },
              ),
            ),
            if (controller.load.value)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: loading(),
              )
          ],
        ),
      );
    });
  }
}
