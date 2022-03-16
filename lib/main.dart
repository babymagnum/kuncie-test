import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kuncie_test/utils/helper/routes.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    Future.delayed(Duration(seconds: 2), () {
      FlutterNativeSplash.remove();
    });

    return GetMaterialApp(
      title: 'Kuncie Test',
      navigatorKey: Get.key,
      initialRoute: Routes.HOME,
      getPages: Routes.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}
