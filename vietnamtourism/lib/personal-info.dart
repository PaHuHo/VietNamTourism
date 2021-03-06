import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vietnamtourism/chitietdiadanh.dart';
import 'package:vietnamtourism/sua-thong-tin.dart';
import 'package:vietnamtourism/thaydoimatkhau.dart';
import 'package:vietnamtourism/themdiadanh.dart';

class InfoPersonal extends StatefulWidget {
  InfoPersonal({required this.id});
  final String id;
  @override
  _InfoPersonalState createState() => _InfoPersonalState();
}

class _InfoPersonalState extends State<InfoPersonal> {
  Iterable user = [];
  Iterable ttUser = [];
  Iterable baiViet = [];

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

  Future<String> layTrangThaiOfUser() async {
    String userid = widget.id;
    String url =
        "http://10.0.2.2/vietnamtourism/api/lay_trang_thai.php?id=$userid";
    var res = await http.get(Uri.parse(url));
    var resBody = json.decode(res.body);
    setState(() {
      ttUser = resBody;
      print(ttUser);
    });

    return "Sucess";
  }

  Future<String> layBaiVietOfUser() async {
    String userid = widget.id;
    String url =
        "http://10.0.2.2/vietnamtourism/api/lay_ds_bai_viet_theo_id.php?id=$userid";
    var res = await http.get(Uri.parse(url));
    var resBody = json.decode(res.body);
    setState(() {
      baiViet = resBody;
      print(baiViet);
    });

    return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    this.layInfoUser();
    this.layTrangThaiOfUser();
    this.layBaiVietOfUser();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildListTitle(IconData icon, String text) {
      return ListTile(
        leading: Icon(
          icon,
          color: Colors.black,
        ),
        title: Text(text),
      );
    }

    Widget _TrangThaiTrong() {
      if (ttUser.elementAt(0)["tt_ten"].toString() == "2" &&
          ttUser.elementAt(0)["tt_email"].toString() == "2" &&
          ttUser.elementAt(0)["tt_sdt"].toString() == "2") {
        return Text("Rieng tu");
      }
      return Row();
    }

    return Scaffold(
        backgroundColor: Colors.grey[100],
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Th??ng tin c?? nh??n"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage('assets/images/santorini.jpg'),
                ),
              ),
              Text(
                user.elementAt(0)["ten_nguoi_dung"].toString().toUpperCase(),
                style: const TextStyle(fontSize: 25),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    ListTile(
                      leading: Text(
                        "Gi???i thi???u",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      trailing: TextButton(
                          onPressed: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UpdateInfoPersonal(id: widget.id)))
                                .then((value) {
                              this.layInfoUser();
                              this.layTrangThaiOfUser();
                            });
                          },
                          child: Text("Ch???nh s???a",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400))),
                    ),
                    _TrangThaiTrong(),
                    ttUser.elementAt(0)["tt_ten"].toString() == "1"
                        ? _buildListTitle(Icons.account_circle,
                            user.elementAt(0)["ten_nguoi_dung"].toString())
                        : Row(),
                    ttUser.elementAt(0)["tt_email"].toString() == "1"
                        ? _buildListTitle(
                            Icons.email, user.elementAt(0)["email"].toString())
                        : Row(),
                    ttUser.elementAt(0)["tt_sdt"].toString() == "1"
                        ? _buildListTitle(
                            Icons.phone, user.elementAt(0)["sdt"].toString())
                        : Row(),
                  ],
                ),
              ),
              Card(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Text(
                          "Thi???p l???p",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.lock, color: Colors.black),
                        title: Text("Thay ?????i m???t kh???u"),
                        trailing: Icon(Icons.arrow_forward_sharp,
                            color: Colors.black),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChangePassword(id: widget.id)));
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.library_add_outlined,
                            color: Colors.black),
                        title: Text("Th??m d???a danh"),
                        trailing: Icon(Icons.arrow_forward_sharp,
                            color: Colors.black),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddDestination()));
                        },
                      )
                    ],
                  )),
              Card(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Text(
                          "Danh s??ch ?????a danh ???? ??i",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      baiViet.length > 0
                          ? Column(
                              children: List.generate(
                              baiViet.length,
                              (index) {
                                return ListTile(
                                  title: Text(baiViet
                                      .elementAt(index)["ten_dia_danh"]
                                      .toString()),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChiTietDiaDanh(
                                                    userId: widget.id,
                                                    diaDanhId: baiViet
                                                        .elementAt(index)[
                                                            "dia_danh_id"]
                                                        .toString())));
                                  },
                                );
                              },
                            ))
                          : Text(
                              "Kh??ng c?? d??? li???u v??? ?????a danh ???? ??i",
                              style: TextStyle(fontSize: 15),
                            ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  )),
            ],
          )),
        ));
  }
}
