import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:mop/mop.dart';

class AppletsPage extends StatefulWidget {
  @override
  _AppletsPageState createState() => _AppletsPageState();
}

class _AppletsPageState extends State<AppletsPage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> init() async {
    if (Platform.isIOS) {
      //com.finogeeks.mopExample
      final res = await Mop.instance.initialize(
          '22LyZEib0gLTQdU3MUauARlLry7JL/2fRpscC9kpGZQA', '1c11d7252c53e0b6',
          apiServer: 'https://mp.finogeeks.com', apiPrefix: '/api/v1/mop');
      print(res);
    } else if (Platform.isAndroid) {
      //com.finogeeks.mopexample
      final res = await Mop.instance.initialize(
          '22LyZEib0gLTQdU3MUauARjmmp6QmYgjGb3uHueys1oA', '98c49f97a031b555',
          apiServer: 'https://mp.finogeeks.com', apiPrefix: '/api/v1/mop');
      print(res);
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('凡泰极客小程序 Flutter 插件'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(
            top: 20,
          ),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  gradient: LinearGradient(
                    colors: const [Color(0xFF12767e), Color(0xFF0dabb8)],
                    stops: const [0.0, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: FlatButton(
                  onPressed: () {
                    Mop.instance.openApplet('5f92a45e9a6a7900019b5c27');
                  },
                  child: Text(
                    '打开示例小程序',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  gradient: LinearGradient(
                    colors: const [Color(0xFF12767e), Color(0xFF0dabb8)],
                    stops: const [0.0, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: FlatButton(
                  onPressed: () {
                    Mop.instance.openApplet('5e4d123647edd60001055df1',sequence: 1);
                  },
                  child: Text(
                    '打开官方小程序',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}