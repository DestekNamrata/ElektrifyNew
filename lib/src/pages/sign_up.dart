import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '/config/global_config.dart';
import '/src/components/extended_sign_button.dart';
import '/src/components/password_input.dart';
import '/src/components/sign_button.dart';
import '/src/components/text_input.dart';
import '/src/controllers/sign_up_controller.dart';

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final SignUpController controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? Color.fromRGBO(19, 20, 21, 1)
          : Color.fromRGBO(243, 243, 240, 1),
      body: SingleChildScrollView(
        child: Container(
          width: 1.sw,
          height: 1.sh,
          child: Stack(children: <Widget>[
            Container(
                width: 1.sw,
                height: 22,
                margin: EdgeInsets.only(top: 0.075.sh, right: 16, left: 30),
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset("lib/assets/images/dark_mode/samkuEV.png"),
                    InkWell(
                      onTap: () {
                        Get.toNamed("/signin");
                      },
                      child: Text(
                        "Sign In".tr,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 18.sp,
                            letterSpacing: -1,
                            color: Color.fromRGBO(69, 165, 36, 1)),
                      ),
                    ),
                  ],
                )),
            Positioned(
              bottom: 0,
              child: Container(
                  width: 1.sw,
                  padding: EdgeInsets.only(
                      top: 0.022.sh,
                      left: 0.0725.sw,
                      right: 0.0725.sw,
                      bottom: 0.08.sh),
                  decoration: BoxDecoration(
                      color: Get.isDarkMode
                          ? Color.fromRGBO(37, 48, 63, 1)
                          : Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Sign Up".tr,
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 35.sp,
                                letterSpacing: -2,
                                color: Get.isDarkMode
                                    ? Color.fromRGBO(255, 255, 255, 1)
                                    : Color.fromRGBO(0, 0, 0, 1)),
                          ),
                          margin: EdgeInsets.only(bottom: 0.023.sh),
                        ),
                        SizedBox(
                            height: 0.55.sh,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  TextInput(
                                    title: "Name".tr,
                                    placeholder: "Joe",
                                    defaultValue: controller.name.value,
                                    onChange: controller.onChangeName,
                                  ),
                                  Divider(
                                    color: Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(0, 0, 0, 1),
                                    height: 1,
                                  ),
                                  TextInput(
                                    title: "Surname".tr,
                                    placeholder: "Antonio",
                                    defaultValue: controller.surname.value,
                                    onChange: controller.onChangeSurname,
                                  ),
                                  Divider(
                                    color: Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(0, 0, 0, 1),
                                    height: 1,
                                  ),
                                  TextInput(
                                    title: "Car/Bike Name*".tr,
                                    placeholder: "Antonio",
                                    defaultValue: controller.bikeName.value,
                                    onChange: controller.onChangeBikeName,
                                  ),
                                  Divider(
                                    color: Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(0, 0, 0, 1),
                                    height: 1,
                                  ),
                                  TextInput(
                                    title: "Car/Bike Number*".tr,
                                    placeholder: "Antonio",
                                    defaultValue: controller.bikenumber.value,
                                    onChange: controller.onChangeBikeNumber,
                                  ),
                                  Divider(
                                    color: Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(0, 0, 0, 1),
                                    height: 1,
                                  ),
                                  TextInput(
                                    title: "Model Number".tr,
                                    placeholder: "Antonio",
                                    defaultValue: controller.modelnumber.value,
                                    onChange: controller.onChangeModelNumber,
                                  ),
                                  Divider(
                                    color: Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(0, 0, 0, 1),
                                    height: 1,
                                  ),
                                  TextInput(
                                    title: "Email Id*".tr,
                                    placeholder: "Antonio",
                                    defaultValue: controller.email.value,
                                    onChange: controller.onChangeEmail,
                                  ),
                                  Divider(
                                    color: Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(0, 0, 0, 1),
                                    height: 1,
                                  ),
                                  TextInput(
                                      title: "Phone number".tr,
                                      prefix: "+91",
                                      defaultValue: controller.phone.value,
                                      type: TextInputType.number,
                                      onChange: controller.onChangePhone,
                                      placeholder: "+91 8909000000"),
                                  Divider(
                                    color: Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(0, 0, 0, 1),
                                    height: 1,
                                  ),
                                  PasswordInput(
                                    title: "Password".tr,
                                    onChange: controller.onChangePassword,
                                  ),
                                  Divider(
                                    color: Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(0, 0, 0, 1),
                                    height: 1,
                                  ),
                                  PasswordInput(
                                    title: "Confrim Password".tr,
                                    onChange:
                                        controller.onChangePasswordConfirm,
                                  ),
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 0.04.sh,
                        ),
                        SignButton(
                          title: "Sign Up".tr,
                          loading: controller.loading.value,
                          onClick: controller.signUpWithPhone,
                        )
                      ],
                    );
                  })),
            )
          ]),
        ),
      ),
    );
  }
}
