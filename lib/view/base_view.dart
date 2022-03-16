import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuncie_test/utils/theme/theme_text_style.dart';

class BaseView extends StatelessWidget {
  final bool isUseAppbar;
  final String? title;
  final Widget? appbarContent;
  final Widget? appbarLeading;
  final Widget child;
  final bool resizeBottomInset;

  BaseView({this.isUseAppbar:false, this.resizeBottomInset = true, this.title, this.appbarContent, this.appbarLeading, required this.child});

  @override
  Widget build(BuildContext context) {
    Widget _appBar = AppBar(
      centerTitle: false,
      backgroundColor: Color(0xfffafafa),
      title: appbarContent ?? Text(title ?? '', style: ThemeTextStyle.interBold.copyWith(fontSize: 18, color: Colors.black)),
      leading: Row(
        children: [
          appbarLeading ?? IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back, color: Colors.black,)),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Color(0xfffafafa),
      appBar: isUseAppbar ? _appBar as PreferredSizeWidget? : null,
      resizeToAvoidBottomInset: resizeBottomInset,
      body: SafeArea(
        child: child,
      ),
    );
  }
}
