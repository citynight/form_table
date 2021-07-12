import 'package:flutter/material.dart';
import 'package:form_table/form_table.dart';
import 'package:form_table_example/widgets/select_image.dart';

/// @Description
/// @CreateTime 2021/7/12 6:26 下午.
/// @author logan

class CustomPhotosWidget extends StatelessWidget {
  CustomPhotosWidget({
    Key? key,
    required this.row,
  }) : super(key: key);

  final FormTableRow row;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        children: [
          Container(
            height: 48,
            alignment: Alignment.centerLeft,
            child: Text(
              row.title ?? "",
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: (row.state as List).length,
              itemBuilder: (BuildContext context, int index) {
                return SelectImageView(
                  selected: (image) async {
                    //实际情况是上传照片 返回图片URL，这里模拟数据使用路径
                    row.state[index]["picurl"] = image.path;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
