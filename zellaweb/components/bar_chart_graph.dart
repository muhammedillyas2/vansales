// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:intl/intl.dart';
// import 'package:restaurant_app/components/bar_chart_model.dart';
//
//
// class BarChartGraph extends StatefulWidget {
//   final List<BarChartModel> data;
//   const BarChartGraph({Key key, this.data}) : super(key: key);
//   @override
//   _BarChartGraphState createState() => _BarChartGraphState();
// }
//
// class _BarChartGraphState extends State<BarChartGraph> {
//   List<BarChartModel> _barChartList;
//   String dateNow(){
//     final now = DateTime.now();
//     final formatter = DateFormat('MM/dd/yyyy H:m');
//     final String timestamp = formatter.format(now);
//     return timestamp;
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _barChartList = [
//       BarChartModel(day: ''),
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<charts.Series<BarChartModel, String>> series = [
//       charts.Series(
//           id: "Financial",
//           data: widget.data,
//           domainFn: (BarChartModel series, _) => series.hours,
//           measureFn: (BarChartModel series, _) => series.sales,
//           colorFn: (BarChartModel series, _) => series.color),
//     ];
//
//     return _buildFinancialList(series);
//
//   }
//
//   Widget _buildFinancialList(series) {
//     return _barChartList != null
//         ? ListView.separated(
//       physics: NeverScrollableScrollPhysics(),
//       separatorBuilder: (context, index) => Divider(
//         color: Colors.white,
//         height: 5,
//       ),
//       scrollDirection: Axis.vertical,
//       shrinkWrap: true,
//       itemCount: _barChartList.length,
//       itemBuilder: (BuildContext context, int index) {
//         return Container(
//           height: MediaQuery.of(context).size.height/ 2.3,
//           padding: EdgeInsets.all(10),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(_barChartList[index].day??'',
//                       style: TextStyle(
//                           color: Colors.black, fontSize: 22,
//                           fontWeight: FontWeight.bold)
//                   ),
//                 ],
//               ),
//               Expanded( child: charts.BarChart(series, animate: true)),
//             ],
//           ),
//         );
//       },
//     )
//         : SizedBox();
//   }
// }