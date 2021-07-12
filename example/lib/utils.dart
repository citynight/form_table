
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// @Description
/// @CreateTime 2021/7/12 5:55 下午.
/// @author logan

void showToast(String text) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

Future<String> showPicker(List options, BuildContext context) async {
  String result = "";
  await Picker(
      height: 220,
      itemExtent: 38,
      adapter: PickerDataAdapter<String>(pickerdata: options),
      onConfirm: (Picker picker, List value) {
        result = options[value.first];
      }).showModal(context);
  return result;
}

Future<String> showPickerDate(BuildContext context) async {
  String result = "";
  await Picker(
      height: 220,
      itemExtent: 38,
      adapter: DateTimePickerAdapter(),
      onConfirm: (Picker picker, List value) {
        result = formatDate((picker.adapter as DateTimePickerAdapter).value!,
            [yyyy, '-', mm, '-', dd]);
        print((picker.adapter as DateTimePickerAdapter).value.toString());
      }).showModal(context);
  return result;
}

