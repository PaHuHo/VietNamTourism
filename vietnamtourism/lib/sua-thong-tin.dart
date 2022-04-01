import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model/trang-thai.dart';

class UpdateInfoPersonal extends StatefulWidget {
  UpdateInfoPersonal({required this.id});
  final String id;
  @override
  _UpdateInfoPersonalState createState() => _UpdateInfoPersonalState();
}

class _UpdateInfoPersonalState extends State<UpdateInfoPersonal> {
  Iterable user = [];
  Iterable ttUser = [];
  List<GenderModel> genderModelList = [];
  String selectedTen = "";
  String selectedEmail = "";
  String selectedSDT = "";
  bool isClick = false;
  final TextEditingController _controllerTen = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSdt = TextEditingController();

  Future<String> layInfoUser() async {
    String userid = widget.id;
    String url =
        "http://10.0.2.2/vietnamtourism/api/lay_thong_tin_tai_khoan.php?id=$userid";
    var res = await http.get(Uri.parse(url));
    var resBody = json.decode(res.body);
    setState(() {
      user = resBody;
      _controllerTen.value = TextEditingValue(
          text: user.elementAt(0)["ten_nguoi_dung"].toString());
      _controllerEmail.value =
          TextEditingValue(text: user.elementAt(0)["email"].toString());
      user.elementAt(0)["sdt"].toString() != "null"
          ? _controllerSdt.value =
              TextEditingValue(text: user.elementAt(0)["sdt"].toString())
          : _controllerSdt.value = TextEditingValue(text: "");

      print(user);
    });

    return "Sucess";
  }

  Future<String> layTrangThaiOfUser() async {
    String userid = widget.id;
    String url =
        "http://10.0.2.2/vietnamtourism/api/lay_trang_thai.php?id=$userid";
    var res = await http.get(Uri.parse(url));
    var resBody = json.decode(res.body);
    setState(() {
      ttUser = resBody;
      selectedTen = ttUser.elementAt(0)["tt_ten"].toString();
      selectedEmail = ttUser.elementAt(0)["tt_email"].toString();
      selectedSDT = ttUser.elementAt(0)["tt_sdt"].toString();
      print(ttUser);
    });

    return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    this.layInfoUser();
    this.layTrangThaiOfUser();
  }

  void showModal(context, String _selectTen, String _selectEmail, String _selectSdt) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              padding: EdgeInsets.all(8),
              height: 200,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text("Tùy chọn", style: TextStyle(fontSize: 20)),
                  Expanded(
                    child: ListView.separated(
                        itemCount: genderModelList.length,
                        separatorBuilder: (context, int) {
                          return Divider();
                        },
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              setState(() {
                                if (_selectTen != "0") {
                                  selectedTen = (index + 1).toString();
                                }
                                if (_selectEmail != "0") {
                                  selectedEmail = (index + 1).toString();
                                }
                                if (_selectSdt != "0") {
                                  selectedSDT = (index + 1).toString();
                                }
                                return;
                              });
                            },
                            leading: Icon(
                              genderModelList[index].icon,
                              color: Colors.black,
                            ),
                            title: Text(
                              genderModelList[index].name,
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        }),
                  )
                ],
              ));
        });
  }

  Future UpdateCheck() async {
    String ten = _controllerTen.text;
    String sdt = _controllerSdt.text;
    String userId = widget.id;
    Iterable s = [];
    String url =
        "http://10.0.2.2/vietnamtourism/api/sua_thong_tin_ca_nhan.php?id=$userId&ten=$ten&sdt=$sdt&tt_ten=$selectedTen&tt_email=$selectedEmail&tt_sdt=$selectedSDT";
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
  }

  Widget build(BuildContext context) {
    genderModelList = [
      GenderModel('1', "Công khai", Icons.public),
      GenderModel('2', "Riêng tư", Icons.account_circle_sharp),
    ];
    return Scaffold(
        appBar: AppBar(
          title: Text("Giới thiệu về bạn"),
          centerTitle: true,
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  if (_controllerTen.text.trim() == "" ||
                      _controllerSdt.text.trim() == "") {
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
                  } else {
                    UpdateCheck();
                    //Navigator.pop(context);
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
              SizedBox(height: 50.0),
              ListTile(
                  title: TextField(
                    controller: _controllerTen,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Tên người dùng",
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      showModal(context, selectedTen, "0", "0");
                    },
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20.0)),
                        child: Container(
                          height: 70,
                          width: 70,
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          color: Colors.grey[300],
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                genderModelList[(int.parse(selectedTen) - 1)]
                                    .icon,
                                color: Colors.black,
                              ),
                              Icon(Icons.arrow_drop_down, color: Colors.black),
                            ],
                          ),
                        )),
                  )),
              SizedBox(height: 50.0),
              ListTile(
                  title: TextField(
                    enabled: false,
                    controller: _controllerEmail,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email",
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      showModal(context, "0", selectedEmail, "0");
                    },
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20.0)),
                        child: Container(
                          height: 70,
                          width: 70,
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          color: Colors.grey[300],
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                genderModelList[(int.parse(selectedEmail) - 1)]
                                    .icon,
                                color: Colors.black,
                              ),
                              Icon(Icons.arrow_drop_down, color: Colors.black),
                            ],
                          ),
                        )),
                  )),
              SizedBox(height: 50.0),
              ListTile(
                  title: TextField(
                    controller: _controllerSdt,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "SDT",
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      showModal(context, "0", "0", selectedSDT);
                    },
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20.0)),
                        child: Container(
                          height: 70,
                          width: 70,
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          color: Colors.grey[300],
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                genderModelList[(int.parse(selectedSDT) - 1)]
                                    .icon,
                                color: Colors.black,
                              ),
                              Icon(Icons.arrow_drop_down, color: Colors.black),
                            ],
                          ),
                        )),
                  )),
            ],
          ),
        ));
  }
}
