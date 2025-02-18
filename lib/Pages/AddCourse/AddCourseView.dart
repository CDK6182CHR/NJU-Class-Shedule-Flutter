import '../../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import '../../Resources/Constant.dart';
import '../../Resources/Config.dart';
import '../../Components/Toast.dart';
import '../../Components/Dialog.dart';
import 'AddCoursePresenter.dart';

import 'Widgets/NodeDialog.dart';

class AddView extends StatefulWidget {
  const AddView({Key? key}) : super(key: key);

  @override
  _AddViewState createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  final AddCoursePresenter _presenter = AddCoursePresenter();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _teacherController = TextEditingController();

  final FocusNode nameTextFieldNode = FocusNode();
  final FocusNode teacherTextFieldNode = FocusNode();
  bool _classNameIsValid = true;

  // TODO: add multi node in one Widget
  Map _node = {
    'weekTime': 0,
    'startTime': 0,
    'endTime': 0,
    'classroom': '',
    'startWeek': 0,
    'endWeek': Config.MAX_WEEKS - 1,
    'weekType': Constant.FULL_WEEKS
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).add_manually_title),
        ),
        body: Builder(builder: (BuildContext context) {
          return Container(
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              child: Column(children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(5),
                ),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      icon: Icon(Icons.book,
                          color: Theme.of(context).primaryColor),
                      hintText: S.of(context).class_name,
                      errorText: _classNameIsValid
                          ? null
                          : S.of(context).class_name_empty),
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(teacherTextFieldNode),
                ),
                const Padding(
                  padding: EdgeInsets.all(5),
                ),
                TextField(
                  controller: _teacherController,
                  focusNode: teacherTextFieldNode,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    icon: Icon(Icons.account_circle,
                        color: Theme.of(context).primaryColor),
                    hintText: S.of(context).class_teacher,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                Row(children: <Widget>[
                  Icon(
                    Icons.code,
                    color: Theme.of(context).primaryColor,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8),
                  ),
                  InkWell(
                      child: Text(
                        Constant.WEEK_WITHOUT_BIAS[_node['weekTime']] +
                            ' ' +
                            S.of(context).class_duration(
                                (_node['startTime'] + 1).toString(),
                                (_node['endTime'] + 1).toString()) +
                            ' ' +
                            (_node['classroom']) +
                            ' ' +
                            Constant.WEEK_TYPES[_node['weekType']],
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor),
                      ),
                      onTap: () async {
                        Map newNode = (await showDialog<Map>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return NodeDialog(node: _node);
                            }))!;
                        setState(() {
                          _node = newNode;
                        });
                      })
                ]),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                SizedBox(
                    width: double.infinity,
                    child: TextButton(
                        child: Text(S.of(context).add_class),
                        onPressed: () async {
                          if (_nameController.text == '') {
                            setState(() {
                              _classNameIsValid = false;
                            });
                            return;
                          }
                          if (_node['startTime'] > _node['endTime']) {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  return MDialog(
                                    S
                                        .of(context)
                                        .class_num_invalid_dialog_title,
                                    Text(S
                                        .of(context)
                                        .class_num_invalid_dialog_content),
                                    widgetOKAction: () {
                                      Navigator.of(context).pop();
                                    },
                                  );
                                });
                            return;
                          }
                          if (_node['startWeek'] > _node['endWeek']) {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  return MDialog(
                                    S.of(context).week_num_invalid_dialog_title,
                                    Text(S
                                        .of(context)
                                        .week_num_invalid_dialog_content),
                                    widgetOKAction: () {
                                      Navigator.of(context).pop();
                                    },
                                  );
                                });
                            return;
                          }
                          bool result = await _presenter.addCourse(
                              context,
                              _nameController.text,
                              _teacherController.text,
                              [_node]);
                          if (result) {
                            UmengCommonSdk.onEvent("class_import",
                                {"type": "manual", "action": "success"});
                            Toast.showToast(
                                S.of(context).add_manually_success_toast,
                                context);
                          }
                          Navigator.of(context).pop(true);
                        }))
              ]));
        }));
  }
}
