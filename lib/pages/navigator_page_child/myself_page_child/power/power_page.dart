import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/picker.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/power/power_charge_page.dart';
import 'package:flying_kxz/util/logger/log.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/power/utils/provider.dart';
import 'package:flying_kxz/ui/ui.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/circular_view.dart';

void toPowerPage(BuildContext context) {
  Navigator.push(
      context, CupertinoPageRoute(builder: (context) => PowerPage()));
  Logger.log("Power", "进入", {});
}

class PowerPage extends StatefulWidget {
  @override
  _PowerPageState createState() => _PowerPageState();
}

class _PowerPageState extends State<PowerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _powerRoomidController =
      new TextEditingController(text: Prefs.powerRoomid ?? '');
  late ThemeProvider themeProvider;
  late PowerProvider powerProvider;
  String? powerPreviewText;
  String? powerBuilding;
  double? powerPercent;
  bool powerLoading = false;

  // 选择宿舍楼
  void _handlePowerPicker() async {
    showPicker(context, _scaffoldKey,
        title: "选择宿舍楼",
        pickerDatas: PowerProvider.apartment,
        colorRight: themeProvider.colorMain,
        isArray: false, onConfirm: (Picker picker, List value) {
      String home = picker.getSelectedValues()[0].toString();
      powerProvider.powerBuilding = home;
    });
  }

  // 跳转充值页面
  void _charge() {
    toPowerChargePage(context);

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    powerProvider = Provider.of<PowerProvider>(context, listen: false);
    powerPreviewText =
        context.select((PowerProvider p) => p.previewTextAtDetailPage);
    powerBuilding = context.select((PowerProvider p) => p.powerBuilding);
    powerPercent = context.select((PowerProvider p) => p.percentAtDetailPage);
    powerLoading = context.select((PowerProvider p) => p.powerLoading);
    return Scaffold(

      key: _scaffoldKey,
      appBar: FlyAppBar(context, "宿舍电量"),
      body: RefreshIndicator(
        color: themeProvider.colorMain,
        onRefresh: ()async{
          if(await Provider.of<PowerProvider>(context, listen: false).getPreview()){
            showToast("刷新成功：宿舍电量");
          }
        },
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // 触摸收起键盘
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(spaceCardMarginRL, spaceCardMarginTB,
                  spaceCardMarginRL, spaceCardMarginTB),
              child: Column(
                children: [
                  PowerCircularView(
                      powerPercent: powerPercent, themeProvider: themeProvider),
                  SizedBox(
                    height: spaceCardMarginTB * 2,
                  ),
                  FlyText.title50(
                    powerPreviewText,
                    color: themeProvider.colorMain,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: spaceCardMarginTB * 3,
                  ),
                  _buildPower(powerBuilding),
                  SizedBox(
                    height: spaceCardMarginTB,
                  ),
                  _container(
                      title: "充值",
                      child: Wrap(
                        runSpacing: spaceCardPaddingTB,
                        children: [
                          _buildButton("前往充值", primer:false,onTap: () => _charge()),
                        ],
                      )),
                  SizedBox(
                    height: spaceCardMarginTB,
                  ),
                  Center(child: FlyText.miniTip30("更新时间:"+powerProvider.requestDateTime),),
                  SizedBox(height: 200,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InkWell _buildButton(String title, {bool primer = true,GestureTapCallback? onTap}) {
    Color borderColor = primer?Colors.transparent:themeProvider.colorMain;
    Color textColor = primer?Colors.white:themeProvider.colorMain;
    Color backgroundColor = primer?themeProvider.colorMain:Colors.transparent;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(spaceCardMarginRL),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadiusValue),
            border: Border.all(color: borderColor),
            color: backgroundColor),
        child: Center(
          child: FlyText.title45(
            title,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDiyButton(String title,
      {required Widget child, GestureTapCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: fontSizeMain40 * 3.5,
        alignment: Alignment.center,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: FlyText.main35(
                title,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Expanded(
              flex: 5,
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewButton(String title, String previewStr,
      {GestureTapCallback? onTap}) {
    return _buildDiyButton(title,
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FlyText.main35(
              previewStr,
              color: Theme.of(context).primaryColor.withOpacity(0.5),
            ),
            SizedBox(
              width: fontSizeMini38,
            ),
            Icon(
              Icons.arrow_right_sharp,
              size: sizeIconMain50,
              color: Theme.of(context).primaryColor.withOpacity(0.5),
            )
          ],
        ));
  }

  Widget _buildInputButton(String title) {
    return _buildDiyButton(title,
        child: _buildInputBar("输入大寝室号(如 M2B421 )", _powerRoomidController));
  }

  Widget _container({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          color: Theme.of(context).cardColor),
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB / 2,
          spaceCardPaddingRL, spaceCardPaddingTB * 2),
      child: Wrap(
        runSpacing: spaceCardPaddingTB,
        children: [
          Container(),
          Row(
            children: [FlyText.mainTip40(title)],
          ),
          Divider(
            height: 0,
          ),
          child
        ],
      ),
    );
  }

  Widget _buildInputBar(String hintText, TextEditingController controller) {
    return TextFormField(
      textAlign: TextAlign.end,
      style: TextStyle(
          fontSize: fontSizeMain40,
          color: Theme.of(context).primaryColor.withOpacity(0.7)),
      controller: controller,
      //控制正在编辑的文本。通过其可以拿到输入的文本值
      cursorColor: colorMain,
      decoration: InputDecoration(
        hintStyle: TextStyle(
            fontSize: fontSizeMain40,
            color: Theme.of(context).primaryColor.withOpacity(0.5)),
        border: InputBorder.none, //下划线
        hintText: hintText, //点击后显示的提示语
      ),
    );
  }

  Widget _buildPower(String? powerBuilding) {
    return _container(
        title: "绑定信息",
        child: Wrap(runSpacing: spaceCardPaddingTB, children: [
          _buildPreviewButton("宿舍楼", powerBuilding ?? "未选择",
              onTap: () => _handlePowerPicker()),
          _buildInputButton("大寝号"),
          FlyWidgetBuilder(
              whenFirst: powerLoading,
              firstChild: _buildButton(
                "加载中……",
                onTap: () {},
              ),
              secondChild: _buildButton(
                "绑定 & 刷新",
                onTap: () {
                  powerProvider.powerRoomid =
                      _powerRoomidController.text ?? "";
                  powerProvider.bindInfoAndGetPower(context);
                },
              )),
        ]));
  }
}
