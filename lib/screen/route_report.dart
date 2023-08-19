
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
// import 'package:restaurant_app/components/admin_firebase.dart';
 // import 'package:restaurant_app/components/admin_firebase.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/components/firebase_con.dart';
import 'package:restaurant_app/screen/pos_screen.dart';
// import 'package:sunmi_printer_plus/column_maker.dart';
// import 'package:sunmi_printer_plus/enums.dart';
// import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
// import 'package:sunmi_printer_plus/sunmi_style.dart';
import '../constants.dart';
import 'login_page.dart';
import 'package:get/get.dart';

import 'organisation_screen.dart';
// import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';




class RouteReport extends StatefulWidget {
  static const String id = 'saleReport';
  // const SaleReport({Key? key}) : super(key: key);

  @override
  _RouteReportState createState() => _RouteReportState();
}

class _RouteReportState extends State<RouteReport> {

  @override
  void initState() {
    super.initState();
    // fromDate=beginDate;
    print(selectedcurrentroute2);
    DateTime date =  DateTime.now();
    fromDate =  new DateTime(date.year,date.month, date.day);
    fromDate1 = fromDate.millisecondsSinceEpoch;
    toDate =DateTime.now();
    toDate1=toDate.millisecondsSinceEpoch;
    print( fromDate1);
    print(toDate1);


  }

  String invoice_data = 'invoice_data';


  Future displayItems(int index) async {}

  @override
  Widget build(BuildContext context) {
    double currentWidth = MediaQuery.of(context).size.width;
    TextStyle kStyle = TextStyle(
      fontSize: MediaQuery.of(context).textScaleFactor * 20,
    );
    // read('invoice_data','');

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('ROUTE WISE REPORT',style: TextStyle(
                fontFamily: 'BebasNeue',
                letterSpacing: 2.0
            ),),
            titleSpacing: 0.0,
            backgroundColor: kGreenColor,
            automaticallyImplyLeading: true,

          ),
          body: Container(
            height: currentWidth = MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          // var s = datePicked;
                          // String a=s.toString().substring(0,10);
                          fromDate= datePicked;
                          setState(() {
                            fromDate1=fromDate.millisecondsSinceEpoch;
                            print('from:$fromDate1');
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

                              Text(fromDate!=null?fromDate.toString().substring(0,16):"",style: TextStyle(color: kGreenColor),)
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
                       toDate = datePicked;

                        // String a=s.toString().substring(0,10);
                        // toDate=DateTime.parse('$a 0$orgClosedHour:00:00');
                        setState(() {
                          toDate1=toDate.millisecondsSinceEpoch;
                          print('to:$toDate1');
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
                            Text(toDate.toString().substring(0,16),style: TextStyle(color: kGreenColor),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              DropdownButton(
                icon:Icon(Icons.directions_car) ,
                underline: SizedBox(),
                value: selectedcurrentroute2, // Not necessary for Option 1
                items: currentroutes3.map((String val) {
                  return DropdownMenuItem(
                    child: new Text(val.toString(),
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                          color: kGreenColor
                      ),
                    ),
                    value: val,
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedcurrentroute2 = newValue;
                  });

                },
              ),


                Container(
                  height: MediaQuery.of(context).size.height*0.8,
                  // alignment: FractionalOffset.center,
                  color: Colors.white,
                  child: StreamBuilder(
                      stream: firebaseFirestore.collection('invoice_data').where('date',isGreaterThan: fromDate1).where('date',isLessThanOrEqualTo: toDate1).snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {

                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        List rinvoiceNumberList = [];
                        List<String> rcustomermobileList = [];
                        List<String> rcustomerNameFromInvList = [];
                        List<int> rdateList = [];
                        List<String> rpayList = [];
                        List<String> rtotList = [];
                        List<String> rcreatedbyList = [];
                        List<String> ruserList = [];
                        List<String> rdelivList = [];

                        var ds = snapshot.data?.docs;
                        double totdisplay = 0.0;
                        print(selectedcurrentroute2.toString().trim());
                        for (int i = 0; i < ds.length; i++) {
                          if (ds[i]['route'] == selectedcurrentroute2.toString().trim()) {
                            totdisplay+=double.parse(ds[i]['total']);
                            rcustomerNameFromInvList.add(ds[i]['customer']);
                            rinvoiceNumberList.add(ds[i]['orderNo']);
                            rdateList.add(ds[i]['date']);
                            rpayList.add(ds[i]['payment']);
                            rtotList.add(ds[i]['total']);
                            rcreatedbyList.add(ds[i]['createdBy']);
                            ruserList.add(ds[i]['user']);
                            rdelivList.add(ds[i]['deliveryType']);

                          }
                        }

                        return ListView(

                          children: [
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: DataTable(
                                  columns: [

                                    DataColumn(
                                        label: Text('Date',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                  .textScaleFactor *
                                                  20,
                                            ))),
                                    DataColumn(
                                        label: Text('Customer',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                  .textScaleFactor *
                                                  20,
                                            ))),
                                    DataColumn(
                                        label: Text('Total',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                  .textScaleFactor *
                                                  20,
                                            ))),
                                    DataColumn(
                                        label: Text('Payment',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                  .textScaleFactor *
                                                  20,
                                            ))),
                                    DataColumn(
                                        label: Text('Invoice No',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                  .textScaleFactor *
                                                  20,
                                            ))),
                                    DataColumn(
                                        label: Text('Created By',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                  .textScaleFactor *
                                                  20,
                                            ))),
                                    DataColumn(
                                        label: Text('Delivery',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                  .textScaleFactor *
                                                  20,
                                            ))),
                                    DataColumn(
                                        label: Text('User',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                  .textScaleFactor *
                                                  20,
                                            ))),
                                  ],
                                  rows: List.generate(
                                  rcustomerNameFromInvList.length,
                                      (index) => DataRow(cells: [
                                        DataCell(
                                            Text(convertEpox(rdateList[index]).substring(0,16),style: kStyle,)),
                                    DataCell(
                                        Text(rcustomerNameFromInvList[index],style: kStyle,)),
                                        DataCell(
                                            Text(rtotList[index],style: kStyle,)),
                                        DataCell(
                                            Text(rpayList[index],style: kStyle,)),
                                        DataCell(Text(rinvoiceNumberList[index],style: kStyle,)),
                                        DataCell(Text(rcreatedbyList[index],style: kStyle,)),
                                        DataCell(Text(rdelivList[index],style: kStyle,)),
                                        DataCell(Text(ruserList[index],style: kStyle,)),

                                  ])).toList()
                                      .toList()
                              ),
                            ),
                            Visibility(
                              visible:rcustomerNameFromInvList.length!=0?true:false,
                              child: Card(
                                elevation: 10,
                                color: kItemContainer,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: kItemContainer, width: 3),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('Total',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).textScaleFactor*22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30.0,
                                      ),
                                      Text(totdisplay.toStringAsFixed(2),
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).textScaleFactor*22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],),
                                ),),
                            )

                          ],
                        );
                      
                      }),
                ),
                

              ],
            ),
          ),
        ));
  }
}