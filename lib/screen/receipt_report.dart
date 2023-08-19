import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_app/components/firebase_con.dart';

import '../constants.dart';
import 'login_page.dart';
String collectionName='';
DateTime  fromDate;
DateTime toDate =DateTime.now();
String dateFrom='',dateTo='';
int toDate1=0;
int fromDate1=0;
var datePicked;
class ReceiptReport extends StatefulWidget {
  static const String id='receipt_report';
final String type;

  const ReceiptReport({Key key, this.type}) : super(key: key);
  @override
  _ReceiptReportState createState() => _ReceiptReportState(type);
}

class _ReceiptReportState extends State<ReceiptReport> {
  final String type;

  _ReceiptReportState(this.type);
  @override
  void initState() {
    // TODO: implement initState
    collectionName=type=='RECEIPT'?'receipt_data':'payment_data';
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
        title: Text('$type REPORT',style: TextStyle(
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
            child:currentWidth>600?  Row(
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
                  stream: firebaseFirestore.collection(collectionName).where('date',isGreaterThanOrEqualTo: fromDate1).where('date',isLessThanOrEqualTo: toDate1).orderBy('date',descending: true) .snapshots(),
                  builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){

                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return currentWidth>600?FittedBox(
                      fit: BoxFit.fitWidth,
                      child: DataTable(columns:
                      [DataColumn(label: Text('InvoiceNo', style:kStyle)),
                        DataColumn(label: Text('Date', style:kStyle)),
                        DataColumn(label: Text('PartyName', style:kStyle)),
                        DataColumn(label: Text('Payment Mode', style:kStyle)),
                        DataColumn(label: Text('Total', style: kStyle)),
                      ],
                          rows: snapshot.data.docs.map((document) {
                            return DataRow(cells: [
                              DataCell(Text(document['orderNo'],style: kStyle)),
                              DataCell(Text(convertEpox(document['date']).substring(0,16),style: kStyle)),
                              DataCell(Text(document['partyName'],style: kStyle)),
                              DataCell(Text(document['payment'],style: kStyle)),
                              DataCell(Text(document['total'],style: kStyle)),
                            ]);
                          }).toList()),
                    ):
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(columns:
                      [DataColumn(label: Text('InvoiceNo', style:kStyle)),
                        DataColumn(label: Text('Date', style:kStyle)),
                        DataColumn(label: Text('PartyName', style:kStyle)),
                        DataColumn(label: Text('Payment Mode', style:kStyle)),
                        DataColumn(label: Text('Total', style: kStyle)),
                      ],
                          rows: snapshot.data.docs.map((document) {
                            return DataRow(cells: [
                              DataCell(Text(document['orderNo'],style: kStyle)),
                              DataCell(Text(convertEpox(document['date']).substring(0,16),style: kStyle)),
                              DataCell(Text(document['partyName'],style: kStyle)),
                              DataCell(Text(document['payment'],style: kStyle)),
                              DataCell(Text(document['total'],style: kStyle)),
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
String convertEpox(int val){
  DateTime date = new DateTime.fromMillisecondsSinceEpoch(val);
  var format = new DateFormat("yMd");
  var dateString = format.format(date);
  return date.toString();
}