import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:vietnamtourism/danhsachbaiviet.dart';
import 'package:vietnamtourism/share-destination.dart';
import 'package:vietnamtourism/trangcanhan.dart';

import 'api.dart';
import 'model/bai-viet.dart';

class ChiTietDiaDanh extends StatefulWidget {
  ChiTietDiaDanh({Key? key, required this.diaDanhId, required this.userId})
      : super(key: key);
  final String diaDanhId;
  final String userId;
  @override
  State<ChiTietDiaDanh> createState() => _ChiTietDiaDanhState();
}

class _ChiTietDiaDanhState extends State<ChiTietDiaDanh> {
  Iterable diaDanh = [];
  Iterable baiViet = [];
  List<BaiViet> lstBaiViet = [];
  Iterable diaDanhLuuTru = [];
  bool isUpdate = true;
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
      itemSize: 25.0,
    );
  }

  Future<String> loadBaiVietTheoDiaDanh() async {
    String diaDanhid = widget.diaDanhId;
    String useridXem = widget.userId;
    Iterable baiViet = [];
    Iterable tuongTac = [];
    if (lstBaiViet.length > 0) {
      lstBaiViet.clear();
    }
    API(url: "http://10.0.2.2/vietnamtourism/api/lay_ds_bai_viet_theo_dia_danh.php?id=$diaDanhid")
        .getDataString()
        .then((value) {
      baiViet = json.decode(value);
      for (int i = 0; i < baiViet.length; i++) {
        String id = baiViet.elementAt(i)["id"].toString();
        API(url: "http://10.0.2.2/vietnamtourism/api/lay_tuong_tac.php?user_id=$useridXem&bai_viet_id=$id")
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
          });
        });
      }

      setState(() {});
    });

    return "Succes";
  }

  Future<String> layDSDiaDanhLuuTru() async {
    String diaDanhid = widget.diaDanhId;
    String url =
        "http://10.0.2.2/vietnamtourism/api/lay_ds_dia_danh_luu_tru.php?id=$diaDanhid";
    var res = await http.get(Uri.parse(url));
    var resBody = json.decode(res.body);
    setState(() {
      diaDanhLuuTru = resBody;
      print(diaDanhLuuTru);
    });

    return "Sucess";
  }

  Future UpdateTuongTac(
      String baiVietId, String trangThai, String isLike) async {
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
    this.loadBaiVietTheoDiaDanh();
    this.layDSDiaDanhLuuTru();
  }

  @override
  Widget build(BuildContext context) {
    if (isUpdate == true) {
      String id = widget.diaDanhId;
      API(url: "http://10.0.2.2/vietnamtourism/api/lay_dia_danh.php?id=$id")
          .getDataString()
          .then((value) {
        diaDanh = json.decode(value);
        isUpdate = false;
        setState(() {});
      });
    }
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          //Thông tin địa danh
          Stack(
            children: [
              Image.asset(
                'assets/images/newyork.jpg',
                height: 280,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Container(
                height: 280,
                color: Colors.black12,
                padding: EdgeInsets.only(top: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              // baiViet.length.toString() != "0"
                              //     ? GestureDetector(
                              //         onTap: () {
                              //           Navigator.push(
                              //               context,
                              //               MaterialPageRoute(
                              //                   builder: (context) =>
                              //                       BaiVietDiaDanh(
                              //                         diaDanhId:
                              //                             widget.diaDanhId,
                              //                         userId: widget.userId,
                              //                       )));
                              //         },
                              //         child: Text(
                              //           "( " +
                              //               baiViet.length.toString() +
                              //               " chia sẻ )",
                              //           style: TextStyle(
                              //               fontSize: 18, color: Colors.white),
                              //         ),
                              //       )
                              //     : Text(""),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ShareDestination(
                                                  userId: widget.userId,
                                                  diaDanhId: widget.diaDanhId,
                                                ))).then((value){
                                                 loadBaiVietTheoDiaDanh();
                                                });
                                  },
                                  icon: Icon(
                                    Icons.share,
                                    color: Colors.white,
                                    size: 24,
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            diaDanh.elementAt(0)["ten_dia_danh"].toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 23),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildRatingStars(double.parse(diaDanh
                                  .elementAt(0)['sao_danh_gia']
                                  .toString())),
                              Container(
                                padding: EdgeInsets.all(5.0),
                                width: 100.0,
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  diaDanh
                                      .elementAt(0)["ten_loai_dia_danh"]
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Container(
                            child: Text(
                                diaDanh.elementAt(0)["mo_ta"].toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Địa danh lưu trú",
            style: TextStyle(fontSize: 20),
          ),
          diaDanhLuuTru.length > 0
              ? Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  height: 300.0,
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(diaDanhLuuTru.length, (i) {
                        return Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.asset(
                                  'assets/images/saopaulo.jpg',
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
                                        diaDanhLuuTru
                                            .elementAt(i)["ten"]
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white)),
                                    Container(
                                      width: 180,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildRatingStars(double.parse(
                                              diaDanhLuuTru
                                                  .elementAt(i)["sao_danh_gia"]
                                                  .toString())),
                                          IconButton(
                                              onPressed: () {
                                                _openGoogleMap(
                                                    double.parse(diaDanhLuuTru
                                                        .elementAt(i)['kinh_do']
                                                        .toString()),
                                                    double.parse(diaDanhLuuTru
                                                        .elementAt(i)['vi_do']
                                                        .toString()));
                                              },
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
                                                "Sdt: " +
                                                    diaDanhLuuTru
                                                        .elementAt(i)["sdt"]
                                                        .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white))))
                                  ],
                                )),
                          ],
                        );
                      })))
              : Container(
                  margin: EdgeInsets.all(20),
                  child: Text("Không có dữ liệu về địa danh lưu trú",
                      style: TextStyle(fontSize: 20)),
                ),
          Text(
            "Bài viết",
            style: TextStyle(fontSize: 20),
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
                                  this.loadBaiVietTheoDiaDanh();
                                });
                              },
                              child: Text(
                                lstBaiViet[index].ten_nguoi_dung.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
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
                                            builder: (context) =>
                                                ChiTietDiaDanh(
                                                    userId: widget.userId,
                                                    diaDanhId: lstBaiViet[index]
                                                        .diaDanhId)));
                                  },
                                  child: Text(
                                    lstBaiViet[index].tenDiaDanh,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                                  .elementAt(
                                                      0)["trang_thai_like"]
                                                  .toString())
                                          .then((value) {
                                        setState(() {
                                          this.loadBaiVietTheoDiaDanh();
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
                                                  .elementAt(
                                                      0)["trang_thai_like"]
                                                  .toString())
                                          .then((value) {
                                        setState(() {
                                          this.loadBaiVietTheoDiaDanh();
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
        ],
      ),
    ));
  }
}
