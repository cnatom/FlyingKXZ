
import 'package:flutter/material.dart';
import 'package:flying_kxz/ui/ui.dart';
import 'package:provider/provider.dart';

class ExamTempListView extends StatefulWidget {
  List<Map<String, dynamic>>? list;
  ExamTempListView({required this.list});
  @override
  _ExamTempListViewState createState() => _ExamTempListViewState();
}

class _ExamTempListViewState extends State<ExamTempListView> {
  List<Map<String, dynamic>> pre = [];
  List<Map<String, dynamic>> cur = [];
  late ThemeProvider themeProvider;
  @override
  void initState() {
    super.initState();
    pre.addAll(widget.list as Iterable<Map<String, dynamic>>);
    cur.addAll(widget.list as Iterable<Map<String, dynamic>>);
  } //结束时间
  _clear(){
    setState(() {
      cur.clear();
    });
  }
  _ok(){
    Navigator.pop(context,cur);
  }
  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: FlyBottomSheetScaffold(context,
          onCancel: ()=>_clear(),//返回先前的数据
          onDetermine: ()=>_ok(),//返回更改后的数据
          leftText: "清空",
          title: "考试列表 ("+cur.length.toString()+')',
          child:SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Wrap(
              runSpacing: spaceCardMarginBigTB,
              children: [for(int i = 0;i<cur.length;i++) _buildItem(cur[i],i)],
            ),
          )
      ),
    );
  }
  Widget _buildItem(Map<String,dynamic> item,int index){
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB, 0, spaceCardPaddingTB),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FlyText.title45(item['courseName'],maxLine: 2,),
                    SizedBox(height: 3,),
                    FlyText.main35('${item['dateTime']}',color:Color(0xff8d8d93))
                  ],
                ),
              ),
              IconButton(icon: Icon(Icons.delete_outline_rounded),onPressed: ()=>deleteElement(index),)
            ],
          ),
        ),
        Divider()
      ],
    );
  }
  deleteElement(int index){
    setState(() {
      cur.removeAt(index);
    });
  }

}
