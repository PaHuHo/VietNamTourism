import 'package:flutter/material.dart';

class GenderModel {
  String id;
  String name;
  IconData icon;
  @override
  String toString() {
    return '$id $name';
  }
  GenderModel(this.id, this.name,this.icon);

}