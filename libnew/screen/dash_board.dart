// import 'dart:convert';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:restaurant_app/components/bar_chart_model.dart';
// import 'package:restaurant_app/components/database_con.dart';
// import 'package:restaurant_app/components/firebase_con.dart';
// import 'package:restaurant_app/components/indicator.dart';
// import 'package:restaurant_app/components/pie_chart_graph.dart';
// import 'package:restaurant_app/components/pie_chart_model.dart';
// import 'package:restaurant_app/components/sections.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:restaurant_app/screen/menu_screen.dart';
// import 'package:restaurant_app/screen/pos_screen.dart';
// import 'package:restaurant_app/screen/report_screen.dart';
// import '../components/database_con.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:restaurant_app/components/bar_chart_graph.dart';
// import 'package:restaurant_app/components/bar_chart_model.dart';
// import '../constants.dart';
// import '../constants.dart';
// import 'expense_report.dart';
// import 'menu_page.dart';
// class DashBoardPage extends StatefulWidget {
//   static const String id='dash';
//   @override
//   _DashBoardPageState createState() => _DashBoardPageState();
// }
//
// class _DashBoardPageState extends State<DashBoardPage> {
//   final List<PieChartModel> data1 = [
//     PieChartModel(
//       category: 'Biriyani',
//       sales: 500,
//       color: charts.ColorUtil.fromDartColor
//         (Color(0xFF2d4059)),
//     ),
//     PieChartModel(
//       category: 'Curry',
//       sales: 500,
//       color: charts.ColorUtil.fromDartColor
//         (Color(0xFFea5455)),
//     ),
//     PieChartModel(
//       category: 'Biriyani spl',
//       sales: 500,
//       color: charts.ColorUtil.fromDartColor
//         (Color(0xFFf07b3f)),
//     ),
//
//   ];
//   final List<BarChartModel> data = [
//     BarChartModel(
//       hours: "5",
//       sales: 500,
//       color: charts.ColorUtil.fromDartColor
//         (Color(0xFF2d4059)),
//     ),
//     BarChartModel(
//       hours: "6",
//       sales: 600,
//       color: charts.ColorUtil.fromDartColor
//         (Color(0xFFea5455)),
//     ),
//     BarChartModel(
//       hours: "7",
//       sales: 800,
//       color: charts.ColorUtil.fromDartColor
//         (Color(0xFFf07b3f)),
//     ),
//     BarChartModel(
//       hours: "8",
//       sales: 1000,
//       color: charts.ColorUtil.fromDartColor
//         (Color(0xFFffd460)),
//     ),
//     BarChartModel(
//       hours: "9",
//       sales: 1250,
//       color: charts.ColorUtil.fromDartColor
//         (Color(0xFF3ec1d3)),
//     ),
//     BarChartModel(
//       hours: "10",
//       sales: 3000,
//       color: charts.ColorUtil.fromDartColor
//         (Color(0xFF3ec1d3)),
//     ),
//     BarChartModel(
//       hours: "11",
//       sales: 2000,
//       color: charts.ColorUtil.fromDartColor
//         (Color(0xFF3ec1d3)),
//     ),
//   ];
//   List dashBoardMenu=['Sales','Purchase','Expense','Total Order','Online Order','Dine-In'];
//   final ScrollController _scrollController = ScrollController();
//   int touchedIndex;
//   @override
//   void initState() {
//     // TODO: implement initState
//    // getData('stock_data');
//     read('modifier_data');
//     super.initState();
//   }
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Container(
//           margin: EdgeInsets.only(left: 1,top: 1),
//           decoration: BoxDecoration(
//             color: Colors.white,
//           ),
//           child:SafeArea(
//               child:
//               Scaffold(
//
//                 backgroundColor: Colors.white60,
//                 body: Padding (
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment:MainAxisAlignment.spaceBetween,
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.only(left: 20),
//                               child: Container(
//                                 width: 180,
//                                 height: 80,
//                                 decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     image: DecorationImage(
//                                         fit: BoxFit.cover,
//                                         image: AssetImage(
//                                             'images/logo.jpg'
//                                         )
//                                     )
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(30),
//                               child: IconButton(icon: FaIcon(FontAwesomeIcons.home), onPressed: () async {
//                                 read('printer_data');
//                                 read('kot_data');
//                                 Navigator.pushNamed(context, MenuScreen.id);
//                               }),
//                             )
//                           ],),
//                         Container(
//                           margin: EdgeInsets.all(6.0),
//                           height: MediaQuery.of(context).size.height/6,
//                           child: GridView.builder(
//                               gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//                                 mainAxisSpacing: 10.0,
//                                 crossAxisSpacing: 10.0,
//                                 maxCrossAxisExtent: MediaQuery.of(context).size.width/6,
//                                 mainAxisExtent: MediaQuery.of(context).size.height/7,
//                               ),
//                               scrollDirection: Axis.vertical,
//                               shrinkWrap: true,
//                               itemCount: dashBoardMenu.length,
//                               itemBuilder: (context, index) {
//                                 return GestureDetector(
//                                   onTap: ()async{
//                                     if(index==0){
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) => ReportScreen(
//                                                 transactionType: 'sales',
//                                               )));
//                                     } if(index==1){
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) => ReportScreen(
//                                                 transactionType: 'purchase',
//                                               )));
//                                     }if(index==2){
//                                       Navigator.pushNamed(context, ExpenseReport.id);
//                                     }
//                                   },
//                                   child: Card(
//                                     elevation: 12.0,
//                                     child: Center(child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         AutoSizeText('\u{20B9} ${dashBoardValues[index].toString()}',
//                                           maxLines: 1,
//                                           textAlign: TextAlign.end,
//                                           style: TextStyle(
//                                             fontSize: MediaQuery.of(context).textScaleFactor*20,
//                                           ),
//                                         ),
//                                         AutoSizeText(dashBoardMenu[index],
//                                           maxLines: 1,
//                                           textAlign: TextAlign.end,
//                                           style: TextStyle(
//                                             fontSize: MediaQuery.of(context).textScaleFactor*8,
//                                           ),
//                                         ),
//                                       ],
//                                     )
//                                     ),
//                                   ),
//                                 );
//                               }),
//                         ),
//                         Expanded(
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               Expanded(
//                                   child: Card(
//                                     elevation: 12.0,
//
//                                     child: ListView(
//                                       scrollDirection: Axis.vertical,
//                                       children: [
//                                         SizedBox(
//                                           height: 30.0,
//                                         ),
//                                         Text('Most Favourites', style: TextStyle(
//                                           fontSize: MediaQuery.of(context).textScaleFactor*20,
//                                         ),),
//                                         SizedBox(
//                                           height: 20.0,
//                                         ),
//                                         productNameF!=null?ListView.builder(
//                                           scrollDirection: Axis.vertical,
//                                           physics: ScrollPhysics(),
//                                           shrinkWrap: true,
//                                           itemCount: productNameF.length>5?5:0,
//                                           itemBuilder: (context,index){
//                                             return Card(
//
//                                               elevation: 2.0,
//                                               child:Padding(
//                                                 padding: const EdgeInsets.all(8.0),
//                                                 child: Column(
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     AutoSizeText(
//                                                       productNameF[index],
//                                                       textAlign: TextAlign.center,
//                                                       maxLines: 1,
//                                                       style: TextStyle(
//                                                           fontFamily: 'Lato',
//                                                           fontSize: MediaQuery.of(context).textScaleFactor*15,
//                                                           color: Colors.black,
//                                                           fontWeight: FontWeight.bold
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         ):Text('Empty'),
//                                       ],
//                                     ),
//
//                                   )),
//                               Expanded(child: Card(
//                                 elevation: 12.0,
//                                 child: Flex(
//                                   direction: Axis.vertical,
//                                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                   children: [
//                                     Text('Hourly Sales', style: TextStyle(
//                                       fontSize: MediaQuery.of(context).textScaleFactor*20,
//                                     ),),
//                                     Expanded(
//                                       child: BarChartGraph(
//                                         data: data,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )),
//                               Expanded(child: Card(
//                                 elevation: 12.0,
//                                 child: Flex(
//                                   direction: Axis.vertical,
//                                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                   children: [
//                                     Text('Category Sales', style: TextStyle(
//                                       fontSize: MediaQuery.of(context).textScaleFactor*20,
//                                     ),),
//                                     Expanded(
//                                       child: PieChartGraph(
//                                         data1: data1,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )),
//                             ],
//                           ),
//                         )
//                       ]),
//                 ),
//               )
//           )),
//     );}
//
// }