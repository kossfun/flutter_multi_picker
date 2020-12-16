import 'package:flutter/material.dart';

class MultiPickerTheme {
  MultiPickerTheme({
    this.tabHeight = 40.0,
    this.tabBgColor = Colors.white,
    this.tabIndicatorColor = Colors.blueAccent,
    this.tabIndicatorWidth = 30.0,
    this.tabIndicatorWeight = 2.0,
    this.tabLabelColor = Colors.blueAccent,
    this.tabUnselectedLabelColor = Colors.black87,
    this.tabLabelStyle,
    this.tabUnselectedLabelStyle,
    this.tabLabelPadding,
    this.tabBottomBorder =
        const BorderSide(color: Colors.transparent, width: 1),
    this.listLabelColor = Colors.blueAccent,
    this.listUnselectedLabelColor = Colors.black87,
    this.listLabelStyle,
    this.listUnselectedLabelStyle,
  });

  final double tabHeight;
  final Color tabBgColor;
  final Color tabIndicatorColor;
  final double tabIndicatorWeight;
  final double tabIndicatorWidth;
  final Color tabLabelColor;
  final Color tabUnselectedLabelColor;
  final TextStyle tabLabelStyle;
  final TextStyle tabUnselectedLabelStyle;
  final EdgeInsetsGeometry tabLabelPadding;
  final BorderSide tabBottomBorder;
  final Color listLabelColor;
  final Color listUnselectedLabelColor;
  final TextStyle listLabelStyle;
  final TextStyle listUnselectedLabelStyle;
}
