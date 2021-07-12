import 'package:flutter/material.dart';
import 'package:form_table/form_table.dart';
import 'package:form_table/form_table/form_table.dart';
import 'package:form_table_example/widgets/photos_cell.dart';
import 'package:form_table_example/widgets/verifitionc_code_button.dart';

import '../utils.dart';

/// @Description
/// @CreateTime 2021/7/12 6:34 下午.
/// @author logan

class FormPage extends StatelessWidget {
  FormPage({Key? key}) : super(key: key);
  final GlobalKey _formKey = GlobalKey<FormTableState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("表单"),
        actions: [
          TextButton(
            child: Text(
              "提交",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onPressed: () {
              //校验
              List errors = (_formKey.currentState as FormTableState).validate();
              if (errors.isNotEmpty) {
                showToast(errors.first);
                return;
              }
              //通过
              showToast("提交成功");
            },
          ),
        ],
      ),
      body: FormTable.builder(
        key: _formKey,
        rows: buildFormRows(),
        divider: Divider(
          height: 1,
        ),
      ),
    );
  }
}

List<FormTableRow> buildFormRows() {
  return [
    FormTableRow.input(
      title: "姓名",
      placeholder: "请输入姓名",
      value: "呀哈哈",
      textFieldConfig: FormTableConfig(
        height: 100,
        titleStyle: TextStyle(color: Colors.red, fontSize: 20),
        valueStyle: TextStyle(color: Colors.orange, fontSize: 30),
        placeholderStyle: TextStyle(color: Colors.green, fontSize: 25),
      ),
    ),
    FormTableRow.input(
      enabled: false,
      requireStar: true,
      title: "身份证号",
      placeholder: "请输入身份证号",
      value: "4101041991892382938293",
    ),
    FormTableRow.input(
      keyboardType: TextInputType.number,
      title: "预留手机号",
      placeholder: "请输入手机号",
      maxLength: 11,
      requireMsg: "请输入正确的手机号",
      requireStar: true,
      enabled: true,
      textAlign: TextAlign.right,
      validator: (row) {
        return RegExp(
            r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$')
            .hasMatch(row.value ?? "");
      },
    ),
    FormTableRow.input(
      title: "验证码",
      placeholder: "请输入验证码",
      suffixWidget: (context, row) {
        return VerifitionCodeButton(
          title: "获取验证码",
          seconds: 60,
          onPressed: () {
            showToast("验证码已发送");
          },
        );
      },
    ),
    FormTableRow.input(
      title: "* 密码",
      value: "123456",
      obscureText: true,
      state: false,
      placeholder: "请输入密码",
      suffixWidget: (context, row) {
        return GestureDetector(
          onTap: () {
            row.state = !row.state;
            row.obscureText = !(row.obscureText ?? false);
            FormTable.of(context).reload();
          },
          child: row.state
              ? Icon(
            Icons.visibility_off,
            size: 20.0,
            color: Colors.blueAccent,
          )
              : Icon(
            Icons.visibility,
            size: 20.0,
            color:  Colors.blueAccent,
          ),
        );
      },
    ),
    FormTableRow.customSelector(
      title: "婚姻状况",
      placeholder: "请选择",
      state: [
        ["未婚", "已婚"],
        [
          FormTableRow.input(
              title: "配偶姓名", placeholder: "请输入配偶姓名", requireStar: true),
          FormTableRow.input(
              title: "配偶电话", placeholder: "请输入配偶电话", requireStar: true)
        ]
      ],
      onTap: (context, row) async {
        String value = await showPicker(row.state[0], context);
        if (row.value != value) {
          if (value == "已婚") {
            FormTable.of(context).insert(row, row.state[1]);
          } else {
            FormTable.of(context).delete(row.state[1]);
          }
        }
        return value;
      },
    ),
    FormTableRow.singleSelector(
      title: "学历",
      placeholder: "请选择",
      options: [
        FormTableOptionModel(value: "专科"),
        FormTableOptionModel(value: "本科"),
        FormTableOptionModel(value: "硕士"),
        FormTableOptionModel(value: "博士")
      ],
    ),
    FormTableRow.multipleSelector(
      title: "家庭成员",
      placeholder: "请选择",
      options: [
        FormTableOptionModel(value: "父亲", selected: false),
        FormTableOptionModel(value: "母亲", selected: false),
        FormTableOptionModel(value: "儿子", selected: false),
        FormTableOptionModel(value: "女儿", selected: false)
      ],
    ),
    FormTableRow.customSelector(
      title: "出生年月",
      placeholder: "请选择",
      onTap: (context, row) async {
        return showPickerDate(context);
      },
      textFieldConfig: FormTableConfig(
        selectorIcon: SizedBox.shrink(),
      ),
    ),
    FormTableRow.customCell(
      widget: Container(
          color: Colors.grey[200],
          height: 48,
          width: double.infinity,
          alignment: Alignment.center,
          child: Text("------ 我是自定义的Cell ------")),
    ),
    FormTableRow.customCellBuilder(
      title: "房屋照片",
      state: [
        {"picurl": ""},
        {"picurl": ""},
        {"picurl": ""},
        {"picurl": ""},
        {"picurl": ""},
      ],
      requireMsg: "请完成上传房屋照片",
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
    ),
  ];
}
