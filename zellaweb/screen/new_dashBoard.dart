import 'dart:convert';
import 'dart:html' as html;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/components/drawer.dart';
import 'package:restaurant_app/components/drawer2.dart';
import 'package:restaurant_app/components/firebase_con.dart';
import 'package:restaurant_app/constants.dart';
import 'package:restaurant_app/screen/pos_screen.dart';
import 'package:restaurant_app/screen/purchase_report.dart';
import 'package:restaurant_app/screen/receipt_report.dart';
import 'package:restaurant_app/screen/splash_screen.dart';
import 'package:restaurant_app/screen/stream_reports.dart';
import 'expense_report.dart';
import 'login_page.dart';
List<String> newDashMenu=['Sales','Expense','Receipts','Payments','Purchase','Cash In Hand'];
bool showCash=false;
RxBool showCashRefresh=false.obs;
double cashAvailableDash=0;
double openingDash=0;
double cashSalesDash=0;
double cashPurchaseDash=0;
double cashSalesReturnDash=0;
double cashPurchaseReturnDash=0;
double expenseDash=0;
double receiptAmtDash=0;
double paymentAmtDash=0;
class NewDash extends StatefulWidget {
  static const String id='new_dash';
  @override
  _NewDashState createState() => _NewDashState();
}

class _NewDashState extends State<NewDash> {
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
        isGreaterThanOrEqualTo: tillCloseTime).where('payment',isEqualTo:'Cash').orderBy('date',descending: true)
        .get();
    doc8= await firebaseFirestore
        .collection('purchase_return')
        .where('user', isEqualTo: currentUser)
        .where('date',
        isGreaterThanOrEqualTo: tillCloseTime).where('payment',isEqualTo:'Cash').orderBy('date',descending: true)
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
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) =>  AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        title: new Text('Are you sure?'),
        content: new Text('Do you want to Log Out'),
        actions: <Widget>[
          new TextButton(
            onPressed: () =>Navigator.pop(context),
            child: Container(
                padding: EdgeInsets.all(6.0),
                width: 100,
                decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(10.0),
                    border: Border.all(color: kBlack)
                ),
                child: Center(
                  child: Text("No",style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),),
                )),
          ),
          SizedBox(height: 16),

          new TextButton(
            onPressed: ()  {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SplashScreen()),
                    (Route<dynamic> route) => false,
              );
            } ,
            child: Container(
                padding: EdgeInsets.all(6.0),
                width: 100,
                decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(10.0),
                    border: Border.all(color: kBlack)
                ),
                child: Center(child: Text("Yes",style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                )))),
          ),
        ],
      ),
    ) ??
        false;
  }
@override
  void initState() {
    // TODO: implement initState
   showCash=false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Color getColor(int index){
      if(index==0)
        return kDash0;
      else if(index==1)
        return kDash1;
      else if(index==2)
        return kDash2;
      else if(index==3)
        return kDash3;
      else if(index==4)
        return kDash4;
      else if(index==5)
        return kDash5;
      return Color(0xffffff);
    }
    TextStyle kStyle=TextStyle(
      color: kAppBarItems,
      fontSize: MediaQuery.of(context).textScaleFactor*18,
    );
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          drawer: MyDrawer(),
          endDrawer: Drawer2(),
          body: Container(
           // color: kGreenColor,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Container(
                                    width: 180,
                                    height: 80,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                'images/dot_logo.png'
                                            )
                                        )
                                    ),
                                  ),
                                ),
                    Padding(
                                  padding: const EdgeInsets.all(30),
                                  child: Row(
                                    children: [
                                      IconButton(icon: FaIcon(FontAwesomeIcons.sync),color: kAppBarItems, onPressed: () async {
                                      QuerySnapshot doc2=await firebaseFirestore.collection('invoice_data').where('date',isGreaterThanOrEqualTo: dateNowDash)
                                          .orderBy('date',descending: true) .get();
                                      String text='';
                                      print("Here"+dateNowDash.toString()+"SIze :"+doc2.size.toString());
                                      for(int i=0;i<doc2.size;i++){
                                        Map map2=doc2.docs[i].data();
                                        if(map2.length==16)
                                        {
                                          print("Here 1"+map2.length.toString());
                                          if(!doc2.docs[i]['textFile']){
                                            print("Here 2");
                                            double tempTax=0;
                                            text+='${doc2.docs[i]['orderNo']},${doc2.docs[i]['customer']},${convertEpox(doc2.docs[i]['date']).substring(0,16)},';
                                            for(int k=0;k<doc2.docs[i]['cartList'].length;k++){
                                              double tempT=double.parse(doc2.docs[i]['cartList'][k]['qty'])*double.parse(doc2.docs[i]['cartList'][k]['price']);
                                              tempTax+=double.parse(doc2.docs[i]['cartList'][k]['taxAmt'].toString());
                                              text+='#${doc2.docs[i]['cartList'][k]['name']}:${doc2.docs[i]['cartList'][k]['qty']}:${doc2.docs[i]['cartList'][k]['price']}:${tempT.toStringAsFixed(decimals)}';
                                            }
                                            text+=',${tempTax.toStringAsFixed(decimals)},${doc2.docs[i]['total']}';
                                            firebaseFirestore.collection('invoice_data').doc(doc2.docs[i]['orderNo']).update(
                                                {
                                                  "textFile":true,
                                                });
                                            // prepare
                                          text+='\n';
                                          }
                                        }
                                      }
                                      if(text.length>0){
                                        final bytes99= utf8.encode(text);
                                        final blob = html.Blob([bytes99]);
                                        final url = html.Url.createObjectUrlFromBlob(blob);
                                        final anchor = html.document.createElement('a') as html.AnchorElement
                                          ..href = url
                                          ..style.display = 'none'
                                          ..download = 'dot.txt';
                                         // ..download = 'sync_data#${dateNow()}.txt';
                                        html.document.body.children.add(anchor);

// download
                                        anchor.click();

// cleanup
                                        html.document.body.children.remove(anchor);
                                        html.Url.revokeObjectUrl(url);
                                      }
                                      }),
                                      SizedBox(width: 10,),
                                      IconButton(icon: FaIcon(FontAwesomeIcons.signOutAlt),color: kAppBarItems, onPressed: ()  {
                                        return showDialog(
                                          context: context,
                                          builder: (context) =>  AlertDialog(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                            title: new Text('Are you sure?'),
                                            content: new Text('Do you want to Log Out'),
                                            actions: <Widget>[
                                              new TextButton(
                                                onPressed: () =>Navigator.pop(context),
                                                child: Container(
                                                    padding: EdgeInsets.all(6.0),
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(10.0),
                                                        border: Border.all(color: kBlack)
                                                    ),
                                                    child: Center(
                                                      child: Text("No",style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.bold
                                                      ),),
                                                    )),
                                              ),
                                              SizedBox(height: 16),

                                              new TextButton(
                                                onPressed: ()  {
                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => SplashScreen()),
                                                        (Route<dynamic> route) => false,
                                                  );
                                                } ,
                                                child: Container(
                                                    padding: EdgeInsets.all(6.0),
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(10.0),
                                                        border: Border.all(color: kBlack)
                                                    ),
                                                    child: Center(child: Text("Yes",style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold
                                                    )))),
                                              ),
                                            ],
                                          ),
                                        ) ??
                                            false;
                                      }),
                                      IconButton(icon: FaIcon(FontAwesomeIcons.home),color: kAppBarItems, onPressed: () async {
                                         await displayAllProducts('Salable');
                                        Navigator.pushNamed(context, PosScreen.id);
                                      }),
                                    ],
                                  ),
                                )
                  ],
                ),
                Container(
                            margin: EdgeInsets.all(6.0),
                            height: MediaQuery.of(context).size.height/6,
                            child: GridView.builder(
                                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                  mainAxisSpacing: 10.0,
                                  crossAxisSpacing: 10.0,
                                  maxCrossAxisExtent: MediaQuery.of(context).size.width/6,
                                  mainAxisExtent: MediaQuery.of(context).size.height/7,
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
                                          color: kItemContainer,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        );
                                      }
                                      double sum = 0.0;
                                      if(index!=5){
                                        var ds = snapshot.data.docs;
                                        for(int i=0; i<ds.length;i++){
                                          if(index==0){
                                            if(ds[i]['total'].contains('*')){
                                              List tempDTotal=ds[i]['total'].split('*');
                                             sum+=double.parse(tempDTotal[0].toString().trim());
                                             sum+=double.parse(tempDTotal[1].toString().trim());
                                            }
                                            else{
                                              sum+=double.parse(ds[i]['total']);
                                            }
                                          }
                                          else{
                                            sum+=double.parse(ds[i]['total']);
                                          }
                                        }
                                      }

                                      return Card(
                                        color: getColor(index),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(color: kItemContainer, width: 3),
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        //elevation: 12.0,
                                        child: Center(child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            index==5?Visibility(
                                              visible: showCash,
                                              child: AutoSizeText(cashAvailableDash.ceil().toString(),
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize: 30.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: kItemContainer
                                                ),
                                              ),
                                              replacement: IconButton(onPressed: () async {
                                                print('clickeddd');
                                            await getTillClose();
                                              },
                                              icon: Icon(Icons.refresh,color: kItemContainer,size: 30,),
                                              ),
                                            ):
                                            GestureDetector(
                                              onTap: () async {
                                                if (index == 0) {
                                                  await read('deliverBoy_data');
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => StreamReports(transactionType: 'invoice_data')));
                                              } else if(index==1)
                                                  Navigator.pushNamed(context, ExpenseReport.id);
                                                else if(index==2)
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ReceiptReport(type: 'RECEIPT')));
                                                else if(index==3)
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ReceiptReport(type: 'PAYMENT')));
                                                else if(index==4)
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PurchaseReport(transactionType: 'purchase')));
                                              },
                                              child: Text( sum.ceil().toString(),
                                                style: TextStyle(
                                                  fontSize: 30.0,
                                                  color: kItemContainer,
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
                                                      color: kItemContainer,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: MediaQuery.of(context).textScaleFactor*8,
                                                  ),
                                                ),
                                                Visibility(
                                                  maintainSize: false,
                                                    visible: showCash,
                                                    child: IconButton(
                                                      padding: EdgeInsets.zero,
                                                      onPressed: ()async{
                                                        if(!showCashRefresh.value){
                                                          print('inside if ${showCashRefresh.value}');
                                                          showCashRefresh.value=true;
                                                          await getTillClose();
                                                          showCashRefresh.value=false;
                                                        }
                                                        else{
                                                          print('inside else ${showCashRefresh.value}');
                                                        }

                                                },
                                                icon: Icon(Icons.refresh),color: kItemContainer,
                                                ))
                                              ],),
                                            ):AutoSizeText(newDashMenu[index],
                                              maxLines: 1,
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                      color: kItemContainer,
                                                fontWeight: FontWeight.bold,
                                                fontSize: MediaQuery.of(context).textScaleFactor*8,
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
                Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                    child: Card(
                                      elevation: 10,
                                      color: kItemContainer,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(color: kItemContainer, width: 3),
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Text('Category Wise Sales', style: TextStyle(
                                            color: kAppBarItems,
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context).textScaleFactor*20,
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
                                                            DataCell(Text(categoryValueListDash[index].toStringAsFixed(decimals),style: kStyle,)),
                                                          ]))
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ),
                                        ],
                                      ),

                                    ) ),
                                Expanded(
                                    child: Card(
                                      elevation: 10,
                                      color: kItemContainer,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(color: kItemContainer, width: 3),
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      child: Column(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Text('Item Wise Sales', style: TextStyle(
                                            color: kAppBarItems,
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context).textScaleFactor*20,
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
                                                            DataCell(SizedBox(width:200,child: Text(itemListDash[index].replaceAll('#', '/'),style: kStyle,))),
                                                            DataCell(Text(itemCountListDash[index].toString(),style: kStyle,)),
                                                            DataCell(Text(itemValueListDash[index].toStringAsFixed(decimals),style: kStyle,)),
                                                          ]))
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ),
                                        ],
                                      ),

                                    ) ),
                                Expanded(
                                    child: Card(
                                      elevation: 10,
                                      color: kItemContainer,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(color: kItemContainer, width: 3),
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      child: Column(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Text('Invoice Wise Sales', style: TextStyle(
                                            color: kAppBarItems,
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          ),),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              physics: ScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              child: StreamBuilder(
                                                  stream: firebaseFirestore.collection('invoice_data').where('date',isGreaterThanOrEqualTo: dateNowDash).where('user',isEqualTo: "$currentUser").orderBy('date',descending: true) .snapshots(),
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
                                                                          shape: RoundedRectangleBorder(
                                                                            side: BorderSide(color: kItemContainer, width: 3),
                                                                            borderRadius: BorderRadius.circular(15.0),
                                                                          ),
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
                                                              DataCell(Text(document['total'].contains('*')?document['total'].replaceAll('*','/'):document['total'],style: kStyle)),
                                                            ]);
                                                          }).toList()),
                                                    );
                                                  }),
                                            ),
                                          ),
                                        ],
                                      ),

                                    ) ),
                              ]),) ,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String convertEpox(int val){
  DateTime date = new DateTime.fromMillisecondsSinceEpoch(val);
  var format = new DateFormat("d/m/y");
  return date.toString();
}