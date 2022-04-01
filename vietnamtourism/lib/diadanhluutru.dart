import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DiaDanhLuuTru extends StatefulWidget {
  @override
  State<DiaDanhLuuTru> createState() => DiaDanhLucTruState();
}

class DiaDanhLucTruState extends State<DiaDanhLuuTru> {
  Iterable diaDanhLuuTru = [];
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

  Future<String> layDSDiaDanhLuuTru() async {
    String url =
        "http://10.0.2.2/vietnamtourism/api/lay_ds_dia_danh_luu_tru.php?id=0";
    var res = await http.get(Uri.parse(url));
    var resBody = json.decode(res.body);
    setState(() {
      diaDanhLuuTru = resBody;
      print(diaDanhLuuTru);
    });

    return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    this.layDSDiaDanhLuuTru();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(        
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              itemCount: diaDanhLuuTru.length,
              itemBuilder: (BuildContext context, int index) {
                return Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(40.0, 0, 20.0, 0),
                      height: 210.0,
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
                                  width: 200.0,
                                  child: Text(
                                    diaDanhLuuTru
                                        .elementAt(index)["ten"]
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.fade,
                                    maxLines: 4,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Text(
                              'Số điện thoại: ' +
                                  diaDanhLuuTru
                                      .elementAt(index)['sdt']
                                      .toString(),
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 10,),
                            _buildRatingStars(double.parse(diaDanhLuuTru
                                .elementAt(index)['sao_danh_gia']
                                .toString())),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.location_on)),
                                Flexible(
                                    child: IconButton(
                                        onPressed: () {},
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
                        child: Image.asset(
                          'assets/images/hotel2.jpg',
                          width: 110,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
