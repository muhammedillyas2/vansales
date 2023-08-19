import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/components/database_con.dart';

import 'package:restaurant_app/components/firebase_con.dart';
import 'package:restaurant_app/screen/purchase_report.dart';
import 'package:restaurant_app/screen/receipt_report.dart';
import 'package:restaurant_app/screen/stream_reports.dart';
import 'expense_report.dart';
import 'login_page.dart';
import 'new_dashBoard.dart';
class OwnerDash extends StatefulWidget {
static const String id='owner_dash';
  @override
  _OwnerDashState createState() => _OwnerDashState();
}

class _OwnerDashState extends State<OwnerDash> {
  List<String> categoryListDash=[];
  List<double> categoryCountListDash=[];
  List<double> categoryValueListDash=[];
  List<String> itemListDash=[];
  List<double> itemCountListDash=[];
  List<double> itemValueListDash=[];
  int orderIndex=0;
  List<Stream> stream=[firebaseFirestore.collection('invoice_data').where('date',isGreaterThan:dateNowDash).snapshots(),
    firebaseFirestore.collection('expense_transaction').where('date',isGreaterThan:dateNowDash).snapshots(),
    firebaseFirestore.collection('receipt_data').where('date', isGreaterThan: dateNowDash).snapshots(),
    firebaseFirestore.collection('payment_data').where('date', isGreaterThan: dateNowDash).snapshots(),
    firebaseFirestore.collection('purchase').where('date',isGreaterThan:dateNowDash).snapshots(),
    firebaseFirestore.collection('user_data').where('userName', isEqualTo: currentUser).snapshots()
  ];
  Future<void> getTillClose() async {
    cashAvailableDash=0;
    openingDash=0;
    cashSalesDash=0;
    cashPurchaseDash=0;
    cashSalesReturnDash=0;
    cashPurchaseReturnDash=0;
    expenseDash=0;
    receiptAmtDash=0;
    paymentAmtDash=0;
    QuerySnapshot doc1;
    QuerySnapshot doc2;
    QuerySnapshot doc3;
    QuerySnapshot doc4;
    QuerySnapshot doc5;
    QuerySnapshot doc6;
    QuerySnapshot doc7;
    QuerySnapshot doc8;
    doc1 = await firebaseFirestore
        .collection('user_data')
        .where(
        'userName', isEqualTo: currentUser)
        .get();
    doc2 = await firebaseFirestore
        .collection('invoice_data').where(
        'user', isEqualTo: currentUser).where(
        'payment', isEqualTo: 'Cash')
        .where('date',
        isGreaterThanOrEqualTo: tillCloseTime)
        .get();
    doc3 = await firebaseFirestore
        .collection('expense_transaction')
        .where('user', isEqualTo: currentUser)
        .where('date',
        isGreaterThanOrEqualTo: tillCloseTime).where('payment',isEqualTo:'Cash')
        .get();
    doc4= await firebaseFirestore
        .collection('receipt_data').where('user', isEqualTo: currentUser).where('date',
        isGreaterThanOrEqualTo: tillCloseTime).where('payment',isEqualTo:'Cash')
        .get();
    doc5 = await firebaseFirestore
        .collection('payment_data')
        .where('user', isEqualTo: currentUser)
        .where('date',
        isGreaterThanOrEqualTo: tillCloseTime).where('payment',isEqualTo:'Cash')
        .get();
    doc6= await firebaseFirestore
        .collection('purchase')
        .where('user', isEqualTo: currentUser)
        .where('date',
        isGreaterThanOrEqualTo: tillCloseTime).where('payment',isEqualTo:'Cash')
        .get();
    doc7= await firebaseFirestore
        .collection('sales_return')
        .where('user', isEqualTo: currentUser)
        .where('date',
        isGreaterThanOrEqualTo: tillCloseTime).where('payment',isEqualTo:'Cash')
        .get();
    doc8= await firebaseFirestore
        .collection('purchase_return')
        .where('user', isEqualTo: currentUser)
        .where('date',
        isGreaterThanOrEqualTo: tillCloseTime).where('payment',isEqualTo:'Cash')
        .get();
    openingDash= double.parse(doc1.docs[0].get('tillClose').toString());
    for(int i=0;i<doc2.size;i++){
      cashSalesDash+=double.parse(doc2.docs[i].get('total'));
    }
    for(int i=0;i<doc3.size;i++){
      expenseDash+=double.parse(doc3.docs[i].get('total'));
    }
    for(int i=0;i<doc4.size;i++){
      receiptAmtDash+=double.parse(doc4.docs[i].get('total'));
    }
    for(int i=0;i<doc5.size;i++){
      paymentAmtDash+=double.parse(doc5.docs[i].get('total'));
    }
    for(int i=0;i<doc6.size;i++){
      cashPurchaseDash+=double.parse(doc6.docs[i].get('total'));
    }
    for(int i=0;i<doc7.size;i++){
      cashSalesReturnDash+=double.parse(doc7.docs[i].get('total'));
    }
    for(int i=0;i<doc8.size;i++){
      cashPurchaseReturnDash+=double.parse(doc8.docs[i].get('total'));
    }
    setState(() {
      cashAvailableDash=(openingDash+cashSalesDash+receiptAmtDash+cashPurchaseReturnDash)-(expenseDash+paymentAmtDash+cashPurchaseDash+cashSalesReturnDash);
      showCash=true;
    });
  }
  @override
  Widget build(BuildContext context) {
    TextStyle kStyle=TextStyle(
      fontSize: MediaQuery.of(context).textScaleFactor*15,
    );
    return SafeArea(child: Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Container(
                  width: 180,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                              'images/dot_logo.png'
                          )
                      )
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(6.0),
           //height: MediaQuery.of(context).size.height/2,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0, crossAxisCount: 3,
                    // maxCrossAxisExtent: MediaQuery.of(context).size.width/6,
                    // mainAxisExtent: MediaQuery.of(context).size.height/7,
                  ),
                 scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return StreamBuilder(
                        stream: stream[index],
                        builder:(BuildContext context,AsyncSnapshot<dynamic> snapshot) {
                          if (!snapshot.hasData) {
                            return Text(
                              '0' ,style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                            );
                          }
                          double sum = 0.0;
                          if(index!=5){
                            var ds = snapshot.data.docs;
                            for(int i=0; i<ds.length;i++)
                              sum+=double.parse(ds[i]['total']);
                          }

                          return Card(
                            elevation: 12.0,
                            child: Center(child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                index==5?Visibility(
                                  visible: showCash,
                                  child: AutoSizeText(cashAvailableDash.toStringAsFixed(decimals),
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).textScaleFactor*18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  replacement: IconButton(onPressed: () async {
                                    await getTillClose();
                                  },
                                    icon: Icon(Icons.refresh,size: 30,),
                                  ),
                                ):GestureDetector(
                                  onTap: (){
                                    if (index == 0)
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>StreamReports(transactionType: 'invoice_data')));
                                    else if(index==1)
                                      Navigator.pushNamed(context, ExpenseReport.id);
                                    else if(index==2)
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ReceiptReport(type: 'RECEIPT')));
                                    else if(index==3)
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ReceiptReport(type: 'PAYMENT')));
                                    else if(index==4)
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PurchaseReport(transactionType: 'purchase')));
                                  },
                                  child: Text( sum.toStringAsFixed(decimals),
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).textScaleFactor*18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                index==5? Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AutoSizeText(newDashMenu[index],
                                        maxLines: 1,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold
                                        //  fontSize: MediaQuery.of(context).textScaleFactor*8,
                                        ),
                                      ),
                                      Expanded(
                                        child: Visibility(
                                            maintainSize: false,
                                            visible: showCash,
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: ()async{
                                                await getTillClose();
                                              },
                                              icon: Icon(Icons.refresh),
                                            )),
                                      )
                                    ],),
                                ):AutoSizeText(newDashMenu[index],
                                  maxLines: 1,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold
                                    //fontSize: MediaQuery.of(context).textScaleFactor*8,
                                  ),
                                ),
                              ],
                            )
                            ),
                          );
                        }
                    );
                  }),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width/1.1,
                height: MediaQuery.of(context).size.height/2,
                child: Card(
                  elevation: 12.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Text('Category Wise Sales', style: TextStyle(
                        fontWeight: FontWeight.bold,
                       fontSize: MediaQuery.of(context).textScaleFactor*18,
                      ),),
                      SizedBox(
                        height: 10.0,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          child: StreamBuilder(
                              stream: firebaseFirestore.collection('item_report').where('date',isGreaterThanOrEqualTo: dateNowDash).orderBy('date',descending: true) .snapshots(),
                              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){

                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                categoryListDash=[];
                                categoryCountListDash=[];
                                categoryValueListDash=[];
                                here: for(int i=0;i<snapshot.data.size;i++){
                                  print('snapshot.data.size ${snapshot.data.size}');
                                  if(i==0){
                                    categoryListDash.add(snapshot.data.docs[i]['category']);
                                    categoryCountListDash.add(double.parse(snapshot.data.docs[i]['qty']));
                                    categoryValueListDash.add(double.parse(snapshot.data.docs[i]['lineTotal']));
                                  }
                                  else{
                                    for(int j=0;j<categoryListDash.length;j++){
                                      if(categoryListDash[j]==snapshot.data.docs[i]['category']){
                                        categoryCountListDash[j]=double.parse(snapshot.data.docs[i]['qty'])+categoryCountListDash[j];
                                        categoryValueListDash[j]=double.parse(snapshot.data.docs[i]['lineTotal'])+categoryValueListDash[j];
                                        continue here;
                                      }
                                    }
                                    categoryListDash.add(snapshot.data.docs[i]['category']);
                                    categoryCountListDash.add(double.parse(snapshot.data.docs[i]['qty']));
                                    categoryValueListDash.add(double.parse(snapshot.data.docs[i]['lineTotal']));
                                  }
                                }
                                print('categoryListDash $categoryListDash');
                                return FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: DataTable(columns:
                                  [DataColumn(label: Text('Category', style:kStyle)),
                                    DataColumn(label: Text('Quantity', style: kStyle)),
                                    DataColumn(label: Text('Value', style: kStyle)),
                                  ],
                                      rows:List.generate(categoryListDash.length, (index) => DataRow(cells: [
                                        DataCell(Text(categoryListDash[index],style: kStyle,)),
                                        DataCell(Text(categoryCountListDash[index].toString(),style: kStyle,)),
                                        DataCell(Text(categoryValueListDash[index].toString(),style: kStyle,)),
                                      ]))
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),

                ) ),
            SizedBox(
                width: MediaQuery.of(context).size.width/1.1,
                height: MediaQuery.of(context).size.height/2,
                child: Card(
                  elevation: 12.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Text('Item Wise Sales', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).textScaleFactor*18,
                      ),),
                      SizedBox(
                        height: 10.0,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          child: StreamBuilder(
                              stream: firebaseFirestore.collection('item_report').where('date',isGreaterThanOrEqualTo: dateNowDash).orderBy('date',descending: true) .snapshots(),
                              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){

                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                itemListDash=[];
                                itemCountListDash=[];
                                itemValueListDash=[];
                                here: for(int i=0;i<snapshot.data.size;i++){
                                  if(i==0){
                                    itemListDash.add(snapshot.data.docs[i]['name']);
                                    itemCountListDash.add(double.parse(snapshot.data.docs[i]['qty']));
                                    itemValueListDash.add(double.parse(snapshot.data.docs[i]['lineTotal']));
                                  }
                                  else{
                                    for(int j=0;j<itemListDash.length;j++){
                                      if(itemListDash[j]==snapshot.data.docs[i]['name']){
                                        itemCountListDash[j]=double.parse(snapshot.data.docs[i]['qty'])+itemCountListDash[j];
                                        itemValueListDash[j]=double.parse(snapshot.data.docs[i]['lineTotal'])+itemValueListDash[j];
                                        continue here;
                                      }
                                    }
                                    itemListDash.add(snapshot.data.docs[i]['name']);
                                    itemCountListDash.add(double.parse(snapshot.data.docs[i]['qty']));
                                    itemValueListDash.add(double.parse(snapshot.data.docs[i]['lineTotal']));
                                  }
                                }
                                return FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: DataTable(columns:
                                  [
                                    DataColumn(label: Text('Item', style: kStyle)),
                                    DataColumn(label: Text('Qty', style: kStyle)),
                                    DataColumn(label: Text('Value', style: kStyle)),
                                  ],
                                      rows:List.generate(itemListDash.length, (index) => DataRow(cells: [
                                        DataCell(Text(itemListDash[index],style: kStyle,)),
                                        DataCell(Text(itemCountListDash[index].toString(),style: kStyle,)),
                                        DataCell(Text(itemValueListDash[index].toString(),style: kStyle,)),
                                      ]))
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                ),),
            SizedBox(
                width: MediaQuery.of(context).size.width/1.1,
                height: MediaQuery.of(context).size.height/2,
                child: Card(
                  elevation: 12.0,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Text('Invoice Wise Sales', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).textScaleFactor*18,
                      ),),
                      SizedBox(
                        height: 10.0,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          child: StreamBuilder(
                              stream: firebaseFirestore.collection('invoice_data').where('date',isGreaterThanOrEqualTo: dateNowDash).orderBy('date',descending: true) .snapshots(),
                              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){

                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: DataTable(columns:
                                  [DataColumn(label: Text('InvoiceNo', style:kStyle)),
                                    DataColumn(label: Text('Customer', style: kStyle)),
                                    DataColumn(label: Text('Total', style: kStyle)),
                                  ],
                                      rows: snapshot.data.docs.map((document) {
                                        return DataRow(cells: [
                                          DataCell(TextButton(
                                              onPressed: () async {
                                                DocumentSnapshot snapshot =
                                                await firebaseFirestore
                                                    .collection('invoice_data')
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
                                          DataCell(Text(document['customer'],style: kStyle)),
                                          DataCell(Text(document['total'],style: kStyle)),
                                        ]);
                                      }).toList()),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),

                ) ),
          ],
        ),
      ),
    ));
  }
}
