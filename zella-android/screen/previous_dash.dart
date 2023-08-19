// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:restaurant_app/components/indicator.dart';
// import 'package:restaurant_app/components/sections.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:restaurant_app/screen/menu_screen.dart';
// import 'menu_page.dart';
// class DashBoardPage extends StatefulWidget {
//   static const String id='dash';
//   @override
//   _DashBoardPageState createState() => _DashBoardPageState();
// }
// class _DashBoardPageState extends State<DashBoardPage> {
//   final ScrollController _scrollController = ScrollController();
//   int touchedIndex;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Container(
//           margin: EdgeInsets.only(left: 1,top: 1),
//           decoration: BoxDecoration(
//             color: Colors.white,
//           ),
//           child:SafeArea(
//               child:
//               Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Row(
//                       mainAxisAlignment:MainAxisAlignment.spaceBetween,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.only(left: 38),
//                           child: Container(
//                             width: 180,
//                             height: 80,
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 image: DecorationImage(
//                                     fit: BoxFit.cover,
//                                     image: AssetImage(
//                                         'images/logo.jpg'
//                                     )
//                                 )
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(38.0),
//                           child: IconButton(icon: FaIcon(FontAwesomeIcons.home), onPressed: (){
//                             Navigator.pushNamed(context, MenuScreen.id);
//                           }),
//                         )
//                       ],),
//                     Flexible(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           GestureDetector(
//                             onTap:(){
//                             },
//                             child: Container(
//                               height: 120,
//                               width: 300,
//                               child: Card(
//                                   color: Colors.black,
//                                   child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                             padding: EdgeInsets.only(top: 10),
//                                             child: Text('Sales',style: TextStyle(fontSize: 15,color:Colors.white,),)),
//                                         Padding(padding: EdgeInsets.only(bottom: 1),
//                                             child: Text('₹15676',style: TextStyle(color:Colors.white,fontSize: 40),)),
//                                         FlatButton(
//                                           child: Text('View Details',style: TextStyle(color: Colors.white),),
//                                           onPressed: (){ },
//                                         )
//                                       ])),
//                             ),
//                           ),
//                           Container(
//                             height: 120,
//                             width: 300,
//                             child: Card(
//                                 color: Color(0xff13d38e),
//                                 child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Padding(
//                                           padding: EdgeInsets.only(top: 10),
//                                           child: Text('Purchase',style: TextStyle(fontSize: 15,color:Colors.white,),)),
//                                       Padding(padding: EdgeInsets.only(bottom: 1),
//                                           child: Text('₹4000',style: TextStyle(color:Colors.white,fontSize: 40),)),
//                                       FlatButton(
//                                         child: Text('View Details',style: TextStyle(color: Colors.white),),
//                                         onPressed: (){ },
//                                       )
//                                     ])),
//                           ),
//                           Container(
//                             height: 120,
//                             width: 300,
//                             child: Card(
//                                 color: Color(0xff0293ee),
//                                 child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Padding(
//                                           padding: EdgeInsets.only(top: 10),
//                                           child: Text('Expense',style: TextStyle(fontSize: 15,color:Colors.white,),)),
//                                       Padding(padding: EdgeInsets.only(bottom: 1),
//                                           child: Text('₹400',style: TextStyle(color:Colors.white,fontSize: 40),)),
//                                       FlatButton(
//                                         child: Text('View Details',style: TextStyle(color: Colors.white),),
//                                         onPressed: (){ },
//                                       )
//                                     ])),
//                           ),
//                           Container(
//                             height: 120,
//                             width: 300,
//                             child: Card(
//                                 color: Color(0xfff8b250),
//                                 child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Padding(
//                                           padding: EdgeInsets.only(top: 10),
//                                           child: Text('Orders',style: TextStyle(fontSize: 15,color:Colors.white,),)),
//                                       Padding(padding: EdgeInsets.only(bottom: 1),
//                                           child: Text('₹4000',style: TextStyle(color:Colors.white,fontSize: 40),)),
//                                       FlatButton(
//                                         child: Text('View Details',style: TextStyle(color: Colors.white),),
//                                         onPressed: (){ },
//                                       )
//                                     ])),
//                           ),
//
//
//                         ],
//                       ),
//                     ),
//                     Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children:[
//                           Container(
//                             height: 360,
//                             width: 630,
//                             child: Card(
//                               color: Colors.white,
//                               child:
//                               Container(
//                                 margin: EdgeInsets.only(left: 40,right: 40,bottom: 20),
//                                 child:  Scrollbar(
//                                   isAlwaysShown: true,
//                                   controller: _scrollController,
//                                   child: ListView(
//                                       physics: AlwaysScrollableScrollPhysics(),
//                                       controller: _scrollController,
//                                       children: <Widget>[
//                                         Center(
//                                             child: Text(
//                                               '',
//                                               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                                             )),
//                                         DataTable(
//                                           columns: [
//                                             DataColumn(label: Text('ItemNo')),
//                                             DataColumn(label: Text('Invoice No')),
//                                             DataColumn(label: Text('Amount')),
//                                           ],
//                                           rows: [
//                                             DataRow(cells: [
//                                               DataCell(Text('1')),
//                                               DataCell(Text('11111')),
//                                               DataCell(Text('600')),
//                                             ]),
//                                             DataRow(cells: [
//                                               DataCell(Text('2')),
//                                               DataCell(Text('11112')),
//                                               DataCell(Text('90')),
//                                             ]),
//                                             DataRow(cells: [
//                                               DataCell(Text('3')),
//                                               DataCell(Text('11113')),
//                                               DataCell(Text('80')),]),
//                                             DataRow(cells: [
//                                               DataCell(Text('3')),
//                                               DataCell(Text('11113')),
//                                               DataCell(Text('80')),]),
//                                             DataRow(cells: [
//                                               DataCell(Text('3')),
//                                               DataCell(Text('11113')),
//                                               DataCell(Text('80')),]),
//                                             DataRow(cells: [
//                                               DataCell(Text('3')),
//                                               DataCell(Text('11113')),
//                                               DataCell(Text('80')),]),
//                                             DataRow(cells: [
//                                               DataCell(Text('3')),
//                                               DataCell(Text('11113')),
//                                               DataCell(Text('80')),]),
//                                             DataRow(cells: [
//                                               DataCell(Text('3')),
//                                               DataCell(Text('11113')),
//                                               DataCell(Text('80')),]),
//                                           ],
//                                         ),
//                                       ]
//                                   ),
//                                 ),
//
//                               ),
//                             ),
//                           ),
//
//                           Container(
//
//                             width: 630,
//                             child: Card(
//                               color: Colors.white,
//                               child: Column(
//                                 children: <Widget>[
//                                   Container(
//                                     height: 230,
//                                     child:  PieChart(
//                                       PieChartData(
//                                         pieTouchData: PieTouchData(
//                                           touchCallback: (pieTouchResponse) {
//
//                                           },
//                                         ),
//                                         borderData: FlBorderData(show: false),
//                                         sectionsSpace: 0,
//                                         centerSpaceRadius: 30,
//                                         sections: getSections(touchedIndex),
//                                       ),
//                                     ),
//                                   ),
//                                   Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                       children:[  Padding(
//                                         padding: const EdgeInsets.all(16),
//                                         child: IndicatorsWidget(),
//                                       ),]),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ]),
//                   ])
//           )),
//     );}}