import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:map_launcher/map_launcher.dart';
import 'package:vietnamtourism/chitietdiadanh.dart';
import 'package:vietnamtourism/share-destination.dart';
import 'package:vietnamtourism/trangcanhan.dart';

import 'api.dart';
import 'model/bai-viet.dart';

class HomePage extends StatefulWidget {
  HomePage({required this.userId});
  final String userId;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BaiViet> lstBaiViet = [];
  Iterable dsDiaDanh = [];
  bool isUpdate = true;
  Future<void> _openGoogleMap(double x, double y) async {
    final availableMaps = await MapLauncher.installedMaps;
    await availableMaps.first.showMarker(
      coords: Coords(x, y),
      title: "Ocean Beach",
    );
  }

  Future<String> loadBaiViet() async {
    String userid = widget.userId;
    Iterable baiViet = [];
    Iterable tuongTac = [];
    if (lstBaiViet.length > 0) {
      lstBaiViet.clear();
    }
    API(url: "http://10.0.2.2/vietnamtourism/api/lay_ds_bai_viet.php")
        .getDataString()
        .then((value) {
      baiViet = json.decode(value);
      for (int i = 0; i < baiViet.length; i++) {
        String id = baiViet.elementAt(i)["id"].toString();
        API(url: "http://10.0.2.2/vietnamtourism/api/lay_tuong_tac.php?user_id=$userid&bai_viet_id=$id")
            .getDataString()
            .then((value) {
          tuongTac = json.decode(value);
          setState(() {
            BaiViet bv = BaiViet(
                id,
                baiViet.elementAt(i)["ten_dia_danh"].toString(),
                baiViet.elementAt(i)["ten_nguoi_dung"].toString(),
                baiViet.elementAt(i)["tai_khoan_id"].toString(),
                baiViet.elementAt(i)["dia_danh_id"].toString(),
                baiViet.elementAt(i)["cam_nghi"].toString(),
                baiViet.elementAt(i)["danh_gia"].toString(),
                baiViet.elementAt(i)["so_luong_like"].toString(),
                baiViet.elementAt(i)["so_luong_unlike"].toString(),
                baiViet.elementAt(i)["so_luong_view"].toString(),
                baiViet.elementAt(i)["ngay_tao"].toString(),
                tuongTac);
            lstBaiViet.add(bv);
            print(lstBaiViet[i]);
          });
        });
      }

      setState(() {});
    });

    return "Succes";
  }

  Future UpdateTuongTac(String baiVietId, String trangThai, String isLike) async {
    String userid = widget.userId;
    Iterable s = [];
    print(isLike);
    String url =
        "http://10.0.2.2/vietnamtourism/api/thay_doi_tuong_tac.php?trang_thai_like=$trangThai&bai_viet_id=$baiVietId&user_id=$userid&islike=$isLike";
    var res = await http.get(Uri.parse(url));
    var resBody = json.decode(res.body);
    setState(() {
      s = resBody;
      print(s);
    });
  }

  @override
  void initState() {
    super.initState();
    this.loadBaiViet();
  }

  @override
  Widget build(BuildContext context) {
    if (isUpdate == true) {
      API(url: "http://10.0.2.2/vietnamtourism/api/lay_ds_dia_danh.php")
          .getDataString()
          .then((value) {
        dsDiaDanh = json.decode(value);
        isUpdate = false;
        setState(() {});
      });
    }
    Widget _buildRatingStars(double rating) {
      return RatingBarIndicator(
        rating: rating,
        itemBuilder: (context, index) => Icon(
          Icons.star,
          color: Colors.amber,
        ),
        itemCount: 5,
        itemSize: 20.0,
      );
    }

    return SingleChildScrollView(
        child: Column(children: [
      SizedBox(
        height: 20,
      ),
      Text(
        "Đia danh",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 300.0,
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(dsDiaDanh.length, (i) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChiTietDiaDanh(
                                diaDanhId:
                                    dsDiaDanh.elementAt(i)["id"].toString(),
                                userId: widget.userId)));
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.asset(
                            'assets/images/newyork.jpg',
                            width: 200,
                            height: 300,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      Positioned(
                          left: 30.0,
                          bottom: 25.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  dsDiaDanh
                                      .elementAt(i)["ten_dia_danh"]
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                              Container(
                                width: 180,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildRatingStars(double.parse(dsDiaDanh
                                        .elementAt(i)["sao_danh_gia"]
                                        .toString())),
                                    IconButton(
                                        onPressed: () => _openGoogleMap(
                                            double.parse(dsDiaDanh
                                                .elementAt(i)['kinh_do']
                                                .toString()),
                                            double.parse(dsDiaDanh
                                                .elementAt(i)['vi_do']
                                                .toString())),
                                        icon: Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                  width: 150,
                                  child: Flexible(
                                      child: Text(
                                          dsDiaDanh
                                              .elementAt(i)["mo_ta"]
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              TextStyle(color: Colors.white))))
                            ],
                          )),
                      Positioned(
                          top: 10,
                          right: 10,
                          child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShareDestination(
                                              userId: widget.userId,
                                              diaDanhId: dsDiaDanh
                                                  .elementAt(i)["id"]
                                                  .toString(),
                                            )));
                              },
                              icon: Icon(
                                Icons.share,
                                color: Colors.white,
                              )))
                    ],
                  ),
                );
              }))),
      Text(
        "Bài viết",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      Column(
          children: List.generate(lstBaiViet.length, (index) {
        return Card(
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          AssetImage('assets/images/santorini.jpg'),
                    ),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TaiKhoan(
                                          id: lstBaiViet[index]
                                              .taiKhoanId
                                              .toString(),
                                          userId: widget.userId,
                                        ))).then((value) {
                              this.loadBaiViet();
                            });
                          },
                          child: Text(
                            lstBaiViet[index].ten_nguoi_dung.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Text(
                          " đã chia sẽ về ",
                        ),
                        Flexible(
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChiTietDiaDanh(
                                            userId: widget.userId,
                                            diaDanhId:
                                                lstBaiViet[index].diaDanhId)));
                              },
                              child: Text(
                                lstBaiViet[index].tenDiaDanh,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                        ),
                      ],
                    ),
                    subtitle: Text(lstBaiViet[index].thoiGian),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: _buildRatingStars(
                        double.parse(lstBaiViet[index].dangGia)),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text(
                      lstBaiViet[index].camNghi,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Image.asset('assets/images/paris.jpg'),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  UpdateTuongTac(
                                          lstBaiViet[index].id,
                                          "1",
                                          lstBaiViet[index]
                                              .trangThaiLike
                                              .elementAt(0)["trang_thai_like"]
                                              .toString())
                                      .then((value) {
                                    setState(() {
                                      this.loadBaiViet();
                                    });
                                  });
                                },
                                icon: lstBaiViet[index]
                                            .trangThaiLike
                                            .elementAt(0)["trang_thai_like"]
                                            .toString() ==
                                        "1"
                                    ? Icon(
                                        Icons.thumb_up_alt_rounded,
                                        color: Colors.blue,
                                      )
                                    : Icon(Icons.thumb_up_alt_rounded)),
                            Text("(" +
                                lstBaiViet[index].soLuongLike.toString() +
                                ")")
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  UpdateTuongTac(
                                          lstBaiViet[index].id,
                                          "2",
                                          lstBaiViet[index]
                                              .trangThaiLike
                                              .elementAt(0)["trang_thai_like"]
                                              .toString())
                                      .then((value) {
                                    setState(() {
                                      this.loadBaiViet();
                                    });
                                  });
                                },
                                icon: lstBaiViet[index]
                                            .trangThaiLike
                                            .elementAt(0)["trang_thai_like"]
                                            .toString() ==
                                        "2"
                                    ? Icon(
                                        Icons.thumb_down_alt_rounded,
                                        color: Colors.blue,
                                      )
                                    : Icon(Icons.thumb_down_alt_rounded)),
                            Text("(" +
                                lstBaiViet[index].soLuongUnLike.toString() +
                                ")")
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.remove_red_eye_sharp),
                            Text("(" +
                                lstBaiViet[index].soLuongView.toString() +
                                ")")
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ));
      }))
    ]));
  }
}
