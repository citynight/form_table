import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_table/form_table/form_table_cell.dart';
import 'package:form_table/form_table/form_table_row.dart';

/// @Description
/// @CreateTime 2021/7/10 8:40 下午.
/// @author logan

enum FormTableType { column, sliver, builder, separated }

class FormTable extends StatefulWidget {
  final List<FormTableRow> rows;
  final FormTableType formTableType;
  final Divider divider;
  FormTable(
      {Key? key,
      required this.rows,
      required this.formTableType,
      required this.divider})
      : super(key: key);
  FormTable.sliver(
      {Key? key,
      required this.rows,
      this.formTableType = FormTableType.sliver,
      required this.divider})
      : super(key: key);
  FormTable.builder(
      {Key? key,
      required this.rows,
      this.formTableType = FormTableType.builder,
      required this.divider})
      : super(key: key);

  static FormTableState of(BuildContext context) {
    //定义一个便捷方法，方便子树中的widget获取共享数据  dependOnInheritedWidgetOfExactType 数据共享
    final _FormTableScope? scope =
        context.dependOnInheritedWidgetOfExactType<_FormTableScope>();
    return scope!.state;
  }

  @override
  FormTableState createState() => FormTableState(this.rows);
}

class FormTableState extends State<FormTable> {
  List<FormTableRow> rows;
  get form => widget;
  get divider => widget.divider;
  FormTableState(this.rows);
  @override
  Widget build(BuildContext context) {
    return _FormTableScope(
      child: _FormTableList(
        type: widget.formTableType,
      ),
      state: this,
    );
  }

  /// 表单插入，可以是单个 row，也可以使一组 rows
  void insert(currentRow, item) {
    if (item is List<FormTableRow>) {
      rows.insertAll(rows.indexOf(currentRow) + 1,
          item.map((e) => e..animation = true).toList());
    } else if (item is FormTableRow) {
      rows.insert(rows.indexOf(currentRow), item..animation = true);
    }
    reload();
  }

  /// 表单删除，可以是单个 row，也可以使一组 rows
  void delete(item) {
    if (item is List<FormTableRow>) {
      item.forEach((element) {
        rows.remove(element);
      });
    } else if (item is FormTableRow) {
      rows.remove(item);
    }
    reload();
  }

  /// 更新表单
  void reload() {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      rows = [...widget.rows];
    });
  }

  /// 更换表单
  void updateRows(List<FormTableRow> rows) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      this.rows = rows;
    });
  }

  /// 验证表单
  List validate() {
    FocusScope.of(context).requestFocus(FocusNode());
    List errors = _formValidationErrors(rows);
    return errors;
  }
}

class _FormTableScope extends InheritedWidget {
  const _FormTableScope({
    Key? key,
    required Widget child,
    required this.state,
  }) : super(key: key, child: child);

  final FormTableState state;
  get rows => state.rows;

  @override
  bool updateShouldNotify(_FormTableScope old) => rows != old.rows;
}

class _FormTableList extends StatelessWidget {
  const _FormTableList({Key? key, required this.type}) : super(key: key);

  final FormTableType type;

  @override
  Widget build(BuildContext context) {
    final rows = FormTable.of(context).rows;
    Widget list = new SizedBox(
      height: 1,
    );
    switch (type) {
      case FormTableType.column:
        list = GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Column(
            children: rows.map((e) {
              return FormTableCell(row: e);
            }).toList(),
          ),
        );
        break;
      case FormTableType.sliver:
        list = SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
          return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: FormTableCell(row: rows[index]));
        }, childCount: rows.length));
        break;
      case FormTableType.builder:
        list = GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: ListView.builder(
            itemCount: rows.length,
            itemBuilder: (BuildContext context, int index) {
              return FormTableCell(row: rows[index]);
            },
          ),
        );
        break;
      case FormTableType.separated:
        list = ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return FormTableCell(row: rows[index]);
            },
            separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: CupertinoColors.secondarySystemGroupedBackground,
                ),
            itemCount: rows.length);
        break;
      default:
        break;
    }
    return list;
  }
}

List _formValidationErrors(List<FormTableRow> rows) {
  List errors = [];
  rows.forEach((FormTableRow row) {
    if (row.validator != null) {
      bool isSuccess = row.validator!(row);
      if (!isSuccess) {
        errors.add(row.requireMsg ?? "${row.title?.replaceAll("*", "")} 不能为空");
      }
    } else {
      if (row.require ?? false) {
        if (row.value == null || row.value!.length == 0) {
          errors
              .add(row.requireMsg ?? "${row.title?.replaceAll("*", "")} 不能为空");
        }
      }
    }
  });
  return errors;
}
