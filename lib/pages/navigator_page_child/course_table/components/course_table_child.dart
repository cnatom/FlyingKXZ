import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_color.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_data.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_provider.dart';
import 'package:flying_kxz/ui/ui.dart';
import 'package:provider/provider.dart';

class CourseTableChild extends StatefulWidget {
  final List<CourseData> courseList;//本周的课程数据
  final double height;
  final double width;
  final double maxLessonNum;
  CourseTableChild(this.courseList,this.width,this.height,this.maxLessonNum);
  @override
  _CourseTableChildState createState() => _CourseTableChildState();
}

class _CourseTableChildState extends State<CourseTableChild> {
  late double unitHeight;
  late double unitWidth;
  List<Widget> cards = [];
  @override
  Widget build(BuildContext context) {
    _init();
    return Stack(
      children: cards,
    );
  }
  void _init(){
    cards.clear();
    this.unitHeight = widget.height/widget.maxLessonNum;
    this.unitWidth = widget.width/7.0;
    for(var course in widget.courseList){
      List<CourseData> cardsData = [];
      for(var temp in widget.courseList){
        if(temp.lessonNum==course.lessonNum&&temp.weekNum==course.weekNum){
          cardsData.add(temp);
        }
      }
      cards.add(CourseCard(course, unitHeight, unitWidth,cardsData));
    }
  }


}


class CourseCard extends StatefulWidget {
  final CourseData? courseData;
  final double unitHeight;
  final double unitWidth;
  final List<CourseData> clickData;
  CourseCard(this.courseData,this.unitHeight,this.unitWidth, this.clickData);

  @override
  _CourseCardState createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  late CourseProvider courseProvider;
  late ThemeProvider themeProvider;
  late Color cardColor;
  late bool isRepeat;
  @override
  Widget build(BuildContext context) {
    courseProvider = Provider.of<CourseProvider>(context);
    themeProvider = Provider.of<ThemeProvider>(context);
    cardColor = CourseColor.fromStr(widget.courseData?.title.toString());
    isRepeat = false;
    if(widget.clickData.length!=1){
      isRepeat = true;
      cardColor = Colors.grey;
    }
    if(widget.courseData!=null){
      return _buildCard();
    }else{
      return Container();
    }
  }



  EdgeInsets cardMargin()=>EdgeInsets.all(widget.unitWidth/40);
  EdgeInsets cardPadding()=>EdgeInsets.all(widget.unitWidth/35);
  void _handleClick(){
    List<Widget> children = [];
    for(var clickData in widget.clickData){
      children.add(_buildDialogCard(clickData));
    }
    showFlyDialog(context,
        child: SingleChildScrollView(
          child: Wrap(
            runSpacing: fontSizeMini38,
            children: children,
          ),
        ));
  }
  
  Widget _buildCard(){
    double top = (widget.courseData!.lessonNum!-1)*widget.unitHeight;
    double left = (widget.courseData!.weekNum!-1)*widget.unitWidth;
    double height = widget.unitHeight*widget.courseData!.durationNum!;
    return Positioned(
      top:top,
      left:left,
      child:  InkWell(
        onTap: ()=>_handleClick(),
        child: Container(
          height: isRepeat?widget.unitHeight*2:height,
          width: widget.unitWidth,
          padding: cardMargin(),
          child: Container(
            padding: cardPadding(),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: cardColor.withOpacity(0.9)
            ),
            child: _buildCardInfo(),
          ),
        ),
      ),
    );
  }

  Widget _buildCardInfo(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCardText(isRepeat?"重叠课":widget.courseData!.title!, fontSizeTip33),
        SizedBox(height: ScreenUtil().setSp(10),),
        _buildCardText(isRepeat?"点击查看":widget.courseData!.location!, fontSizeTipMini25)
      ],
    );
  }
  //详细信息卡片
  Widget _buildDialogCard(CourseData courseData) {
    Widget rowKbContent(
        String title, String content) {
      return Column(
        children: [
          SizedBox(height: fontSizeMini38 / 2,),
          title=="周次"?SizedBox(height: fontSizeMini38,):Container(),
          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: <Widget>[
              FlyText.mainTip35(
                "$title     ",
              ),
              Expanded(
                child: FlyText.main35(content, maxLine: 3),
              )
            ],
          ),

        ],
      );
    }

    return Container(
      padding: EdgeInsets.fromLTRB(
          fontSizeMini38 * 2, 0,
          fontSizeMini38,
          fontSizeMini38),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              borderRadiusValue),
          color: Theme.of(context)
              .dialogBackgroundColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Column(
            children: [
              SizedBox(height: fontSizeMini38 * 1.5,),
              Row(
                children: [
                  Container(
                    height: fontSizeTitle45,
                    width: fontSizeTitle45 / 4.5,
                    decoration: BoxDecoration(
                        color: CourseColor.fromStr(courseData.title),
                        borderRadius: BorderRadius.circular(100)
                    ),
                  ),
                  SizedBox(
                    width: fontSizeTitle45 * 0.6,
                  ),
                  Expanded(
                    child: FlyText.title45(
                      courseData.title,
                      maxLine: 3,
                    ),
                  ),

                ],
              ),
              Padding(
                padding: EdgeInsets.all(
                    fontSizeTitle45 * 0.8),
                child: Column(
                  children: [
                    courseData.location!=''?rowKbContent('地点', courseData.location!):Container(),
                    courseData.teacher!=''?rowKbContent('老师', courseData.teacher!):Container(),
                    courseData.remark!=''?rowKbContent('备注', courseData.remark!):Container(),
                    courseData.credit!=''?rowKbContent('学分', courseData.credit!):Container(),
                    rowKbContent('周次', CourseData.weekListToString(courseData.weekList)),
                    isRepeat?rowKbContent('节次', "${courseData.lessonNum}-${courseData.lessonNum!+courseData.durationNum!-1}"):Container(),
                  ],
                ),
              )
            ],
          ),),
          Column(
            children: [
              SizedBox(height: fontSizeTip33,),
              IconButton(icon: Icon(Icons.delete_outline_rounded),onPressed: ()=>_delCourse(courseData),)
            ],
          )
        ],
      ),
    );
  }
  void _delCourse(CourseData delCourseData)async{
    if(await _willDel(delCourseData)){
      courseProvider.del(delCourseData);
    }

  }
  Future<bool> _willDel(CourseData courseData)async{
    bool? result;
    result =  await showDialogConfirm(context,
      title: '课程「${widget.courseData!.title}」的第${CourseData.weekListToString(courseData.weekList)}周的卡片会被删除。\n\n确定删除此课程?',
      onConfirm: ()=> Navigator.of(context).pop(true),
      onCancel: ()=> Navigator.of(context).pop(false)
    );
    if(result == null) return false;
    return result;
  }


  Widget _buildCardText(String text,double sp){
    int maxLines = widget.courseData!.durationNum==1?1:3;
    return Text(
      text,
      style: TextStyle(
          fontSize:
          sp,
          color: Colors.white,),
      textAlign: TextAlign.center,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }


}
