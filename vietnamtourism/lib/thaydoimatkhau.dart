import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  ChangePassword({required this.id});
  final String id;
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  Iterable user = [];
  bool _isHiddenOldPass = true;
  bool _isHiddenNewPass = true;
  bool _isHiddenConfirmNewPass = true;
  final TextEditingController _controllerOldPass = TextEditingController();
  final TextEditingController _controllerNewPass = TextEditingController();
  final TextEditingController _controllerConfirmNewPass =
      TextEditingController();

  Future<String> layInfoUser() async {
    String userid = widget.id;
    String url =
        "http://10.0.2.2/vietnamtourism/api/lay_thong_tin_tai_khoan.php?id=$userid";
    var res = await http.get(Uri.parse(url));
    var resBody = json.decode(res.body);
    setState(() {
      user = resBody;
      print(user);
    });

    return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    this.layInfoUser();
  }

  Future ChangePass() async {
    print("saoday");
    String oldPass = _controllerOldPass.text;
    String newPass = _controllerNewPass.text;
    String userId = widget.id;
    Iterable s = [];
    //  String url =
    //     "http://10.0.2.2/vietnamtourism/api/sua-mat-khau.php?id=$userId&password=$NewPass";
    // var res = await http.get(Uri.parse(url));
    // var resBody = json.decode(res.body);
    // setState(() {
    //   s = resBody;
    //   print(s);
    // });
    if (user.elementAt(0)["mat_khau"].toString() == oldPass) {
      String url =
          "http://10.0.2.2/vietnamtourism/api/sua-mat-khau.php?id=$userId&pass=$newPass";
      var res = await http.get(Uri.parse(url));
      var resBody = json.decode(res.body);
      setState(() {
        s = resBody;
        print(s);
      });
      if (s.isEmpty) {
        showDialog(
            context: context,
            builder: (BuildContext) => AlertDialog(
                  title: Text('Thông báo'),
                  content: Text('Thay đổi thành công'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text("OK"),
                    ),
                  ],
                ));
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext) => AlertDialog(
                title: Text('Thông báo'),
                content: Text('Mật khẩu cũ không đúng'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"),
                  ),
                ],
              ));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thay đổi mật khẩu"),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
              onPressed: () {
                if (_controllerOldPass.text.trim() == "" ||
                    _controllerNewPass.text.trim() == "" ||
                    _controllerConfirmNewPass.text.trim() == "") {
                  showDialog(
                      context: context,
                      builder: (BuildContext) => AlertDialog(
                            title: Text('Thông báo'),
                            content: Text('Vui lòng điền đủ thông tin'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("OK"),
                              ),
                            ],
                          ));
                } else if (_controllerConfirmNewPass.text == _controllerNewPass.text) {
                  ChangePass();
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext) => AlertDialog(
                            title: Text('Thông báo'),
                            content: Text('Hai mật khẩu không trùng nhau !!!'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("OK"),
                              ),
                            ],
                          ));
                }
              },
              child: Text(
                "Lưu",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            ListTile(
              title: TextField(
                controller: _controllerOldPass,
                obscureText: _isHiddenOldPass,
                decoration: InputDecoration(
                    labelText: 'Mật khẩu cũ',
                    suffixIcon: IconButton(
                        icon: Icon(_isHiddenOldPass
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isHiddenOldPass = !_isHiddenOldPass;
                          });
                        })),
              ),
            ),
            ListTile(
              title: TextField(
                controller: _controllerNewPass,
                obscureText: _isHiddenNewPass,
                decoration: InputDecoration(
                    labelText: 'Mật khẩu mới',
                    suffixIcon: IconButton(
                        icon: Icon(_isHiddenNewPass
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isHiddenNewPass = !_isHiddenNewPass;
                          });
                        })),
              ),
            ),
            ListTile(
              title: TextField(
                controller: _controllerConfirmNewPass,
                obscureText: _isHiddenConfirmNewPass,
                decoration: InputDecoration(
                    labelText: 'Nhập lại mật khẩu mới',
                    suffixIcon: IconButton(
                        icon: Icon(_isHiddenConfirmNewPass
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isHiddenConfirmNewPass = !_isHiddenConfirmNewPass;
                          });
                        })),
              ),
            )
          ],
        ),
      ),
    );
  }
}
