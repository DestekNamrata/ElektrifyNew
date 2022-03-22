import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:samkuev/routes.dart';
import 'package:samkuev/src/controllers/about_controller.dart';
import 'package:samkuev/src/controllers/address_controller.dart';
import 'package:samkuev/src/controllers/auth_controller.dart';
import 'package:samkuev/src/controllers/banner_controller.dart';
import 'package:samkuev/src/controllers/brands_controller.dart';
import 'package:samkuev/src/controllers/category_controller.dart';
import 'package:samkuev/src/controllers/chat_controller.dart';
import 'package:samkuev/src/controllers/currency_controller.dart';
import 'package:samkuev/src/controllers/faq_controller.dart';
import 'package:samkuev/src/controllers/language_controller.dart';
import 'package:samkuev/src/controllers/notification_controller.dart';
import 'package:samkuev/src/controllers/order_controller.dart';
import 'package:samkuev/src/controllers/product_controller.dart';
import 'package:samkuev/src/controllers/savings_controller.dart';
import 'package:samkuev/src/controllers/settings_controller.dart';
import 'package:samkuev/src/controllers/sign_in_controller.dart';
import 'package:samkuev/src/controllers/sign_up_controller.dart';
import 'package:samkuev/src/themes/dark_theme.dart';
import 'package:samkuev/src/themes/light_theme.dart';
import 'package:samkuev/src/utils/http_oveerrides.dart';
import 'package:samkuev/translations.dart';
import 'src/controllers/shop_controller.dart';

void initialize() {
  Get.put<AuthController>(AuthController());
  Get.put<SignInController>(SignInController());
  Get.put<SignUpController>(SignUpController());
  Get.put<ShopController>(ShopController());
  Get.put<AddressController>(AddressController());
  Get.put<BannerController>(BannerController());
  Get.put<BrandsController>(BrandsController());
  Get.put<CategoryController>(CategoryController());
  Get.put<ProductController>(ProductController());
  Get.put<SavingsController>(SavingsController());
  Get.put<AboutControler>(AboutControler());
  Get.put<FaqController>(FaqController());
  Get.put<SettingsController>(SettingsController());
  Get.put<CurrencyController>(CurrencyController());
  Get.put<ChatController>(ChatController());
  Get.put<OrderController>(OrderController());
  Get.put<NotificationController>(NotificationController());
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  final LanguageController controller =
      Get.put<LanguageController>(LanguageController());
  // Map<String, Map<String, String>> translations =
  //     await controller.getMessages();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await GetStorage.init();
  initialize();
  runApp(MyApp(
      // translations: Messages(data: translations),
      ));

  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark);

    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}

class MyApp extends StatefulWidget {
  // final Messages translations;

  const MyApp({
    Key? key,
    //  required this.translations
  }) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageController>(builder: (languageController) {
      return ScreenUtilInit(
          designSize: const Size(414, 902),
          builder: () => GetMaterialApp(
              //navigatorKey: Catcher.navigatorKey,
              // translations: widget.translations,
              title: 'SamkuEv',
              debugShowCheckedModeBanner: false,
              theme: lightTheme(),
              darkTheme: darkTheme(),
              initialRoute: "/",
              getPages: AppRoutes.routes));
    });
  }
}
