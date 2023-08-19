import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/components/firebase_con.dart';
import 'package:async/async.dart';
import '../constants.dart';
class StreamTax extends StatefulWidget {
  static const String id='stream_tax';
  @override
  _StreamTaxState createState() => _StreamTaxState();
}
DateTime  fromDate;
DateTime toDate =DateTime.now();
String dateFrom='',dateTo='';
var datePicked;
class _StreamTaxState extends State<StreamTax> {
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

  Stream<List<QuerySnapshot>> getData() {
    Stream<QuerySnapshot> stream1 = firebaseFirestore.collection('invoice_data').snapshots();
    Stream<QuerySnapshot> stream2 = firebaseFirestore.collection('purchase').snapshots();
    Stream<QuerySnapshot> stream3 = firebaseFirestore.collection('sales_return').snapshots();
    Stream<QuerySnapshot> stream4 = firebaseFirestore.collection('purchase_return').snapshots();
    return StreamZip([stream1,stream2,stream3,stream4]);
  }
  @override
  Widget build(BuildContext context) {
    TextStyle kStyle=TextStyle(
      fontSize: MediaQuery.of(context).textScaleFactor*20,
    );
    return SafeArea(
      child: Scaffold(
        appBar:AppBar(
          title: Text('POSIMATE',style: TextStyle(
              fontFamily: 'BebasNeue',
              letterSpacing: 2.0
          ),),
          titleSpacing: 0.0,
          backgroundColor: kGreenColor,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
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

                        setState(() {
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
                      toDate = datePicked;
                      //showDialogBox(datePicked.toString());
                      setState(() {
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
                      stream: getData(),
                      builder: (context,AsyncSnapshot<List<QuerySnapshot>> snapshot){
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        List<DocumentSnapshot> documentSnapshot = [];
                        List<dynamic> querySnapshot = snapshot.data.toList();
                        querySnapshot.forEach((query) {
                          documentSnapshot.addAll(query.docs);
                        });
                        return FittedBox(
                          fit: BoxFit.fitWidth,
                          child: DataTable(
                            sortColumnIndex: 0,
                            sortAscending: true,
                            columns: [
                              DataColumn(label: Text('InvoiceNo', style: kStyle )),
                              DataColumn(label: Text('Date', style: kStyle)),
                              // DataColumn(label: Text('ItemName', style: kStyle)),
                              // DataColumn(label: Text('Category', style:kStyle)),
                              // DataColumn(label: Text('TaxName', style: kStyle)),
                              // DataColumn(label: Text('TaxAmt ', style:kStyle)),
                              // DataColumn(label: Text('TaxRate', style: kStyle)),
                              // DataColumn(label: Text('Qty', style: kStyle)),
                              // DataColumn(label: Text('Total', style: kStyle)),
                              // DataColumn(label: Text('Transaction', style: kStyle)),
                            ],
                            rows:documentSnapshot.map((document) {
                              return DataRow(cells: [
                                DataCell(Text(document['orderNo'],style: kStyle)),
                                DataCell(Text(document['date'],style: kStyle)),
                                // DataCell(Text(document['date'],style: kStyle)),
                                // DataCell(Text(document['date'],style: kStyle)),
                                // DataCell(Text(document['date'],style: kStyle)),
                                // DataCell(Text(document['date'],style: kStyle)),
                                // DataCell(Text(document['date'],style: kStyle)),
                              ]);
                            }).toList(),
                          ),
                        );
                      },
                    )
                ))
          ],
        ),
      ),
    );
  }
}
