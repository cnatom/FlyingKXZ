import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/components/point_components/point_array.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/components/point_components/point_matrix.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_provider.dart';
import 'package:provider/provider.dart';

class PointMain extends StatefulWidget {
  PointMain({Key key}):super(key:key);
  @override
  PointMainState createState() => PointMainState();
}

class PointMainState extends State<PointMain> {
  ThemeProvider themeProvider;
  bool showRight = false;
  GlobalKey<PointMatrixState> pointAreaKey = new GlobalKey<PointMatrixState>();
  show(){
    showRight = !showRight;
    setState(() {
    });
    pointAreaKey.currentState.changeWeekOffset(CourseProvider.curWeek);
  }
  initScroll(){
    pointAreaKey.currentState.changeWeekOffset(CourseProvider.initialWeek);
  }
  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      height: double.infinity,
      child: Row(
        children: [
          AnimatedCrossFade(
            firstCurve: Curves.easeOutCubic,
            secondCurve: Curves.easeOutCubic,
            sizeCurve: Curves.easeOutCubic,
            firstChild: Container(),
            secondChild: PointArray(colorMain: themeProvider.colorMain,),
            duration: Duration(milliseconds: 200),
            crossFadeState: showRight?CrossFadeState.showFirst:CrossFadeState.showSecond,
          ),
          AnimatedCrossFade(
            firstCurve: Curves.easeOutCubic,
            secondCurve: Curves.easeOutCubic,
            sizeCurve: Curves.easeOutCubic,
            firstChild: PointMatrix(key:pointAreaKey),
            secondChild: Container(),
            duration: Duration(milliseconds: 200),
            crossFadeState: showRight?CrossFadeState.showFirst:CrossFadeState.showSecond,
          )
        ],
      ),
    );
  }
}