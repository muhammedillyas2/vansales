import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/components/firebase_con.dart';

import '../constants.dart';
import 'login_page.dart';
String docName='';
String collectionName='';
String selectedUser=currentUser;
DateTime  fromDate;
DateTime toDate =DateTime.now();
String dateFrom='',dateTo='';
int toDate1=0;
int fromDate1=0;
var datePicked;
List<String> crInv=[];
List<int> crDate=[];
List<String> crPayment=[];
List<String> crTotal=[];
List<String> crTransaction=[];
class ReceivablePayable extends StatefulWidget {
  static const String id='receivable_payable';
  final String type;
  const ReceivablePayable({Key key, this.type}) : super(key: key);
  @override
  _ReceivablePayableState createState() => _ReceivablePayableState(type);
}

class _ReceivablePayableState extends State<ReceivablePayable> {
  final String type;
  _ReceivablePayableState(this.type);
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
          Expanded(
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: StreamBuilder(
                  stream: firebaseFirestore.collection('''${type=='RECEIVABLE'?'customer_details':'vendor_data'}''').snapshots(),
                  builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){

                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return DataTable(columns:
                    [DataColumn(label: Text('PartyName', style:kStyle)),
                      DataColumn(label: Text('Net Balance', style:kStyle)),
                    ],
                        rows: snapshot.data.docs.map((document) {
                          return DataRow(cells: [
                            DataCell(TextButton(
                                onPressed: (){
                                  docName=document['${type=='RECEIVABLE'?'customerName':'vendorName'}'];
                                  collectionName=type=='RECEIVABLE'?'customer_report':'vendor_report';
                                  crInv=[];
                                  crDate=[];
                                  crPayment=[];
                                  crTotal=[];
                                  crTransaction=[];
                                  toDate =DateTime.now();
                                  toDate1=DateTime.now().millisecondsSinceEpoch;
                                  showDialog(context: context, builder: (BuildContext context){
                                    return StreamBuilder(
                                        stream: firebaseFirestore.collection(collectionName).doc(docName).snapshots(),
                                        builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot2) {
                                          if (!snapshot2.hasData) {
                                            return Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          }
                                          if (!snapshot2.data.exists) {
                                            return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12.0)),
                                                child: Center(child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text('No data'),
                                                )));
                                          }
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12.0)),
                                            child: StatefulBuilder(
                                                builder: (context,setState){
                                                  return SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: SingleChildScrollView(
                                                      scrollDirection: Axis.vertical,
                                                      child: Column(
                                                        children: [
                                                         currentWidth>600? Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                                                  toDate = datePicked;
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
                                                              TextButton(onPressed: () async {
                                                                print('presss');
                                                                crInv=[];
                                                                crDate=[];
                                                                crPayment=[];
                                                                crTotal=[];
                                                                crTransaction=[];
                                                                for(int i=0;i<snapshot2.data['data'].length;i++){
                                                                  print('presss $toDate1');
                                                                  print('presss ${snapshot2.data['data'][i]['date']}');
                                                                  if(snapshot2.data['data'][i]['date']>=fromDate1 && snapshot2.data['data'][i]['date']<=toDate1) {
                                                                    print('inside $fromDate1');
                                                                    crInv.add(snapshot2.data['data'][i]['invNo']);
                                                                    print(crInv);
                                                                    crDate.add(snapshot2.data['data'][i]['date']);
                                                                    crPayment.add(snapshot2.data['data'][i]['payment']);
                                                                    crTotal.add(snapshot2.data['data'][i]['total'].toString());
                                                                    crTransaction.add(snapshot2.data['data'][i]['type']);
                                                                  }
                                                                }

                                                                setState(()  {

                                                                });
                                                              },
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.black,
                                                                      borderRadius: BorderRadius.circular(10.0),
                                                                    ),
                                                                    padding: EdgeInsets.all(10.0),
                                                                    child: Text(
                                                                      'Search',
                                                                      style: TextStyle(
                                                                          letterSpacing: 1.0,
                                                                          color: kItemContainer
                                                                      ),
                                                                    ),
                                                                  )),
                                                            ],
                                                          ):
                                                         Column(
                                                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                                                 toDate = datePicked;
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
                                                             TextButton(onPressed: () async {
                                                               print('presss');
                                                               crInv=[];
                                                               crDate=[];
                                                               crPayment=[];
                                                               crTotal=[];
                                                               crTransaction=[];
                                                               for(int i=0;i<snapshot2.data['data'].length;i++){
                                                                 print('presss $toDate1');
                                                                 print('presss ${snapshot2.data['data'][i]['date']}');
                                                                 if(snapshot2.data['data'][i]['date']>=fromDate1 && snapshot2.data['data'][i]['date']<=toDate1) {
                                                                   print('inside $fromDate1');
                                                                   crInv.add(snapshot2.data['data'][i]['invNo']);
                                                                   print(crInv);
                                                                   crDate.add(snapshot2.data['data'][i]['date']);
                                                                   crPayment.add(snapshot2.data['data'][i]['payment']);
                                                                   crTotal.add(snapshot2.data['data'][i]['total'].toString());
                                                                   crTransaction.add(snapshot2.data['data'][i]['type']);
                                                                 }
                                                               }

                                                               setState(()  {

                                                               });
                                                             },
                                                                 child: Container(
                                                                   decoration: BoxDecoration(
                                                                     color: Colors.black,
                                                                     borderRadius: BorderRadius.circular(10.0),
                                                                   ),
                                                                   padding: EdgeInsets.all(10.0),
                                                                   child: Text(
                                                                     'Search',
                                                                     style: TextStyle(
                                                                         letterSpacing: 1.0,
                                                                         color: kItemContainer
                                                                     ),
                                                                   ),
                                                                 )),
                                                           ],
                                                         ),
                                                          currentWidth>600?DataTable(columns: [
                                                            DataColumn(label: Text('InvoiceNo', style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 16,))),
                                                            DataColumn(label: Text('Date', style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 16,))),
                                                            DataColumn(label: Text('Payment Mode', style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 16,))),
                                                            DataColumn(label: Text('Total', style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 16,))),
                                                            DataColumn(label: Text('Type', style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 16,))),
                                                          ],
                                                              rows: List.generate(
                                                                  crInv.length, (index) =>
                                                                  DataRow(cells: [
                                                                    DataCell(Text(crInv[index], style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 15,))),
                                                                    DataCell(Text(convertEpox(crDate[index]).substring(0,16), style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 15,))),
                                                                    DataCell(Text(crPayment[index].contains('*')?crPayment[index].replaceAll('*','/'):crPayment[index], style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 15,))),
                                                                    DataCell(Text(crTotal[index].contains('*')?crTotal[index].replaceAll('*','/'):crTotal[index], style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 15,))),
                                                                    DataCell(Text(crTransaction[index], style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 15,))),]))):
                                                          DataTable(columns: [
                                                            DataColumn(label: Text('InvoiceNo', style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 16,))),
                                                            DataColumn(label: Text('Date', style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 16,))),
                                                            DataColumn(label: Text('Payment Mode', style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 16,))),
                                                            DataColumn(label: Text('Total', style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 16,))),
                                                            DataColumn(label: Text('Type', style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 16,))),
                                                          ],
                                                              rows: List.generate(
                                                                  crInv.length, (index) =>
                                                                  DataRow(cells: [
                                                                    DataCell(Text(crInv[index], style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 15,))),
                                                                    DataCell(Text(convertEpox(crDate[index]).substring(0,16), style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 15,))),
                                                                    DataCell(Text(crPayment[index].contains('*')?crPayment[index].replaceAll('*','/'):crPayment[index], style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 15,))),
                                                                    DataCell(Text(crTotal[index].contains('*')?crTotal[index].replaceAll('*','/'):crTotal[index], style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 15,))),
                                                                    DataCell(Text(crTransaction[index], style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 15,))),]))),
                                                          Container(
                                                              padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/6),
                                                              height:  MediaQuery.of(context).size.height/12,
                                                              width: MediaQuery.of(context).size.width,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                children: [
                                                                  Text('Net Balance',
                                                                    style: TextStyle(
                                                                      fontSize:  currentWidth>600?30.0:20,
                                                                      letterSpacing: 2.0,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 50.0,
                                                                  ),
                                                                  StreamBuilder(stream: firebaseFirestore.collection(collectionName).doc(docName).snapshots(),
                                                                      builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot){
                                                                        if (!snapshot.hasData) {
                                                                          return Text(
                                                                              '0'
                                                                          );
                                                                        }
                                                                        var ds = snapshot.data['data'];
                                                                        double totalCredit = 0.0;
                                                                        double totalReturnsCredit = 0.0;
                                                                        double receipts = 0.0;
                                                                        double payments = 0.0;
                                                                        double balance = 0.0;
                                                                        if(type=='RECEIVABLE'){
                                                                          for(int i=0; i<ds.length;i++){
                                                                            if(ds[i]['type']=='Sales' || ds[i]['type']=='Sales Return') {
                                                                              if(ds[i]['payment'].contains('*')){
                                                                                List tempDPayment=ds[i]['payment'].split('*');
                                                                                List tempDTotal=ds[i]['total'].split('*');
                                                                                for(int j=0;j<2;j++){
                                                                                  print('iiiiii ${tempDPayment[j]}');
                                                                                  if(tempDPayment[j].toString().trim()=='Credit'){
                                                                                    print('inside if equals credit ${ds[i]['invNo']}');
                                                                                    if(ds[i]['type']=='Sales') {
                                                                                      totalCredit += double.parse(tempDTotal[j].toString().trim());
                                                                                    } else {
                                                                                      totalReturnsCredit += double.parse(tempDTotal[j].toString().trim());
                                                                                    }
                                                                                  }
                                                                                }
                                                                              }
                                                                              else{
                                                                                if(ds[i]['payment']=='Credit'){
                                                                                  if(ds[i]['type']=='Sales') {
                                                                                    totalCredit +=double.parse(ds[i]['total'].toString());
                                                                                  } else {
                                                                                    totalReturnsCredit += double.parse(ds[i]['total'].toString());
                                                                                  }
                                                                                }
                                                                              }
                                                                            }
                                                                            else if(ds[i]['type']=='Receipt'){
                                                                              receipts+=ds[i]['total'];
                                                                            }
                                                                          }
                                                                          balance=totalCredit-(receipts+totalReturnsCredit);
                                                                        }
                                                                        else{
                                                                          for(int i=0; i<ds.length;i++){
                                                                            if(ds[i]['payment']=='Credit'){
                                                                              if(ds[i]['type']=='Purchase') {
                                                                                totalCredit += ds[i]['total'];
                                                                              } else {
                                                                                totalReturnsCredit += ds[i]['total'];
                                                                              }
                                                                            }
                                                                            else if(ds[i]['type']=='Payment'){
                                                                              payments+=ds[i]['total'];
                                                                            }
                                                                          }
                                                                          balance=totalCredit-(payments+totalReturnsCredit);
                                                                        }
                                                                        return Text(balance.toStringAsFixed(decimals),
                                                                          style: TextStyle(
                                                                            fontSize: currentWidth>600?30.0:20.0,
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
                                            ),
                                          );
                                        }
                                    );
                                  });

                                },
                                child: Text(document['${type=='RECEIVABLE'?'customerName':'vendorName'}'],style: kStyle))),
                            DataCell(Text(document['balance'],style: kStyle)),
                          ]);
                        }).toList());
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
