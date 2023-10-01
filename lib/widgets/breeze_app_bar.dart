import 'package:inner_breeze/shared/breeze_style.dart';
import 'package:flutter/material.dart';

class BreezeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TextStyle? titleStyle;

  BreezeAppBar({required this.title, this.titleStyle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: titleStyle ?? BreezeStyle.header,
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Default AppBar height
}
