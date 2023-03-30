import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/cumt_login/util/account.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/cumt_login/util/login.dart';
import 'package:flying_kxz/ui/text.dart';
import 'package:flying_kxz/ui/theme.dart';
import 'package:provider/provider.dart';

enum StateTextAnimationDirection {
  up,
  down,
}

class CumtLoginStateText extends StatefulWidget {
  final String defaultText;
  final StateTextAnimationDirection Function(String oldText) onDirection;

  CumtLoginStateText({@required this.defaultText, this.onDirection});

  @override
  CumtLoginStateTextState createState() => CumtLoginStateTextState();
}

class CumtLoginStateTextState extends State<CumtLoginStateText>
    with
        WidgetsBindingObserver,
        AutomaticKeepAliveClientMixin,
        SingleTickerProviderStateMixin {
  String result;
  String oldResult = "";
  ThemeProvider themeProvider;
  CumtLoginAccount account = CumtLoginAccount();
  AnimationController _controller;
  Animation<double> _animation;
  StateTextAnimationDirection direction = StateTextAnimationDirection.down;
  @override
  void didUpdateWidget(covariant CumtLoginStateText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.defaultText != oldWidget.defaultText) {
      direction = widget.onDirection(oldWidget.defaultText);
      refreshText(widget.defaultText,);
      ;
    }
  }

  @override
  void initState() {
    super.initState();
    result=widget.defaultText;
    WidgetsBinding.instance.addObserver(this);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    autoLogin();
  }

  void refreshText(String newText) {
    oldResult = result;
    result = newText;
    _controller.reset();
    _controller.forward();
  }

  void autoLogin() async {
    if (account.isEmpty) {
      _controller.forward();
      return;
    }
    refreshText("正在登录校园网...");
    var res = await CumtLogin.autoLogin(account: account);
    await Future.delayed(Duration(seconds: 1));
    refreshText(res);
    await Future.delayed(Duration(seconds: 1));
    refreshText(widget.defaultText);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
  }

  /// 生命周期回调
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 在resumed的时候自动登录校园网
    if (state == AppLifecycleState.resumed) {
      autoLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    themeProvider = Provider.of<ThemeProvider>(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget child) {
        return Stack(
          children: [
            Transform.translate(
              offset: Offset(0.0, (-_animation.value * 10)*(direction.index*2-1)),
              child: Opacity(
                opacity: 1 - _animation.value,
                child: FlyText.title45(oldResult,
                    fontWeight: FontWeight.w600,
                    color: themeProvider.colorNavText),
              ),
            ),
            Transform.translate(
              offset: Offset(0.0, (1 - _animation.value) * 10*(direction.index*2-1)),
              child: Opacity(
                opacity: _animation.value,
                child: FlyText.title45(result,
                    fontWeight: FontWeight.w600,
                    color: themeProvider.colorNavText),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
