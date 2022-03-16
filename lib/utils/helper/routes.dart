import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:kuncie_test/view/home.dart';

class Routes {
  static const HOME = '/home';

  static final pages = [
    GetPage(name: HOME, page: () => HomeScreen()),
  ];
}