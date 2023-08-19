import 'package:fl_chart/fl_chart.dart';
import 'data_chart.dart';
import 'package:flutter/material.dart';

List<PieChartSectionData> getSections(int touchedIndex) => PieChartDatas.data
    .asMap()
    .map<int, PieChartSectionData>((index, data) {
  final double fontSize = 15;
  final double radius = 70;

  final value = PieChartSectionData(
    color: data.color,
    value: data.percent,
    title: '${data.percent}%',
    radius: radius,
    titleStyle: TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: const Color(0xffffffff),
    ),
  );

  return MapEntry(index, value);
})
    .values
    .toList();