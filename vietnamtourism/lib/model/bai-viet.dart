import 'package:flutter/material.dart';

class BaiViet {
  String id;
  String tenDiaDanh;
  String ten_nguoi_dung;
  String taiKhoanId;
  String diaDanhId;
  String camNghi;
  String dangGia;
  // String hinhAnh;
  String soLuongLike;
  String soLuongUnLike;
  String soLuongView;
  String thoiGian;
  Iterable trangThaiLike;
  @override

  BaiViet(this.id,this.tenDiaDanh,this.ten_nguoi_dung,this.taiKhoanId,this.diaDanhId,this.camNghi,this.dangGia,this.soLuongLike,this.soLuongUnLike,this.soLuongView,this.thoiGian,this.trangThaiLike);

}