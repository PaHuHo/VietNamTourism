import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:vietnamtourism/chitietdiadanh.dart';
import 'package:http/http.dart' as http;
import 'package:vietnamtourism/share-destination.dart';
import 'api.dart';

class DiaDanh extends StatefulWidget {
  DiaDanh({Key? key ,required this.userId}) : super(key: key);
  final String userId;
  @override
  State<DiaDanh> createState() => _DiaDanhState();
}

class _DiaDanhState extends State<DiaDanh> {
  bool isUpdate = true;
  List dsLoaiDiaDanh = [];
  List dsVung = [];
  List dsMien = [];
  bool isFilter = false;
  Iterable dsDiaDanh = [];
  Iterable dsFind = [];
  bool isFind = false;
  var _mySelectionLDD;
  var _mySelectionVung;
  var _mySelectionMien;

  final _controller = TextEditingController();

  Future<void> _openGoogleMap(double x, double y) async {
    final availableMaps = await MapLauncher.installedMaps;
    await availableMaps.first.showMarker(
      coords: Coords(x, y),
      title: "Ocean Beach",
    );
  }

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
    String url = "http://10.0.2.2/vietnamtourism/api/lay_ds_loai_dia_danh.php?ver=1";
    var res = await http.get(Uri.parse(url));
    var resBody = json.decode(res.body);
    setState(() {
      dsLoaiDiaDanh = resBody;
      print(dsLoaiDiaDanh);
      _mySelectionLDD = dsLoaiDiaDanh.elementAt(0)["id"].toString();
    });

    return "Sucess";
  }

  Future<String> layVung() async {
    String url = "http://10.0.2.2/vietnamtourism/api/lay_ds_vung.php?ver=1";
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
    String url = "http://10.0.2.2/vietnamtourism/api/lay_ds_mien.php?ver=1";
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

  Widget _buildFilter() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Loại địa danh: ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
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
                        if (_mySelectionLDD == "0") {
                          if (isFind == true) {
                            dsFind = dsDiaDanh.where((element) =>
                                element["ten_dia_danh"]
                                    .toString().toLowerCase()
                                    .contains(_controller.text.toLowerCase()));
                          } else {
                            dsFind = dsDiaDanh;
                          }
                          if (_mySelectionVung != "0") {
                            dsFind = dsFind.where((element) =>
                                element["vung_id"].toString() ==
                                _mySelectionVung);
                          }
                          if (_mySelectionMien != "0") {
                            dsFind = dsFind.where((element) =>
                                element["mien_id"].toString() ==
                                _mySelectionMien);
                          }
                        } else {
                          if (isFind == true) {
                            dsFind = dsFind.where((element) =>
                                element["loai_dia_danh_id"].toString() ==
                                _mySelectionLDD);
                          } else {
                            dsFind = dsDiaDanh.where((element) =>
                                element["loai_dia_danh_id"].toString() ==
                                _mySelectionLDD);
                            setState(() {
                              isFind = true;
                            });
                          }
                        }
                      });
                    },
                    value: _mySelectionLDD,
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Vùng: ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
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
                        if (_mySelectionVung == "0") {
                          if (isFind == true) {
                            dsFind = dsDiaDanh.where((element) =>
                                element["ten_dia_danh"]
                                    .toString().toLowerCase()
                                    .contains(_controller.text.toLowerCase()));
                          } else {
                            dsFind = dsDiaDanh;
                          }
                          if (_mySelectionLDD != "0") {
                            dsFind = dsFind.where((element) =>
                                element["loai_dia_danh_id"].toString() ==
                                _mySelectionLDD);
                          }
                          if (_mySelectionMien != "0") {
                            dsFind = dsFind.where((element) =>
                                element["mien_id"].toString() ==
                                _mySelectionMien);
                          }
                        } else {
                          if (isFind == true) {
                            dsFind = dsFind.where((element) =>
                                element["vung_id"].toString() ==
                                _mySelectionVung);
                          } else {
                            dsFind = dsDiaDanh.where((element) =>
                                element["vung_id"].toString() ==
                                _mySelectionVung);
                            setState(() {
                              isFind = true;
                            });
                          }
                        }
                      });
                    },
                    value: _mySelectionVung,
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Miền: ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
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
                        if (_mySelectionMien == "0") {
                          if (isFind == true) {
                            dsFind = dsDiaDanh.where((element) =>
                                element["ten_dia_danh"]
                                    .toString().toLowerCase()
                                    .contains(_controller.text.toLowerCase()));
                          } else {
                            dsFind = dsDiaDanh;
                          }
                          if (_mySelectionLDD != "0") {
                            dsFind = dsFind.where((element) =>
                                element["loai_dia_danh_id"].toString() ==
                                _mySelectionLDD);
                          }
                          if (_mySelectionVung != "0") {
                            dsFind = dsFind.where((element) =>
                                element["vung_id"].toString() ==
                                _mySelectionVung);
                          }
                        } else {
                          if (isFind == true) {
                            dsFind = dsFind.where((element) =>
                                element["mien_id"].toString() ==
                                _mySelectionMien);
                          } else {
                            dsFind = dsDiaDanh.where((element) =>
                                element["mien_id"].toString() ==
                                _mySelectionMien);
                            setState(() {
                              isFind = true;
                            });
                          }
                        }
                      });
                    },
                    value: _mySelectionMien,
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDSDiaDanh(Iterable ds) {
    return Expanded(
      child: ListView.builder(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          itemCount: ds.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChiTietDiaDanh(
                                diaDanhId: ds.elementAt(index)['id'].toString(),
                                userId: widget.userId,
                              )));
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(40.0, 0, 20.0, 0),
                      height: 200.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(100.0, 20.0, 20.0, 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 210.0,
                                  child: Text(
                                    ds
                                        .elementAt(index)['ten_dia_danh']
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              ds.elementAt(index)['mo_ta'].toString(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            _buildRatingStars(double.parse(ds
                                .elementAt(index)['sao_danh_gia']
                                .toString())),
                            SizedBox(height: 10.0),
                            Row(
                              children: <Widget>[                               
                                Container(
                                  padding: EdgeInsets.all(5.0),
                                  width: 100.0,
                                  decoration: BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    ds.elementAt(index)["ten_loai_dia_danh"].toString(),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                    onPressed: () => _openGoogleMap(
                                        double.parse(ds
                                            .elementAt(index)['kinh_do']
                                            .toString()),
                                        double.parse(ds
                                            .elementAt(index)['vi_do']
                                            .toString())),
                                    icon: Icon(Icons.location_on)),
                                Flexible(
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ShareDestination(userId: widget.userId, diaDanhId:ds.elementAt(index)["id"].toString(), )));
                                        },
                                        icon: Icon(Icons.share))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20.0,
                      top: 15.0,
                      bottom: 15.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child:Image.asset('assets/images/newyork.jpg', width: 110,
                          fit: BoxFit.cover,),                          
                      ),
                    ),
                  ],
                ));
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    //Load danh sach dia danh
    if (isUpdate == true) {
      API(url: "http://10.0.2.2/vietnamtourism/api/lay_ds_dia_danh.php")
          .getDataString()
          .then((value) {
        dsDiaDanh = json.decode(value);
        isUpdate = false;
        setState(() {});
      });
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          //Area Search
          ListTile(
            leading: IconButton(
                onPressed: () {
                  if (isFilter == true) {
                    setState(() {
                      isFilter = false;
                    });
                  } else {
                    setState(() {
                      isFilter = true;
                    });
                  }
                },
                icon: Icon(Icons.filter_alt)),
            title: TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: "Tìm kiếm"),
            ),
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _mySelectionLDD = "0";
                        _controller.text = "";
                        _mySelectionVung = "0";
                        _mySelectionMien = "0";
                        isFind = false;
                      });
                    },
                    icon: Icon(Icons.cancel_outlined)),
                OutlinedButton(
                  onPressed: () {
                    if (isFilter == false&&_mySelectionLDD == "0" &&
                          _mySelectionMien == "0" &&
                          _mySelectionVung == "0") {
                      dsFind = dsDiaDanh.where((element) =>
                          element["ten_dia_danh"]
                              .toString().toLowerCase()
                              .contains(_controller.text.toLowerCase()));
                    } else {
                        dsFind = dsFind.where((element) =>
                            element["ten_dia_danh"]
                                .toString().toLowerCase()
                                .contains(_controller.text.toLowerCase()));
                    }
                    setState(() {
                      isFind = true;
                    });
                  },
                  child: Text("Search", style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue)),
                ),
              ],
            ),
          ),

          //Area Filter
          isFilter == false ? Text("") : _buildFilter(),
          isFind == false
              ? Text("")
              : Text("( Tìm thấy " + dsFind.length.toString() + " kết quả)"),
          //Area List DiaDanh
          isFind == true ? _buildDSDiaDanh(dsFind) : _buildDSDiaDanh(dsDiaDanh),
        ],
      ),
    );
  }
}
