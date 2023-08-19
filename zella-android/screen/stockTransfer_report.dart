import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/components/firebase_con.dart';
import 'package:restaurant_app/screen/receipt_report.dart';

import '../constants.dart';
import 'login_page.dart';
DateTime  fromDate;
DateTime toDate =DateTime.now();
String dateFrom='',dateTo='';
int toDate1=0;
int fromDate1=0;
var datePicked;
class StockTransferReport extends StatefulWidget {
  static const String id='stockTransfer_report';

  @override
  _StockTransferReportState createState() => _StockTransferReportState();
}

class _StockTransferReportState extends State<StockTransferReport> {
  int orderIndex=0;
  @override
  void initState() {
    // TODO: implement initState
    fromDate=beginDate;
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
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text('STOCK TRANSFER REPORT',style: TextStyle(
            fontFamily: 'BebasNeue',
            letterSpacing: 2.0
        ),),
        titleSpacing: 0.0,
        backgroundColor: kGreenColor,
        automaticallyImplyLeading: true,

      ),
      body: Column(
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
                                color: kGreenColor,
                                fontWeight: FontWeight.bold
                            ),
                          ),

                          Text(fromDate!=null?fromDate.toString():"",style: TextStyle(color: kGreenColor),)
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
                            color: kGreenColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(toDate.toString(),style: TextStyle(color: kGreenColor),),
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
                                color: kGreenColor,
                                fontWeight: FontWeight.bold
                            ),
                          ),

                          Text(fromDate!=null?fromDate.toString():"",style: TextStyle(color: kGreenColor),)
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
                            color: kGreenColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(toDate.toString(),style: TextStyle(color: kGreenColor),),
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
                  stream: firebaseFirestore.collection('stock_transfer').where('date',isGreaterThanOrEqualTo: fromDate1).where('date',isLessThanOrEqualTo: toDate1).orderBy('date',descending: true) .snapshots(),
                  builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){

                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return currentWidth>600?FittedBox(
                      fit: BoxFit.fitWidth,
                      child: DataTable(columns:
                      [DataColumn(label: Text('SerialNo', style:kStyle)),
                        DataColumn(label: Text('Date', style:kStyle)),
                        DataColumn(label: Text('From', style:kStyle)),
                        DataColumn(label: Text('To', style:kStyle)),
                        DataColumn(label: Text('user', style: kStyle)),
                      ],
                          rows: snapshot.data.docs.map((document) {
                            return DataRow(cells: [
                              DataCell(TextButton(
                                  onPressed: () async {
                                    DocumentSnapshot snapshot =
                                        await firebaseFirestore.collection('stock_transfer').doc(document['orderNo'].toString()).get();
                                    orderIndex = snapshot.get('cartList').length;
                                    showDialog(context: context, builder: (context)=>Center(
                                      child: SingleChildScrollView(
                                        child: Dialog(
                                          child: DataTable(
                                            columns: [  DataColumn(label: Text('Item',
                                              style: kStyle,
                                            )),
                                              DataColumn(label: Text('UOM',
                                                style: kStyle,
                                              ),

                                              ),
                                              DataColumn(label: Text('Qty',
                                                textAlign: TextAlign.center,
                                                style: kStyle,
                                              )),],
                                            rows:List.generate(orderIndex, (index) {
                                              return DataRow(cells: [
                                                DataCell(Text(document[
                                                'cartList']
                                                [index]['name'],
                                                  style:kStyle,)),
                                                DataCell(Text(document[
                                                'cartList']
                                                [index]['uom'],
                                                  style:kStyle,)),
                                                DataCell(Text(document[
                                                'cartList']
                                                [index]['qty'],
                                                  style:kStyle,)),
                                              ]);
                                            }) ,
                                          ),
                                        ),
                                      ),
                                    ));
                                  },
                                  child: Text(document['orderNo'],style: kStyle))),
                              DataCell(Text(convertEpox(document['date']).substring(0,16),style: kStyle)),
                              DataCell(Text(document['fromWarehouse'],style: kStyle)),
                              DataCell(Text(document['toWarehouse'],style: kStyle)),
                              DataCell(Text(document['user'],style: kStyle)),
                            ]);
                          }).toList()),
                    ):
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(columns:
                      [DataColumn(label: Text('SerialNo', style:kStyle)),
                        DataColumn(label: Text('Date', style:kStyle)),
                        DataColumn(label: Text('From', style:kStyle)),
                        DataColumn(label: Text('To', style:kStyle)),
                        DataColumn(label: Text('user', style: kStyle)),
                      ],
                          rows: snapshot.data.docs.map((document) {
                            return DataRow(cells: [
                              DataCell(TextButton(
                                  onPressed: () async {
                                    DocumentSnapshot snapshot =
                                    await firebaseFirestore.collection('stock_transfer').doc(document['orderNo'].toString()).get();
                                    orderIndex = snapshot.get('cartList').length;
                                    showDialog(context: context, builder: (context)=>Center(
                                      child: SingleChildScrollView(
                                        child: Dialog(
                                          child: DataTable(
                                            columns: [  DataColumn(label: Text('Item',
                                              style: kStyle,
                                            )),
                                              DataColumn(label: Text('UOM',
                                                style: kStyle,
                                              ),

                                              ),
                                              DataColumn(label: Text('Qty',
                                                textAlign: TextAlign.center,
                                                style: kStyle,
                                              )),],
                                            rows:List.generate(orderIndex, (index) {
                                              return DataRow(cells: [
                                                DataCell(Text(document[
                                                'cartList']
                                                [index]['name'],
                                                  style:kStyle,)),
                                                DataCell(Text(document[
                                                'cartList']
                                                [index]['uom'],
                                                  style:kStyle,)),
                                                DataCell(Text(document[
                                                'cartList']
                                                [index]['qty'],
                                                  style:kStyle,)),
                                              ]);
                                            }) ,
                                          ),
                                        ),
                                      ),
                                    ));
                                  },
                                  child: Text(document['orderNo'],style: kStyle))),
                              DataCell(Text(convertEpox(document['date']).substring(0,16),style: kStyle)),
                              DataCell(Text(document['fromWarehouse'],style: kStyle)),
                              DataCell(Text(document['toWarehouse'],style: kStyle)),
                              DataCell(Text(document['user'],style: kStyle)),
                            ]);
                          }).toList()),
                    );
                  }),
            ),
          ),
        ],
      ),
    ));
  }
}
