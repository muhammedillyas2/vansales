import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/components/firebase_con.dart';

import '../constants.dart';
import 'login_page.dart';
class TillReport extends StatefulWidget {
  static const String id='till_report';
  @override
  _TillReportState createState() => _TillReportState();
}
DateTime  fromDate;
DateTime toDate =DateTime.now();
int toDate1=0;
int fromDate1=0;
String dateFrom='',dateTo='';
var datePicked;
class _TillReportState extends State<TillReport> {
  @override
  void initState() {
    // TODO: implement initState
    fromDate=beginDate;
    toDate =DateTime.now();
    fromDate1=dateNowDash;
    toDate1=DateTime.now().millisecondsSinceEpoch;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double currentWidth=MediaQuery.of(context).size.width;
    TextStyle kStyle=TextStyle(
     fontSize: MediaQuery.of(context).textScaleFactor*20,
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('TILL REPORT',style: TextStyle(
              fontFamily: 'BebasNeue',
              letterSpacing: 2.0
          ),),
          titleSpacing: 0.0,
          backgroundColor: kGreenColor,
          automaticallyImplyLeading: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              child: currentWidth>600?Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                      onPressed: () async {
                        datePicked = await showDatePicker(
                          context: context,
                          initialDate: new DateTime.now(),
                          firstDate:
                          new DateTime.now().subtract(new Duration(days: 300)),
                          lastDate:
                          new DateTime.now().add(new Duration(days: 300)),
                        );
                        var s = datePicked;
                        String a=s.toString().substring(0,10);
                        fromDate=DateTime.parse('$a 0$orgClosedHour:00:00');
                        setState(() {
                          fromDate1=fromDate.millisecondsSinceEpoch;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          // color: kCardColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'From :',
                              style: TextStyle(
                                letterSpacing: 1,
                              ),
                            ),

                            Text(fromDate!=null?fromDate.toString():"")
                          ],
                        ),
                      )),
                  TextButton(
                    onPressed: () async {
                      datePicked = await showDatePicker(
                        context: context,
                        initialDate: new DateTime.now(),
                        firstDate:
                        new DateTime.now().subtract(new Duration(days: 300)),
                        lastDate: new DateTime.now().add(new Duration(days: 300)),
                      );
                      var s = datePicked;
                      String a=s.toString().substring(0,10);
                      toDate=DateTime.parse('$a 0$orgClosedHour:00:00');
                      setState(() {
                        toDate1=toDate.millisecondsSinceEpoch;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        //color: kCardColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'To :',
                            style: TextStyle(
                              letterSpacing: 1,
                            ),
                          ),
                          Text(toDate.toString()),
                        ],
                      ),
                    ),
                  ),
                ],
              ):Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                      onPressed: () async {
                        datePicked = await showDatePicker(
                          context: context,
                          initialDate: new DateTime.now(),
                          firstDate:
                          new DateTime.now().subtract(new Duration(days: 300)),
                          lastDate:
                          new DateTime.now().add(new Duration(days: 300)),
                        );
                        var s = datePicked;
                        String a=s.toString().substring(0,10);
                        fromDate=DateTime.parse('$a 0$orgClosedHour:00:00');
                        setState(() {
                          fromDate1=fromDate.millisecondsSinceEpoch;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          // color: kCardColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'From :',
                              style: TextStyle(
                                letterSpacing: 1,
                              ),
                            ),

                            Text(fromDate!=null?fromDate.toString():"")
                          ],
                        ),
                      )),
                  TextButton(
                    onPressed: () async {
                      datePicked = await showDatePicker(
                        context: context,
                        initialDate: new DateTime.now(),
                        firstDate:
                        new DateTime.now().subtract(new Duration(days: 300)),
                        lastDate: new DateTime.now().add(new Duration(days: 300)),
                      );
                      var s = datePicked;
                      String a=s.toString().substring(0,10);
                      toDate=DateTime.parse('$a 0$orgClosedHour:00:00');
                      setState(() {
                        toDate1=toDate.millisecondsSinceEpoch;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        //color: kCardColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'To :',
                            style: TextStyle(
                              letterSpacing: 1,
                            ),
                          ),
                          Text(toDate.toString()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: StreamBuilder(
                    stream: firebaseFirestore.collection('till_close').where('date',isGreaterThanOrEqualTo: fromDate1).where('date',isLessThanOrEqualTo: toDate1).snapshots(),
                    builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return currentWidth>600?FittedBox(
                        fit: BoxFit.fitWidth,
                        child: DataTable(
                            columns:   [
                              DataColumn(label: Text('User', style:kStyle)),
                              DataColumn(label: Text('Date', style: kStyle)),
                              DataColumn(label: Text('Opening Cash', style: kStyle)),
                              DataColumn(label: Text('Cash sales', style: kStyle)),
                              DataColumn(label: Text('Credit sales', style:kStyle)),
                              DataColumn(label: Text('Card sales', style:kStyle)),
                              DataColumn(label: Text('UPI sales', style: kStyle)),
                              DataColumn(label: Text('EFT sales', style: kStyle)),
                              DataColumn(label: Text('Expense', style: kStyle)),
                              DataColumn(label: Text('Cash Available', style: kStyle)),
                              DataColumn(label: Text('Cash withdrawn', style: kStyle)),
                              DataColumn(label: Text('Closing cash', style: kStyle)),
                            ],
                            rows: snapshot.data.docs.map((document) {
                              return DataRow(cells: [
                                DataCell(Text(document['user'],style: kStyle)),
                                DataCell(Text(convertEpox(document['date']).substring(0,16),style: kStyle)),
                                DataCell(Text(double.parse(document['openingCash']).toStringAsFixed(decimals),style: kStyle)),
                                DataCell(Text(double.parse(document['cashSales']).toStringAsFixed(decimals),style: kStyle)),
                                DataCell(Text(double.parse(document['creditSales']).toStringAsFixed(decimals),style: kStyle)),
                                DataCell(Text(checkCard(document.data(),'card'),style: kStyle)),
                                DataCell(Text(double.parse(document['upiSales']).toStringAsFixed(decimals),style: kStyle)),
                                DataCell(Text(checkCard(document.data(),'eft'),style: kStyle)),
                                DataCell(Text(double.parse(document['expense']).toStringAsFixed(decimals),style: kStyle)),
                                DataCell(Text(double.parse(document['cashAvailable']).toStringAsFixed(decimals),style: kStyle)),
                                DataCell(Text(double.parse(document['cashWithdrawn']).toStringAsFixed(decimals),style: kStyle)),
                                DataCell(Text(double.parse(document['closingCash']).toStringAsFixed(decimals),style: kStyle)),
                              ]);
                            }).toList()),
                      ):
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            columns:   [
                              DataColumn(label: Text('User', style:kStyle)),
                              DataColumn(label: Text('Date', style: kStyle)),
                              DataColumn(label: Text('Opening Cash', style: kStyle)),
                              DataColumn(label: Text('Cash sales', style: kStyle)),
                              DataColumn(label: Text('Credit sales', style:kStyle)),
                              DataColumn(label: Text('Card sales', style:kStyle)),
                              DataColumn(label: Text('UPI sales', style: kStyle)),
                              DataColumn(label: Text('EFT sales', style: kStyle)),
                              DataColumn(label: Text('Expense', style: kStyle)),
                              DataColumn(label: Text('Cash Available', style: kStyle)),
                              DataColumn(label: Text('Cash withdrawn', style: kStyle)),
                              DataColumn(label: Text('Closing cash', style: kStyle)),
                            ],
                            rows: snapshot.data.docs.map((document) {
                              return DataRow(cells: [
                                DataCell(Text(document['user'],style: kStyle)),
                                DataCell(Text(convertEpox(document['date']).substring(0,16),style: kStyle)),
                                DataCell(Text(double.parse(document['openingCash']).toStringAsFixed(decimals),style: kStyle)),
                                DataCell(Text(double.parse(document['cashSales']).toStringAsFixed(decimals),style: kStyle)),
                                DataCell(Text(double.parse(document['creditSales']).toStringAsFixed(decimals),style: kStyle)),
                                DataCell(Text(double.parse(document['cardSales']).toStringAsFixed(decimals),style: kStyle)),
                                DataCell(Text(double.parse(document['upiSales']).toStringAsFixed(decimals),style: kStyle)),
                                DataCell(Text(checkCard(document.data(),'eft'),style: kStyle)),
                                DataCell(Text(double.parse(document['expense']).toStringAsFixed(decimals),style: kStyle)),
                                DataCell(Text(double.parse(document['cashAvailable']).toStringAsFixed(decimals),style: kStyle)),
                                DataCell(Text(double.parse(document['cashWithdrawn']).toStringAsFixed(decimals),style: kStyle)),
                                DataCell(Text(double.parse(document['closingCash']).toStringAsFixed(decimals),style: kStyle)),
                              ]);
                            }).toList()),
                      );
                    }),
              ),
            ),
            // Container(
            //     padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/6),
            //     height:  MediaQuery.of(context).size.height/12,
            //     width: MediaQuery.of(context).size.width,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       children: [
            //         Text('TOTAL',
            //           style: TextStyle(
            //             fontSize: 30.0,
            //             letterSpacing: 2.0,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //         SizedBox(
            //           width: 50.0,
            //         ),
            //         StreamBuilder(stream: firebaseFirestore.collection('expense_transaction').where('date',isGreaterThan: "$dateFrom").where('date',isLessThan: "$dateTo").snapshots(),
            //             builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
            //               if (!snapshot.hasData) {
            //                 return Text(
            //                     '0'
            //                 );
            //               }
            //               var ds = snapshot.data.docs;
            //               double sum = 0.0;
            //               for(int i=0; i<ds.length;i++) {
            //                 print('total ${ds[i]['total']}');
            //                 sum += double.parse(ds[i]['total']);
            //               }
            //               return Text(sum.toStringAsFixed(decimals),
            //                 style: TextStyle(
            //                   fontSize: 30.0,
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               );
            //             }),
            //       ],
            //     )
            // )
          ],
        ),
      ),
    );
  }
}
String convertEpox(int val){
  DateTime date = new DateTime.fromMillisecondsSinceEpoch(val);
  var format = new DateFormat("yMd");
  var dateString = format.format(date);
  return date.toString();
}
String checkCard(var map2,String type){
  int len=map2.length;
  if(len==12){
    if(type=='card')
    return double.parse(map2["cardSales"]).toStringAsFixed(decimals);
else
      return double.parse(map2["eftSales"]).toStringAsFixed(decimals);
  }
else
  return '0.00';
}