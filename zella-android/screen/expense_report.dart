import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/components/firebase_con.dart';
import 'package:restaurant_app/screen/stream_reports.dart';

import '../constants.dart';
import 'expense_transaction.dart';
import 'login_page.dart';
class ExpenseReport extends StatefulWidget {
static const String id='expense_report';
  @override
  _ExpenseReportState createState() => _ExpenseReportState();
}
DateTime  fromDate;
DateTime toDate =DateTime.now();
int toDate1=0;
int fromDate1=0;
String dateFrom='',dateTo='';
var datePicked;
class _ExpenseReportState extends State<ExpenseReport> {
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
          title: Text('EXPENSE REPORT',style: TextStyle(
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
              child:currentWidth>600? Row(
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
                    stream: firebaseFirestore.collection('expense_transaction').where('date',isGreaterThanOrEqualTo: fromDate1).where('date',isLessThanOrEqualTo: toDate1).snapshots(),
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
                              DataColumn(label: Text('InvoiceNo', style:kStyle)),
                              DataColumn(label: Text('Date', style: kStyle)),
                              DataColumn(label: Text('ExpenseHead', style: kStyle)),
                              DataColumn(label: Text('Payment', style: kStyle)),
                              DataColumn(label: Text('Amount', style:kStyle)),
                              DataColumn(label: Text('Note', style: kStyle)),
                              DataColumn(label: Text('User', style: kStyle)),
                              DataColumn(label: Text('Tax', style: kStyle)),
                              if(orgInvoiceEdit=='true')
                              DataColumn(label: Text('Edit', style: kStyle)),
                            ],
                            rows: snapshot.data.docs.map((document) {
                              return DataRow(cells: [
                                DataCell(Text(document['orderNo'],style: kStyle)),
                                DataCell(Text(convertEpox(document['date']).substring(0,16),style: kStyle)),
                                DataCell(Text(document['expense'],style: kStyle)),
                                DataCell(Text(document['payment'],style: kStyle)),
                                DataCell(Text(document['total'],style: kStyle)),
                                DataCell(Text(document['note'],style: kStyle)),
                                DataCell(Text(document['user'],style: kStyle)),
                                DataCell(Text(document['tax'],style: kStyle)),
                                if(orgInvoiceEdit=='true')
                                DataCell(IconButton(onPressed: () async {
                                  // bool isOnline = await hasNetwork();
                                  // if(!isOnline){
                                  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Internet is not available')));
                                  //   return;
                                  // }
                                  expenseEditInv.value=true;
                                  invEditNumber.value=document['orderNo'];
                                  invEditTotal.value=document['total'];
                                  invEditHead.value=document['expense'];
                                  invEditNote.value=document['note'];
                                  invEditTax.value=document['tax'];
                                  invDate.value=document['date'];
                                  invEditPaymentMethod.value=document['payment'];
                                  await read('expense_head');
                                  Navigator.pushReplacement(
                                    context, MaterialPageRoute(builder: (context) => ExpenseTransaction()),
                                  );
                                },
                                  icon: Icon(Icons.edit),
                                  iconSize: 40,
                                )),
                              ]);
                            }).toList()),
                      ):
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            columns:   [
                              DataColumn(label: Text('InvoiceNo', style:kStyle)),
                              DataColumn(label: Text('Date', style: kStyle)),
                              DataColumn(label: Text('ExpenseHead', style: kStyle)),
                              DataColumn(label: Text('Payment', style: kStyle)),
                              DataColumn(label: Text('Amount', style:kStyle)),
                              DataColumn(label: Text('Note', style: kStyle)),
                              DataColumn(label: Text('User', style: kStyle)),
                              DataColumn(label: Text('Tax', style: kStyle)),
                            ],
                            rows: snapshot.data.docs.map((document) {
                              return DataRow(cells: [
                                DataCell(Text(document['orderNo'],style: kStyle)),
                                DataCell(Text(convertEpox(document['date']).substring(0,16),style: kStyle)),
                                DataCell(Text(document['expense'],style: kStyle)),
                                DataCell(Text(document['payment'],style: kStyle)),
                                DataCell(Text(document['total'],style: kStyle)),
                                DataCell(Text(document['note'],style: kStyle)),
                                DataCell(Text(document['user'],style: kStyle)),
                                DataCell(Text(document['tax'],style: kStyle)),
                              ]);
                            }).toList()),
                      );
                    }),
              ),
            ),
            Container(
                padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/6),
                height:  MediaQuery.of(context).size.height/12,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('TOTAL',
                      style: TextStyle(
                        fontSize: 30.0,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 50.0,
                    ),
                    StreamBuilder(
                        stream: firebaseFirestore.collection('expense_transaction').where('date',isGreaterThanOrEqualTo: fromDate1).where('date',isLessThanOrEqualTo: toDate1).snapshots(),
                        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                          if (!snapshot.hasData) {
                            return Text(
                                '0'
                            );
                          }
                          var ds = snapshot.data.docs;
                          double sum = 0.0;
                          for(int i=0; i<ds.length;i++) {
                            print('total ${ds[i]['total']}');
                            sum += double.parse(ds[i]['total']);
                          }
                          return Text(sum.toStringAsFixed(decimals),
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
                  ],
                )
            )
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