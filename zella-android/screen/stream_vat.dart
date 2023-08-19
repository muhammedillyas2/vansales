import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/components/firebase_con.dart';

import '../constants.dart';
class StreamVat extends StatefulWidget {
  static const String id='vat_stream';
  @override
  _StreamVatState createState() => _StreamVatState();
}
String dateFrom='',dateTo='';
class _StreamVatState extends State<StreamVat> {
  int orderIndex=0;
  List<String> taxType=['Input Tax','Output Tax','Both'];
  String selectedTaxType='Input Tax';
  DateTime  fromDate;
  DateTime toDate =DateTime.now();
  var datePicked;

  @override
  void initState() {
    // TODO: implement initState
    dateTo = toDate.toString().substring(0, 10);
    List tempTo = dateTo.split('-');
    dateTo = '';
    dateTo += '${tempTo[1]}/${tempTo[2]}/${tempTo[0]}';
    toDate = toDate;
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
        title: Text('TAX REPORT',style: TextStyle(
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
                        fromDate = datePicked;
                        dateFrom = fromDate.toString().substring(0, 10);
                        List tempFrom = dateFrom.split('-');
                        dateFrom = '';
                        setState(() {
                          dateFrom += '${tempFrom[1]}/${tempFrom[2]}/${tempFrom[0]}';
                          print('date $dateFrom $dateTo');
                          fromDate = fromDate;
                          print(fromDate);
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
                      toDate = datePicked;
                      dateTo = toDate.toString().substring(0, 10);
                      List tempTo = dateTo.split('-');
                      dateTo = '';
                      setState(() {
                        dateTo += '${tempTo[1]}/${tempTo[2]}/${tempTo[0]}';
                        toDate = toDate;
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
                  Container(
                    // width: MediaQuery.of(context).size.width / 6,
                    height: 30.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black38,
                          style: BorderStyle.solid,
                          width: 0.80),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: selectedTaxType,
                        items: taxType.map((value) {
                          return DropdownMenuItem(value: value, child: Text(value));
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedTaxType = newValue.toString();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ):
              Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                        fromDate = datePicked;
                        dateFrom = fromDate.toString().substring(0, 10);
                        List tempFrom = dateFrom.split('-');
                        dateFrom = '';
                        setState(() {
                          dateFrom += '${tempFrom[1]}/${tempFrom[2]}/${tempFrom[0]}';
                          print('date $dateFrom $dateTo');
                          fromDate = fromDate;
                          print(fromDate);
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
                      toDate = datePicked;
                      dateTo = toDate.toString().substring(0, 10);
                      List tempTo = dateTo.split('-');
                      dateTo = '';
                      setState(() {
                        dateTo += '${tempTo[1]}/${tempTo[2]}/${tempTo[0]}';
                        toDate = toDate;
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
                  Container(
                    // width: MediaQuery.of(context).size.width / 6,
                    height: 30.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black38,
                          style: BorderStyle.solid,
                          width: 0.80),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: selectedTaxType,
                        items: taxType.map((value) {
                          return DropdownMenuItem(value: value, child: Text(value));
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedTaxType = newValue.toString();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: StreamBuilder(
                      stream: selectedTaxType=='Input Tax'?firebaseFirestore.collection('vat_report').where('date',isGreaterThan: "$dateFrom").where('date',isLessThan: "$dateTo").where('typeStr',whereIn: ['purchase','salesReturn','expense']).snapshots():selectedTaxType=='Output Tax'? firebaseFirestore.collection('vat_report').where('date',isGreaterThan: "$dateFrom").where('date',isLessThan: "$dateTo").where('typeStr',whereIn: ['purchaseReturn','sales']).snapshots():firebaseFirestore.collection('vat_report').where('date',isGreaterThan: "$dateFrom").where('date',isLessThan: "$dateTo").snapshots(),
                      builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return DataTable(columns: [
                          DataColumn(label: Text('InvoiceNo', style: kStyle)),
                          DataColumn(label: Text('Date', style: kStyle)),
                          DataColumn(label: Text('PartyName', style: kStyle)),
                          DataColumn(label: Text('Vat No', style: kStyle)),
                          DataColumn(label: Text('Total', style: kStyle)),
                          DataColumn(label: Text('10% Taxable Amt', style: kStyle)),
                          DataColumn(label: Text('10% Tax Amt', style: kStyle)),
                          DataColumn(label: Text('10% Total', style: kStyle)),
                          DataColumn(label: Text('Exempt', style: kStyle)),
                          DataColumn(label: Text('Transaction', style: kStyle)),
                        ], rows: snapshot.data.docs.map((document) {
                          return DataRow(cells: [
                            DataCell(TextButton(
                                onPressed: () async {
                                  DocumentSnapshot snapshot =
                                  await firebaseFirestore
                                      .collection('${document['typeStr']}')
                                      .doc(document['orderNo']
                                      .toString())
                                      .get();
                                  orderIndex =
                                      snapshot.get('cartList').length;
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
                                            )),
                                            DataColumn(label: Text('Price',
                                              style:kStyle,)),],
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
                                              DataCell(Text(document[
                                              'cartList']
                                              [index]['price'],
                                                style:kStyle,)),

                                            ]);
                                          }) ,
                                        ),
                                      ),
                                    ),
                                  ));
                                },
                                child: Text(document['orderNo'],style: kStyle,))),
                            DataCell(Text(document['date'],style: kStyle)),
                            DataCell(Text(document['partyName'],style: kStyle)),
                            DataCell(Text(document['vatNo'],style: kStyle)),
                            DataCell(Text(document['total'],style: kStyle)),
                            DataCell(Text(document['taxable5'],style: kStyle)),
                            DataCell(Text(document['tax5'],style: kStyle)),
                            DataCell(Text(document['total5'],style: kStyle)),
                            DataCell(Text(document['exempt'],style: kStyle)),
                            DataCell(Text(document['typeStr'],style: kStyle)),
                          ]);
                        }).toList());
                      }
                  ),
                ),
              ),
            ),
          ]),
    ));
  }
}
