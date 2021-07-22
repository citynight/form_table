import 'package:flutter/cupertino.dart';
import 'package:form_table/form_table/form_table_model.dart';

enum FormTableRowType {
  /// 输入
  input,

  /// 单选
  singleSelector,

  /// 多选
  multipleSelector,

  /// 自定义选择
  customSelector,
}

abstract class FormTableCloneable<T extends FormTableCloneable<T>> {
  T clone();
}

class FormTableRow implements FormTableCloneable<FormTableRow> {
  /// 唯一标识
  String? identifier;

  /// 类型
  FormTableRowType type;

  /// 标题
  String? title;

  /// 选择类型或者输入类型的值
  String? value;

  /// 输入框占位提示语
  String? placeholder;

  /// 是否隐藏标题
  bool? hiddenTitle;

  /// 能否编辑
  bool? enabled;

  /// 是否必填
  bool? require;

  /// 必填项是否显示 * 号
  bool? requireStar;

  /// 必填项校验不通过提示
  String? requireMsg;

  /// 自定义校验规则
  bool Function(FormTableRow)? validator;

  /// 输入框长度限制
  int? maxLength;

  /// 输入框内容是否加密
  bool? obscureText;

  /// 键盘类型
  TextInputType? keyboardType;

  /// 清除按钮显示模式
  OverlayVisibilityMode? clearButtonMode;

  /// 输入框文字对齐方式
  TextAlign? textAlign;

  /// 选择类型的选项，可以是纯字符串，也可以是 FormTableOptionModel 对象
  List? options;

  /// textfield 样式配置
  FormTableConfig? textFieldConfig;

  /// 输入事件
  void Function(FormTableRow)? onChanged;

  /// 点击事件
  Future Function(BuildContext, FormTableRow)? onTap;

  /// 自定义 Cell
  Widget? widget;

  /// 通过 builder 的方式自定义 suffixWidget
  Widget Function(BuildContext, FormTableRow)? suffixWidget;

  /// 通过 builder 的方式自定义 Cell
  Widget Function(BuildContext, FormTableRow)? customWidget;

  ///自定义 widget 对应的 state
  var state;

  /// 标记插入删除操作是否显示动画
  bool? animation;

  FormTableRow({
    this.identifier,
    this.type = FormTableRowType.input,
    this.title = "",
    this.value = "",
    this.placeholder = "",
    this.hiddenTitle = false,
    this.enabled = true,
    this.require = false,
    this.requireStar = false,
    this.requireMsg,
    this.validator,
    this.maxLength,
    this.obscureText,
    this.keyboardType,
    this.clearButtonMode,
    this.textAlign,
    this.options,
    this.textFieldConfig,
    this.onChanged,
    this.onTap,
    this.widget,
    this.state,
    this.suffixWidget,
    this.customWidget,
    this.animation,
  });

  FormTableRow.input({
    this.identifier,
    this.type = FormTableRowType.input,
    this.title = "",
    this.value = "",
    this.placeholder = "",
    this.hiddenTitle = false,
    this.enabled = true,
    this.require = false,
    this.requireStar = false,
    this.requireMsg,
    this.validator,
    this.maxLength,
    this.obscureText,
    this.keyboardType,
    this.clearButtonMode = OverlayVisibilityMode.editing,
    this.textAlign,
    this.options,
    this.textFieldConfig,
    this.onChanged,
    this.onTap,
    this.widget,
    this.state,
    this.suffixWidget,
    // this.customWidget,
    // this.animation ,
  }) {
    this.placeholder = "请输入$title";
  }

  FormTableRow.singleSelector(
      {this.identifier,
      this.title = "",
      this.value = "",
      this.placeholder = "请选择",
      this.require = true,
      this.requireStar = false,
      this.hiddenTitle = false,
      this.enabled = true,
      this.requireMsg,
      this.options,
      this.validator,
      this.textFieldConfig,
      this.suffixWidget,
      this.textAlign = TextAlign.right,
      this.type = FormTableRowType.singleSelector}) {
    this.placeholder = "请输入$title";
  }

  FormTableRow.multipleSelector(
      {this.identifier,
      this.title = "",
      this.value = "",
      this.placeholder = "请选择",
      this.require = true,
      this.requireStar = false,
      this.enabled = true,
      this.requireMsg,
      this.options,
      this.validator,
      this.textFieldConfig,
      this.suffixWidget,
      this.textAlign = TextAlign.right,
      this.type = FormTableRowType.multipleSelector}) {
    this.placeholder = "请输入$title";
  }

  FormTableRow.customSelector(
      {this.identifier,
      this.state,
      this.title = "",
      this.value = "",
      this.placeholder = "请选择",
      this.require = true,
      this.requireStar = false,
      this.hiddenTitle = false,
      this.enabled = true,
      this.requireMsg,
      this.options,
      this.onTap,
      this.validator,
      this.textFieldConfig,
      this.suffixWidget,
      this.textAlign = TextAlign.right,
      this.type = FormTableRowType.customSelector}) {
    this.placeholder = "请输入$title";
  }

  // 自定义无状态 cell
  FormTableRow.customCell(
      {this.identifier,
      this.title = "",
      this.value = "",
      this.widget,
      this.require = false,
      this.type = FormTableRowType.customSelector});

  // 自定义有状态的 cell 配合 state 使用
  FormTableRow.customCellBuilder(
      {this.identifier,
      this.state,
      this.title = "",
      this.value = "",
      this.customWidget,
      this.require = true,
      this.requireMsg,
      this.enabled = true,
      this.validator,
      this.onTap,
      this.onChanged,
      this.type = FormTableRowType.customSelector});

  @override
  FormTableRow clone() {
    return FormTableRow()
      ..identifier = identifier
      ..type = type
      ..title = title
      ..value = value
      ..placeholder = placeholder
      ..hiddenTitle = hiddenTitle
      ..enabled = enabled
      ..require = require
      ..requireStar = requireStar
      ..requireMsg = requireMsg
      ..validator = validator
      ..maxLength = maxLength
      ..obscureText = obscureText
      ..keyboardType = keyboardType
      ..clearButtonMode = clearButtonMode
      ..textAlign = textAlign
      ..options = options
      ..textFieldConfig = textFieldConfig
      ..onChanged = onChanged
      ..onTap = onTap
      ..widget = widget
      ..suffixWidget = suffixWidget
      ..customWidget = customWidget
      ..state = state
      ..animation = animation;
  }
}
