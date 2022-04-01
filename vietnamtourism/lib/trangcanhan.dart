import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:vietnamtourism/chitietdiadanh.dart';
import 'package:vietnamtourism/model/bai-viet.dart';

import 'api.dart';

class TaiKhoan extends StatefulWidget {
  TaiKhoan({Key? key, required this.id, required this.userId})
      : super(key: key);
  final String id;
  final String userId;
  @override
  State<TaiKhoan> createState() => _TaiKhoanState();
}

class _TaiKhoanState extends State<TaiKhoan> {
  List<BaiViet> lstBaiViet = [];
  Iterable user = [];
  Iterable ttUser = [];

  Future<String> loadBaiViet() async {
    String useridOfBaiViet = widget.id;
    String useridXem = widget.userId;
    Iterable baiViet = [];
    Iterable tuongTac = [];
    if (lstBaiViet.length > 0) {
      lstBaiViet.clear();
    }
    API(url: "http://10.0.2.2/vietnamtourism/api/lay_ds_bai_viet_theo_id.php?id=$useridOfBaiViet")
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
                user.elementAt(0)["ten_nguoi_dung"].toString(),
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

  Future UpdateTuongTac(String baiVietId, String trangThai,String isLike) async {
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

  @override
  void initState() {
    super.initState();
    this.layInfoUser();
    this.layTrangThaiOfUser();
    this.loadBaiViet();
  }

  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(
        title:
            Text(user.elementAt(0)["ten_nguoi_dung"].toString().toUpperCase()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(15),
              child: CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage('assets/images/santorini.jpg'),
              ),
            ),
            Text(
              user.elementAt(0)["ten_nguoi_dung"].toString().toUpperCase(),
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Card(
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ListTile(
                    leading: Text(
                      "Giới thiệu",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
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
                              Text(
                                user.elementAt(0)["ten_nguoi_dung"].toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
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
                                                      diaDanhId:
                                                          lstBaiViet[index]
                                                              .diaDanhId)));
                                    },
                                    child: Text(
                                      lstBaiViet[index].tenDiaDanh,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                                lstBaiViet[index].id, "1",lstBaiViet[index].trangThaiLike.elementAt(0)["trang_thai_like"].toString())
                                            .then((value) {
                                           setState(() {
                                            this.loadBaiViet();
                                          });
                                        });
                                      },
                                      icon: lstBaiViet[index]
                                                  .trangThaiLike
                                                  .elementAt(
                                                      0)["trang_thai_like"]
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
                                                lstBaiViet[index].id, "2",lstBaiViet[index].trangThaiLike.elementAt(0)["trang_thai_like"].toString())
                                            .then((value) {
                                          setState(() {
                                            this.loadBaiViet();
                                          });
                                        });
                                      },
                                      icon: lstBaiViet[index]
                                                  .trangThaiLike
                                                  .elementAt(
                                                      0)["trang_thai_like"]
                                                  .toString() ==
                                              "2"
                                          ? Icon(
                                              Icons.thumb_down_alt_rounded,
                                              color: Colors.blue,
                                            )
                                          : Icon(Icons.thumb_down_alt_rounded)),
                                  Text("(" +
                                      lstBaiViet[index]
                                          .soLuongUnLike
                                          .toString() +
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
      ),
    );
  }
}
