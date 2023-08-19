import 'package:flutter/material.dart';

class PieChartDatas {
  static List<ProductData> data = [
    ProductData(name: 'Burger', percent: 40, color: const Color(0xff0293ee)),
    ProductData(name: 'Sandwich', percent: 30, color: const Color(0xfff8b250)),
    ProductData(name: 'Juice', percent: 15, color: Colors.black),
    ProductData(name: 'Shawarma', percent: 15, color: const Color(0xff13d38e)),
  ];
}

class ProductData {
  final String name;
  final Color color;
  final double percent;
  ProductData({this.name, this.percent, this.color});
}