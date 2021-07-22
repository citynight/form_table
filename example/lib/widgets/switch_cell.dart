import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_table/form_table.dart';

class SwitchCell extends StatefulWidget {
  final FormTableRow row;
  const SwitchCell({Key? key, required this.row}) : super(key: key);

  @override
  _SwitchCellState createState() => _SwitchCellState();
}

class _SwitchCellState extends State<SwitchCell> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 48,
            alignment: Alignment.centerLeft,
            child: Text(
              widget.row.title ?? "",
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
          Container(
            height: 48,
            width: 80,
            child: CupertinoSwitch(
              value: widget.row.value == "1",
              onChanged: (bool value) {
                if (widget.row.enabled == false) {
                  return;
                }
                setState(() {
                  widget.row.value = value ? "1" : "0";
                });
                if (widget.row.onChanged != null)
                  widget.row.onChanged!(widget.row);
              },
            ),
          ),
        ],
      ),
    );
  }
}
