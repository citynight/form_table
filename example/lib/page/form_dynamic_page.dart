import 'dart:convert';

import 'package:example/widgets/next_button.dart';
import 'package:example/widgets/photos_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_table/form_table.dart';
import 'package:form_table/form_table/form_table.dart';

import '../utils.dart';

/// @Description
/// @CreateTime 2021/7/12 6:48 下午.
/// @author logan

class FormDynamicPage extends StatelessWidget {
  FormDynamicPage({Key? key}) : super(key: key);

  final GlobalKey _dynamicFormKey = GlobalKey<FormTableState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("动态表单"),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return CustomScrollView(
              slivers: [
                FormTable.sliver(
                  key: _dynamicFormKey,
                  rows: snapshot.data,
                  divider: Divider(
                    height: 0.5,
                    thickness: 0.5,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 30, bottom: 30, left: 22, right: 22),
                    child: NextButton(
                      title: "提交",
                      onPressed: () {
                        //校验
                        List errors =
                        (_dynamicFormKey.currentState as FormTableState)
                            .validate();
                        if (errors.isNotEmpty) {
                          showToast(errors.first);
                          return;
                        }
                        //提交
                        showToast("成功");
                      }, margin: EdgeInsets.all(0),
                    ),
                  ),
                ),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

Future getData() async {
  final json = await rootBundle
      .loadString("lib/src/test.json");
  List form = jsonDecode(json)["data"]["form"];
  List<FormTableRow> rows = [];
  form.forEach((e) {
    FormTableRow row = getRow(e);
    if (row != null) {
      rows.add(row);
    }
  });
  return rows;
}

FormTableRow getRow(e) {
  int type = int.parse(e["type"]);
  late FormTableRow row;
  switch (type) {
    case 1:
      row = FormTableRow.input(
        identifier: e["proid"],
        title: e["title"],
        placeholder: e["hintvalue"],
        value: e["value"],
        enabled: e["editable"],
        maxLength: e["maxlength"] != null ? int.parse(e["maxlength"]) : null,
        require: e["mustinput"],
        requireStar: e["mustinput"],
      );
      break;
    case 2:
      row = FormTableRow.customSelector(
        identifier: e["proid"],
        title: e["title"],
        placeholder: e["hintvalue"],
        value: e["value"],
        enabled: e["editable"],
        require: e["mustinput"],
        requireStar: e["mustinput"],
        onTap: (context, row) async {
          return showPickerDate(context);
        },
      );
      break;
    case 4:
      row = FormTableRow.singleSelector(
        identifier: e["proid"],
        title: e["title"],
        placeholder: e["hintvalue"],
        value: e["value"],
        enabled: e["editable"],
        require: e["mustinput"],
        requireStar: e["mustinput"],
        options: (e["options"] as List).map((e) => e["selectvalue"]).toList(),
      );
      break;
    case 9:
      row = FormTableRow.customSelector(
        identifier: e["proid"],
        title: e["title"],
        placeholder: e["hintvalue"],
        value: e["value"],
        enabled: e["editable"],
        require: e["mustinput"],
        requireStar: e["mustinput"],
        options: (e["options"] as List).map((e) => e["selectvalue"]).toList(),
        onTap: (context, row) async {
          String value = await showPicker(row.options!, context);
          if (value == "已婚") {
            FormTable.of(context).insert(row, row.state);
          } else {
            FormTable.of(context).delete(row.state);
          }
          return value;
        },
      );
      (e["options"] as List).forEach((element) {
        if (element["isOpen"] == "1") {
          List<FormTableRow> rows = [];
          (element["extra"] as List).forEach((element) {
            rows.add(getRow(element));
          });
          row.state = rows;
        }
      });
      break;
    case 6:
      row = FormTableRow.input(
        identifier: e["proid"],
        title: e["title"],
        placeholder: e["hintvalue"],
        value: e["value"],
        enabled: e["editable"],
        require: e["mustinput"],
        requireStar: e["mustinput"],
        state: e["btnstate"],
        suffixWidget: (context, row) {
          return TextButton(
            onPressed: () {
              row.state = "1";
              showToast("验证成功");
            },
            child: Text(
              "验证",
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.blue),
            ),
          );
        },
        validator: (row) {
          if (!RegExp(
              r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$')
              .hasMatch(row.value ?? "")) {
            row.requireMsg = "请输入正确的${row.title}";
            return false;
          }
          if (row.state == "0") {
            row.requireMsg = "请完成${row.title}验证";
            return false;
          }
          return true;
        },
      );
      break;
    case 7:
      row = FormTableRow.customCellBuilder(
        identifier: e["proid"],
        title: e["title"],
        state: e["piclist"],
        validator: (row) {
          bool suc = (row.state as List)
              .every((element) => (element["picurl"].length > 0));
          if (!suc) {
            row.requireMsg = "请完成${row.title}上传";
          }
          return suc;
        },
        customWidget: (context, row) {
          return CustomPhotosWidget(row: row);
        },
      );
      break;
    default:
  }
  return row;
}
