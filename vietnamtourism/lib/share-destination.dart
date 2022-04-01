import 'dart:convert';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ShareDestination extends StatefulWidget {
  ShareDestination({Key? key, required this.userId, required this.diaDanhId})
      : super(key: key);
  final String userId;
  final String diaDanhId;
  @override
  State<ShareDestination> createState() => _ShareDestinationState();
}

class _ShareDestinationState extends State<ShareDestination> {
  final TextEditingController _controllerCamNghi = TextEditingController();
  String ratingStar = "3";

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

  Future CreateShare() async {
    String canNghi = _controllerCamNghi.text;
    String userid = widget.userId;
    String diaDanhid = widget.diaDanhId;
    String s = "";
    String url =
        "http://10.0.2.2/vietnamtourism/api/chia_se_dia_danh.php?user_id=$userid&dia_danh_id=$diaDanhid&cam_nghi=$canNghi&danh_gia=$ratingStar";
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
                content: Text('Chia sẻ thành công'),
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
  }

  @override
  void initState() {
    super.initState();
    print(widget.diaDanhId);
    print(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chia sẻ địa danh"), actions: <Widget>[
        TextButton(
            onPressed: () {
              if (_controllerCamNghi.text.trim() == "") {
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
              } else {
                CreateShare();
              }
            },
            child: Text(
              "Chia sẻ",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ))
      ]),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            ListTile(
              title: TextField(
                maxLines: 6,
                controller: _controllerCamNghi,
                decoration: InputDecoration(
                  labelText: 'Cảm nghĩ',
                ),
              ),
            ),
             SizedBox(
              height: 20,
            ),
            ListTile(
                title: Text("Đánh giá: "),
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
