import 'package:flutter/material.dart';

class FormTableOptionModel {
  final int? index;
  final String value;
  bool selected;
  FormTableOptionModel( {required this.value,this.index, this.selected = false});
}

class FormTableConfig {
  double? height;
  EdgeInsets? padding;
  TextStyle? titleStyle;
  TextStyle? valueStyle;
  TextStyle? placeholderStyle;
  Divider? divider;
  Widget? selectorIcon;
  Color? disableColor;
  FormTableConfig({
      this.height,
      this.padding,
      this.titleStyle,
      this.valueStyle,
      this.placeholderStyle,
      this.divider,
      this.selectorIcon,
      this.disableColor});
}
