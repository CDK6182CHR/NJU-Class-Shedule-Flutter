import 'package:flutter/material.dart';
import '../../../Resources/Constant.dart';

class ClassTitle extends StatelessWidget {
  final int _maxShowClasses;
  final double _classTitleHeight;
  final double _classTitleWidth;
  final bool _isShowWeekTime;
  final bool _isWhiteMode;

  const ClassTitle(this._maxShowClasses, this._classTitleHeight,
      this._classTitleWidth, this._isShowWeekTime, this._isWhiteMode,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _classTitle = List.generate(
      _maxShowClasses,
      (int i) => SizedBox(
          height: _classTitleHeight,
          width: _classTitleWidth,
          child: Center(
              child: _isShowWeekTime
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text((i + 1).toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _isWhiteMode
                                    ? Colors.white
                                    : Colors.black)),
                        Text(
                          Constant.CLASS_TIME_LIST[i]['start'] +
                              '\n' +
                              Constant.CLASS_TIME_LIST[i]['end'],
                          style: TextStyle(
                              fontSize: 10,
                              color:
                                  _isWhiteMode ? Colors.white : Colors.black),
                        )
                      ],
                    )
                  : Text((i + 1).toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: _isWhiteMode ? Colors.white : Colors.black)))),
    );
    return Column(children: _classTitle);
  }
}
