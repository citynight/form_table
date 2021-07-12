import 'package:flutter/material.dart';
import 'package:form_table/form_table/form_table_model.dart';

/// @Description
/// @CreateTime 2021/7/12 3:30 下午.
/// @author logan

class FormTableSelectorPage extends StatelessWidget {
  const FormTableSelectorPage({Key? key, required this.title, required this.options, required this.isMultipleSelector,}) : super(key: key);
  final String title;
  final List<FormTableOptionModel> options;
  final bool isMultipleSelector;
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          isMultipleSelector
              ? TextButton(
            child: Text(
              "完成",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onPressed: () {
              String values = options
                  .where((element) => element.selected)
                  .map((e) => e.value)
                  .toList()
                  .join(",");
              Navigator.of(context).pop(values);
            },
          )
              : SizedBox.shrink(),
        ],
      ),
      body: ListView.builder(
        itemCount: options.length,
        itemBuilder: (BuildContext context, int index) {
          return LTListTitle(options[index], isMultipleSelector, options);
        },
      ),
    );
  }
}
class LTListTitle extends StatefulWidget {
  LTListTitle(this.model, this.isMultipleSelector, this.options,{Key? key})
      : super(key: key);
  final FormTableOptionModel model;
  final bool isMultipleSelector;
  final List<FormTableOptionModel> options;

  @override
  _LTListTitleState createState() => _LTListTitleState();
}

class _LTListTitleState extends State<LTListTitle> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (widget.isMultipleSelector) {
          setState(() {
            widget.model.selected = !widget.model.selected;
          });
        } else {
          widget.options.map((e) => e.selected = false).toList();
          widget.model.selected = true;
          Navigator.of(context).pop(widget.model.value);
        }
      },
      selected: widget.model.selected,
      title: Text(widget.model.value),
      trailing: widget.isMultipleSelector && widget.model.selected
          ? Icon(Icons.done)
          : SizedBox.shrink(),
    );
  }
}