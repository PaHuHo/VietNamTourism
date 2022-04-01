import 'dart:convert';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AddDestination extends StatefulWidget {
  @override
  State<AddDestination> createState() => _AddDestinationState();
}

class _AddDestinationState extends State<AddDestination> {
  final TextEditingController _controllertendiadanh = TextEditingController();
  final TextEditingController _controllermota = TextEditingController();

  String ratingStar = "1";

  List dsLoaiDiaDanh = [];
  List dsVung = [];
  List dsMien = [];
  var _mySelectionLDD;
  var _mySelectionVung;
  var _mySelectionMien;


  Widget _buildRatingStars(double rating) {
    return RatingBarIndicator(
      rating: rating,
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemCount: 5,
      itemSize: 30.0,
    );
  }
    Future<String> layLoaiDiaDanh() async {
    String url = "http://10.0.2.2/vietnamtourism/api/lay_ds_loai_dia_danh.php?ver=2";
    var res = await http.get(Uri.parse(url));
    var resBody = json.decode(res.body);
    setState(() {
      dsLoaiDiaDanh = resBody;
      print(dsLoaiDiaDanh);
      _mySelectionLDD = dsLoaiDiaDanh.elementAt(0)["id"].toString();
    });

    return "Sucess";
  }

  Future CreateAdd() async {
    String tenDiaDanh = _controllertendiadanh.text;
    String moTa = _controllermota.text;
    String s = "";

    String url =
        "http://10.0.2.2/vietnamtourism/api/them_dia_danh.php?ten_dia_danh=$tenDiaDanh&sao_danh_gia=$ratingStar&mo_ta=$moTa&loai_dia_danh_id=$_mySelectionLDD&vung_id=$_mySelectionVung&mien_id=$_mySelectionMien";
    var res = await http.get(Uri.parse(url));
    var resBody = res.body;
    setState(() {
      s = resBody;
    });
    if (s=="pass") {
      showDialog(
          context: context,
          builder: (BuildContext) => AlertDialog(
                title: Text('Thông báo'),
                content: Text('Thêm thành công'),
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
    else{
      showDialog(
          context: context,
          builder: (BuildContext) => AlertDialog(
                title: Text('Thông báo'),
                content: Text('Thêm không thành công'),
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

  Future<String> layVung() async {
    String url = "http://10.0.2.2/vietnamtourism/api/lay_ds_vung.php?ver=2";
    var res = await http.get(Uri.parse(url));
    var resBody = json.decode(res.body);
    setState(() {
      dsVung = resBody;
      print(dsVung);
      _mySelectionVung = dsVung.elementAt(0)["id"].toString();
    });

    return "Sucess";
  }

  Future<String> layMien() async {
    String url = "http://10.0.2.2/vietnamtourism/api/lay_ds_mien.php?ver=2";
    var res = await http.get(Uri.parse(url));
    var resBody = json.decode(res.body);
    setState(() {
      dsMien = resBody;
      print(dsMien);
      _mySelectionMien = dsMien.elementAt(0)["id"].toString();
    });

    return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    this.layLoaiDiaDanh();
    this.layVung();
    this.layMien();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thêm địa danh"), actions: <Widget>[
        TextButton(
            onPressed: () {
              if (_controllertendiadanh.text.trim() == "" && _controllermota.text.trim()==""){
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
              }
              else{
                CreateAdd();
              }
            },
            child: Text(
              "Thêm",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ))
      ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            ListTile(
              title: TextField(
                maxLines: 2,
                controller: _controllertendiadanh,
                decoration: InputDecoration(
                  labelText: 'Tên địa danh',
                ),
              ),
            ),
             SizedBox(
              height: 20,
            ),
            ListTile(
              title: TextField(
                maxLines: 2,
                controller: _controllermota,
                decoration: InputDecoration(
                  labelText: 'Mô tả',
                ),
              ),
            ),
             SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 18),
                  child: Text('Loại địa danh: ',style: TextStyle(fontSize: 18)),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: DropdownButton(
                    alignment: AlignmentDirectional.bottomStart,
                    items: dsLoaiDiaDanh.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(
                          item['ten'],
                          style: TextStyle(fontSize: 14.0),
                        ),
                        value: item['id'].toString(),
                      );
                    }).toList(),
                    elevation: 16,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 25,
                        color: Colors.lightBlue),
                    underline: Container(
                      height: 2,
                      color: Colors.lightBlue,
                    ),
                    onChanged: (newVal) {
                      setState(() {
                        _mySelectionLDD = newVal.toString();
                        print(_mySelectionLDD);
                      });
                    },
                    value: _mySelectionLDD,
                    isDense: true,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 18),
                  child: Text('Loại vùng:',style: TextStyle(fontSize: 18)),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: DropdownButton(
                    alignment: AlignmentDirectional.bottomStart,
                    items: dsVung.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(
                          item['ten_vung'],
                          style: TextStyle(fontSize: 14.0),
                        ),
                        value: item['id'].toString(),
                      );
                    }).toList(),
                    elevation: 16,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 25,
                        color: Colors.lightBlue),
                    underline: Container(
                      height: 2,
                      color: Colors.lightBlue,
                    ),
                    onChanged: (newVal) {
                      setState(() {
                        _mySelectionVung = newVal.toString();
                        print(_mySelectionVung);
                      });
                    },
                    value: _mySelectionVung,
                    isDense: true,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 18),
                  child: Text('Loại miền:',style: TextStyle(fontSize: 18)),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: DropdownButton(
                    alignment: AlignmentDirectional.bottomStart,
                    items: dsMien.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(
                          item['ten_mien'],
                          style: TextStyle(fontSize: 14.0),
                        ),
                        value: item['id'].toString(),
                      );
                    }).toList(),
                    elevation: 16,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 25,
                        color: Colors.lightBlue),
                    underline: Container(
                      height: 2,
                      color: Colors.lightBlue,
                    ),
                    onChanged: (newVal) {
                      setState(() {
                        _mySelectionMien = newVal.toString();
                        print(_mySelectionMien);
                      });
                    },
                    value: _mySelectionMien,
                    isDense: true,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
                title: Text("Đánh giá: ",style: TextStyle(fontSize: 18)),
                trailing: RatingBar.builder(
                  initialRating: double.parse(ratingStar),
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    ratingStar = rating.toString();
                    print(ratingStar);
                  },
                )),
          ],
        ),
      ),
    );
  }
}
