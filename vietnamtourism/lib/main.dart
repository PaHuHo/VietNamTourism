// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vietnamtourism/diadanhluutru.dart';
import 'package:vietnamtourism/homepage.dart';
import 'package:vietnamtourism/personal-info.dart';
import 'package:vietnamtourism/trangcanhan.dart';
import './vung.dart';
import 'package:http/http.dart' as http;
import 'chitietvung.dart';
import 'destination.dart';
import 'login-page.dart';

void main() {
  runApp(MaterialApp(
    title: 'Viet Name Tourism',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Roboto',
    ),
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.id});
  final String id;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Iterable user = [];
  int selectedIndex = 0;
  List<Widget> pageList = <Widget>[
    Column(),
    Column(),
    DiaDanhLuuTru(),
    Column(),
  ];

  Future<String> layInfoUser() async {
    String userid = widget.id;
    String url =
        "http://10.0.2.2/vietnamtourism/api/lay_thong_tin_tai_khoan.php?id=$userid";
    var res = await http.get(Uri.parse(url));
    var resBody = json.decode(res.body);
    setState(() {
      user = resBody;
      print(user);
      pageList[0] = HomePage(userId: widget.id);
      pageList[1] = DiaDanh(userId: widget.id);
      pageList[3] = Vung(userId: widget.id);

    });
    
    return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    this.layInfoUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Viet Name Tourism'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/santorini.jpg'),
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>TaiKhoan(id: user.elementAt(0)["id"].toString(),userId: user.elementAt(0)["id"].toString(),)));
                  },
                )),
          )
        ],
      ),
      body: pageList[selectedIndex],
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          AssetImage('assets/images/santorini.jpg'),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>TaiKhoan(id: user.elementAt(0)["id"].toString(),userId: user.elementAt(0)["id"].toString(),)));
                        },
                      )),
                  Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Flexible(
                          child: Text(
                        user.elementAt(0)["ten_nguoi_dung"].toString(),
                        style: TextStyle(fontSize: 15),
                      ))),
                ],
              )),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.person),
                Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text('Thông tin cá nhân')),
              ],
            ),
            onTap: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InfoPersonal(
                              id: user.elementAt(0)["id"].toString())))
                  .then((value) {
                this.layInfoUser();
              });
            },
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.logout),
                Container(
                    margin: EdgeInsets.only(left: 10), child: Text('Đăng xuất'))
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          )
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_location),
            label: 'Địa danh',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_location_outlined),
            label: 'Địa danh lưu trú',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_location_alt_rounded),
            label: 'Vùng',
          ),
        ],
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
      ),
    );
  }
}
