import 'package:flutter/material.dart';
import 'package:form_table/form_table/form_table.dart';
import 'package:form_table/form_table/form_table_row.dart';
import 'package:form_table/form_table/form_table_text_field.dart';

/// @Description
/// @CreateTime 2021/7/12 4:13 下午.
/// @author logan

class FormTableCell extends StatefulWidget {
  final FormTableRow row;
  const FormTableCell({Key? key, required this.row}) : super(key: key);

  @override
  _FormTableCellState createState() => _FormTableCellState();
}

class _FormTableCellState extends State<FormTableCell> {
  get row => widget.row;

  @override
  Widget build(BuildContext context) {
    // cell
    Widget widget;
    if (row.widget != null) {
      widget = row.widget;
    } else if (row.customWidget != null) {
      widget = row.customWidget!(context, row);
    } else {
      widget = FormTableTextField(row: row);
    }
    widget = Container(
      child: widget,
      color: Colors.white,
    );

    // animation
    widget = row.animation ?? false
        ? TweenAnimationBuilder(
            child: widget,
            duration: Duration(milliseconds: 500),
            builder: (context, double value, child) {
              return Opacity(
                alwaysIncludeSemantics: true,
                opacity: value,
                child: child,
              );
            },
            tween: Tween(begin: 0.0, end: 1.0),
          )
        : widget;
    // divider
    widget = FormTable.of(context).divider != null &&
            row != FormTable.of(context).rows.last
        ? Column(
            children: [widget, FormTable.of(context).divider],
          )
        : widget;
    return widget;
  }
}
