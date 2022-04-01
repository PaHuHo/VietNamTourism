import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:map_launcher/map_launcher.dart';
import 'package:vietnamtourism/chitietdiadanh.dart';
import 'package:vietnamtourism/chitietvung.dart';
import 'package:vietnamtourism/model/vung-model.dart';
import 'package:vietnamtourism/share-destination.dart';

import 'api.dart';

class Vung extends StatefulWidget {
  Vung({Key? key, required this.userId}) : super(key: key);
  final String userId;
  @override
  State<Vung> createState() => _VungState();
}

class _VungState extends State<Vung> {
  List<VungModel> lsVung = [];
  Future<void> _openGoogleMap(double x, double y) async {
    final availableMaps = await MapLauncher.installedMaps;
    await availableMaps.first.showMarker(
      coords: Coords(x, y),
      title: "Ocean Beach",
    );
  }

  Future<String> loadDSDiaDanhTheoVung() async {
    Iterable dsDiaDanh = [];
    Iterable dsVung = [];
    API(url: "http://10.0.2.2/vietnamtourism/api/lay_ds_vung.php?ver=0")
        .getDataString()
        .then((value) {
      dsVung = json.decode(value);
      for (int i = 0; i < dsVung.length; i++) {
        String id = dsVung.elementAt(i)["id"].toString();
        API(url: "http://10.0.2.2/vietnamtourism/api/lay_ds_dia_danh_theo_vung.php?id=$id")
            .getDataString()
            .then((value) {
          dsDiaDanh = json.decode(value);
          setState(() {
            VungModel vungTemp = VungModel(dsVung.elementAt(i)["id"].toString(),
                dsVung.elementAt(i)["ten_vung"].toString(), dsDiaDanh);
            lsVung.add(vungTemp);
          });
        });
      }

      setState(() {});
    });

    return "Succes";
  }

  @override
  void initState() {
    super.initState();
    this.loadDSDiaDanhTheoVung();
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
        itemSize: 20.0,
      );
    }

    return Scaffold(
      body: ListView.builder(
          itemCount: lsVung.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lsVung[index].ten.toUpperCase(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      height: 300.0,
                      child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                              lsVung[index].dsDiaDanh.length, (i) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChiTietDiaDanh(
                                            diaDanhId: lsVung[index]
                                                .dsDiaDanh
                                                .elementAt(i)["id"]
                                                .toString(),
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
                                              lsVung[index]
                                                  .dsDiaDanh
                                                  .elementAt(i)["ten_dia_danh"]
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white)),
                                          Container(
                                            width: 180,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                _buildRatingStars(double.parse(
                                                    lsVung[index]
                                                        .dsDiaDanh
                                                        .elementAt(
                                                            i)["sao_danh_gia"]
                                                        .toString())),
                                                IconButton(
                                                    onPressed: () => _openGoogleMap(
                                                        double.parse(lsVung[index]
                                                        .dsDiaDanh
                                                        .elementAt(
                                                            i)["kinh_do"]
                                                        .toString()),
                                                        double.parse(lsVung[index]
                                                        .dsDiaDanh
                                                        .elementAt(
                                                            i)["vi_do"]
                                                        .toString())),
                                                    icon: Icon(
                                                      Icons.location_on,
                                                      color: Colors.white,
                                                    )),
                                              ],
                                            ),
                                          )
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
                                                    builder: (context) =>
                                                        ShareDestination(
                                                          userId: widget.userId,
                                                          diaDanhId:
                                                              lsVung[index]
                                                                  .dsDiaDanh
                                                                  .elementAt(
                                                                      i)["id"]
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
                ],
              ),
            );
          }),
    );
  }
}
