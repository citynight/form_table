import 'package:flutter/material.dart';

/// @Description
/// @CreateTime 2021/7/12 6:24 下午.
/// @author logan

class NextButton extends StatelessWidget {
  const NextButton({Key? key, this.title, required this.onPressed, required this.margin})
      : super(key: key);

  final title;
  final VoidCallback onPressed;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(double.infinity, 44)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(44 / 2)),
          ),
          backgroundColor:
          MaterialStateProperty.all(Theme.of(context).primaryColor)),
      child: Text(
        title,
        style: Theme.of(context).textTheme.button!.copyWith(color: Colors.white),
      ),
    );
  }
}