import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vietnamtourism/main.dart';
import './model/tai-khoan.dart';
import 'package:vietnamtourism/register-page.dart';

import 'api.dart';
import 'package:http/http.dart' as http;
import 'manager-page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  List<ThongTinTaiKhoan> _taiKhoan = [];

  @override
  Widget build(BuildContext context) {
    Future userLogin() async {
      String email = _controller1.text;
      String password = _controller2.text;
      Iterable s = [];
      _taiKhoan.clear();
      var url =
          'http://10.0.2.2/vietnamtourism/api/dang_nhap.php?username=$email&password=$password';
      var response = await http.get(Uri.parse(url));
      s = jsonDecode(response.body);
      if (s.isNotEmpty) {
        _taiKhoan.add(new ThongTinTaiKhoan(
            id: int.parse(s.elementAt(0)["id"].toString()),
            ten_nguoi_dung: s.elementAt(0)["ten_nguoi_dung"].toString(),
            email: s.elementAt(0)["email"].toString(),
            mat_khau: s.elementAt(0)["mat_khau"].toString(),
            sdt: s.elementAt(0)["sdt"].toString().isNotEmpty
                ? s.elementAt(0)["sdt"].toString()
                : "",
            trangThai: int.parse(s.elementAt(0)["trang_thai"].toString()),
            loai_tai_khoan:
                int.parse(s.elementAt(0)["loai_tai_khoan"].toString())));
      }
      if (_taiKhoan.isNotEmpty) {
        if (_taiKhoan.first.loai_tai_khoan == 1) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ManagerPage(tk: _taiKhoan.elementAt(0))));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MyHomePage(id: s.elementAt(0)["id"].toString())));
        }
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => MyHomePage()));
      } else {
        showDialog(
            context: context,
            builder: (BuildContext) => AlertDialog(
                  title: Text('Thông báo'),
                  content: Text('Email và mật khẩu không trùng khớp !!!'),
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

    Widget imgSection = CircleAvatar(
      radius: 70,
      backgroundImage: AssetImage('assets/images/newdelhi.jpg'),
    );
    Widget TextSection = Container(
      child: Column(
        children: [
          Container(
            child: Text(
              'SignIn',
              style: TextStyle(fontSize: 35, color: Colors.white),
            ),
          ),
        ],
      ),
    );
    Widget LoginSection = Container(
      child: Column(
        children: [
          Container(
            width: 350,
            margin: EdgeInsets.only(bottom: 10),
            child: TextField(
              controller: _controller1,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Email',
                fillColor: Colors.white,
                filled: true,
              ),
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
            ),
          ),
          Container(
            width: 350,
            child: TextField(
              controller: _controller2,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Password',
                fillColor: Colors.white,
                filled: true,
              ),
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
            ),
          ),
        ],
      ),
    );
    Widget SignInButton = Container(
      width: 350,
      height: 50,
      child: TextButton(
        child: Text(
          'SIGN IN',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          if (_controller1.text.trim() == " " ||
              _controller2.text.trim() == "") {
            showDialog(
                context: context,
                builder: (BuildContext) => AlertDialog(
                      title: Text('Thông báo'),
                      content: Text('Chưa nhập thông tin!'),
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
            setState(() {
              userLogin().then((value){
                setState(() {
                  _controller1.text="";
                  _controller2.text="";
                });
              });
            });
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
        ),
      ),
    );
    Widget RegisterButton = Container(
      margin: EdgeInsets.only(top: 10),
      width: 350,
      height: 50,
      child: TextButton(
        child: Text(
          'REGISTER NOW',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => RegisterPage()));
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
        ),
      ),
    );
    Widget ExitButton = Container(
      margin: EdgeInsets.only(top: 10),
      width: 350,
      height: 50,
      child: TextButton(
        child: Text(
          'EXIT',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          exit(0);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
        ),
      ),
    );
    Widget ButtonSection = Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: [SignInButton, RegisterButton, ExitButton],
      ),
    );
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [imgSection, TextSection, LoginSection, ButtonSection],
        ),
      )),
    );
  }
}
