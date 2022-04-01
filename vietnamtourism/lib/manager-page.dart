import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vietnamtourism/model/tai-khoan.dart';

import 'api.dart';

class ManagerPage extends StatefulWidget {
  ManagerPage({required this.tk});
  final ThongTinTaiKhoan tk;
  @override
  _ManagerPageState createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  int selectedIndex = 0;
  
  Widget _quanLy = QuanLy();
  Widget _thongKe = ThongKe();

  Widget getBody() {
    if (this.selectedIndex == 0) {
      return this._quanLy;
    } else  {
      return this._thongKe;
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Viet Name Tourism'),
      ),
      body: this.getBody(),
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
                      backgroundImage: AssetImage('images/logo/logoMU.jpg'),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {},
                      )),
                  Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Flexible(child:Text(
                        widget.tk.ten_nguoi_dung,
                        style: TextStyle(fontSize: 15),
                      ))),
                ],
              )),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.person),
                Container(
                    margin: EdgeInsets.only(left: 10), child: Text('Tài khoản')),
              ],
            ),
            onTap: () {},
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
        currentIndex: this.selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            title: Text('Quản lý'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_sharp),
            title: Text('Thóng kê'),
          ),
        ],
        onTap: (int index) {
          this.onTapHandler(index);
        },
      ),
    );
  }

  void onTapHandler(int index) {
    this.setState(() {
      this.selectedIndex = index;
    });
  }
}

class QuanLy extends StatefulWidget {
  @override
  State<QuanLy> createState() => _QuanLyState();
}

class _QuanLyState extends State<QuanLy> {
  bool isUpdate=true;
  Iterable ds=[];
  Container _buildDSDiaDanh() {
    return Container(
      
        child: Expanded(
            child: ListView.builder(
                itemCount: ds.length,
                itemBuilder: (context, index) => ListTile(
                      leading: Image.asset(
                          'assets/images/hotel2.jpg',
                          width: 110,
                          fit: BoxFit.cover,
                        ),
                      title: Text(ds.elementAt(index)["ten_dia_danh"].toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.update,color: Colors.blue,)),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.delete,
                              color: Colors.red)),
                        ],
                      ),
                    ))));
  }

  @override
  Widget build(BuildContext context) {
    if (isUpdate == true) {
      API(url: "http://10.0.2.2/vietnamtourism/api/lay_ds_dia_danh.php")
          .getDataString()
          .then((value) {
        ds = json.decode(value);
        //s=value;
        isUpdate = false;
        setState(() {});
      });
    }
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: TextField(
            decoration: new InputDecoration(
              icon: new Icon(Icons.search),
              labelText: "Tìm kiếm địa danh",
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: const BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ),
        TextButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            onPressed: () => {},
            icon: Icon(
              Icons.add,color: Colors.green,size: 20,
            ),
            label: Text(
              'Thêm địa danh',style: TextStyle(color: Colors.green,fontSize: 20),
            ),
        ),
        _buildDSDiaDanh()
      ],
    );
  }
}

class ThongKe extends StatefulWidget {
  @override
  State<ThongKe> createState() => _ThongKeState();
}

class _ThongKeState extends State<ThongKe> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Thống kê'));
  }
}
