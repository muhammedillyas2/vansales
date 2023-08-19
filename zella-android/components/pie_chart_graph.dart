// import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:intl/intl.dart';
// import 'package:restaurant_app/components/bar_chart_model.dart';
// import 'package:restaurant_app/components/pie_chart_model.dart';
// class PieChartGraph extends StatefulWidget {
//   final List<PieChartModel> data1;
//
//   const PieChartGraph({Key key, this.data1}) : super(key: key);
//   @override
//   _PieChartGraphState createState() => _PieChartGraphState();
// }
//
// class _PieChartGraphState extends State<PieChartGraph> {
//   List<PieChartModel> _pieChartList;
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
//     _pieChartList = [
//       PieChartModel(day: ''),
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<charts.Series<PieChartModel,String>> series=[
//       charts.Series(
//         id: 'category',
//         data: widget.data1,
//         domainFn: (PieChartModel series,_)=>series.category,
//         measureFn:(PieChartModel series,_)=>series.sales ,
//           colorFn:(PieChartModel series,_)=>series.color,
//       )
//     ];
//
//
//     return _buildCategoryList(series);
//
//   }
//
//   Widget _buildCategoryList(series) {
//     return _pieChartList != null
//         ? ListView.separated(
//       physics: NeverScrollableScrollPhysics(),
//       separatorBuilder: (context, index) => Divider(
//         color: Colors.white,
//         height: 5,
//       ),
//       scrollDirection: Axis.vertical,
//       shrinkWrap: true,
//       itemCount: _pieChartList.length,
//       itemBuilder: (BuildContext context, int index) {
//         return Container(
//           height: MediaQuery.of(context).size.height/ 2.3,
//           padding: EdgeInsets.all(10),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(_pieChartList[index].day??'',
//                       style: TextStyle(
//                           color: Colors.black, fontSize: 22,
//                           fontWeight: FontWeight.bold)
//                   ),
//                 ],
//               ),
//               Expanded( child: charts.PieChart(series, animate: true, defaultRenderer: new charts.ArcRendererConfig(
//                   arcWidth: 60,
//                   arcRendererDecorators: [new charts.ArcLabelDecorator()],
//               ))),
//             ],
//           ),
//         );
//       },
//     )
//         : SizedBox();
//   }
// }
