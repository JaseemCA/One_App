import 'package:flutter/material.dart';
import 'package:oneappcounter/common/color/appcolors.dart';

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final int tabCount;
  final List<String> tabLabels;

  final Color? labelColor;
  final Color? unselectedLabelColor;
  final TextStyle? labelStyle;
  final bool isScrolable;
  final TabAlignment? alignment;

  const CustomTabBar(
      {super.key,
      required this.tabCount,
      required this.tabLabels,
      this.labelColor,
      this.unselectedLabelColor,
      this.labelStyle,
      this.isScrolable = false,
      this.alignment});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: tabLabels
          .map((label) => Tab(
                text: label,
              ))
          .toList(),
      isScrollable: isScrolable,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(
          color: Appcolors.buttoncolor,
          width: 3.0,
        ),
      ),
      labelColor: labelColor ?? Colors.white,
      unselectedLabelColor:
          unselectedLabelColor ?? const Color.fromARGB(255, 205, 204, 204),
      labelStyle: labelStyle ??
          const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
      indicatorPadding: EdgeInsets.zero,
      tabAlignment: alignment,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
