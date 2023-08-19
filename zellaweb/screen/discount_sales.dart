import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/components/firebase_con.dart';
import '../constants.dart';
import 'login_page.dart';
class DiscountSales extends StatefulWidget {
static const String id='discount_sales';
  @override
  State<DiscountSales> createState() => _DiscountSalesState();
}

class _DiscountSalesState extends State<DiscountSales> {
  int orderIndex=0;
  RxString selectedUser=currentUser.obs;
  DateTime  fromDate=beginDate;
  DateTime toDate =DateTime.now();
  int toDate1=DateTime.now().millisecondsSinceEpoch;
  int fromDate1=dateNowDash;
  var datePicked;
  @override
  Widget build(BuildContext context) {
    double currentWidth=MediaQuery.of(context).size.width;
    TextStyle kStyle=TextStyle(
      fontSize: MediaQuery.of(context).textScaleFactor*20,
    );
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text('discount sales',style: TextStyle(
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

                        Text(fromDate!=null?fromDate.toString().substring(0,16):"",style: TextStyle(color: kGreenColor),)
                      ],
                    ),
                  )),
              SizedBox(width:20),
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
                      Text(toDate.toString().substring(0,16),style: TextStyle(color: kGreenColor),),
                    ],
                  ),
                ),
              ),
                SizedBox(width:20),
                  Container(
                    padding: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: kAppBarItems,
                      style: BorderStyle.solid,
                      width: 1.5),
                ),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: Obx(()=>DropdownButton(
                      isDense: true,
                      icon:Icon(Icons.account_circle_rounded),
                      underline: SizedBox(),
                      value: selectedUser.value, // Not necessary for Option 1
                      items: tempUserList.map((String val) {
                        return DropdownMenuItem(
                          child: new Text(val.toString(),
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).textScaleFactor*16,
                                color: kGreenColor
                            ),
                          ),
                          value: val,
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        selectedUser.value = newValue;
                      },
                    ),)
                  ),
                ),
              ),
            ],):
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(currentTerminal=='Owner')
                  Obx(()=> DropdownButton(
                    icon:Icon(Icons.account_circle_rounded) ,
                    underline: SizedBox(),
                    value: selectedUser.value, // Not necessary for Option 1
                    items: tempUserList.map((String val) {
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
                      selectedUser.value = newValue;
                    },
                  )),

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
              child: Obx(()=>StreamBuilder(
                  stream:  selectedUser.value=='*'?firebaseFirestore.collection('invoice_data').where('date',isGreaterThanOrEqualTo: fromDate1)
                      .where('date',isLessThanOrEqualTo: toDate1)
                      .orderBy('date',descending: true) .snapshots():firebaseFirestore.collection('invoice_data').where('date',isGreaterThanOrEqualTo: fromDate1)
                      .where('date',isLessThanOrEqualTo: toDate1)
                      .where('user',isEqualTo: selectedUser.value)
                      .orderBy('date',descending: true) .snapshots(),
                  builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    List<DocumentSnapshot> documentSnapshot = [];
                    for(int i=0;i<snapshot.data.docs.length;i++){
                      if(double.parse(snapshot.data.docs[i]['discount'])>0){
                        documentSnapshot.add(snapshot.data.docs[i]);
                      }
                    }
                    return currentWidth>600?FittedBox(
                      fit: BoxFit.fitWidth,
                      child: DataTable(columns:
                      [
                        DataColumn(label: Text('Date', style: kStyle)),
                        DataColumn(label: Text('Customer', style: kStyle)),
                        DataColumn(label: Text('Total', style: kStyle)),
                        DataColumn(label: Text('Discount', style: kStyle)),
                        DataColumn(label: Text('InvoiceNo', style:kStyle)),
                        DataColumn(label: Text('OrderNo', style:kStyle)),
                        DataColumn(label: Text('CreatedBy', style:kStyle)),
                        DataColumn(label: Text('Payment', style: kStyle)),
                        DataColumn(label: Text('Delivery', style:kStyle)),
                        DataColumn(label: Text('User', style: kStyle)),
                      ],
                          rows: documentSnapshot.map((document) {
                            return DataRow(cells: [
                              DataCell(Text(convertEpox(document['date']).substring(0,16),style: kStyle)),
                              DataCell(Text(document['customer'],style: kStyle)),
                              DataCell(Text(document['total'],style: kStyle)),
                              DataCell(Text(document['discount'],style: kStyle)),
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
                              DataCell(Text(document['kotNumber'],style: kStyle)),
                              DataCell(Text(document['createdBy'],style: kStyle)),
                              DataCell(Text(document['payment'],style: kStyle)),
                              DataCell(Text(document['deliveryType'],style: kStyle)),
                              DataCell(Text(document['user'],style: kStyle)),
                            ]);
                          }).toList()),
                    ):
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(columns:
                      [
                        DataColumn(label: Text('Date', style: kStyle)),
                        DataColumn(label: Text('Customer', style: kStyle)),
                        DataColumn(label: Text('Total', style: kStyle)),
                        DataColumn(label: Text('Discount', style: kStyle)),
                        DataColumn(label: Text('InvoiceNo', style:kStyle)),
                        DataColumn(label: Text('OrderNo', style:kStyle)),
                        DataColumn(label: Text('CreatedBy', style:kStyle)),
                        DataColumn(label: Text('Payment', style: kStyle)),
                        DataColumn(label: Text('Delivery', style:kStyle)),
                        DataColumn(label: Text('User', style: kStyle)),
                      ],
                          rows: snapshot.data.docs.map((document) {
                            return DataRow(cells: [
                              DataCell(Text(convertEpox(document['date']).substring(0,16),style: kStyle)),
                              DataCell(Text(document['customer'],style: kStyle)),
                              DataCell(Text(document['total'],style: kStyle)),
                              DataCell(Text(document['discount'],style: kStyle)),
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
                                        scrollDirection: Axis.horizontal,
                                        child: Dialog(
                                          child: DataTable(
                                            columns: [  DataColumn(label: Text('Item', style: kStyle,)),
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
                              DataCell(Text(document['kotNumber'],style: kStyle)),
                              DataCell(Text(document['createdBy'],style: kStyle)),
                              DataCell(Text(document['payment'],style: kStyle)),
                              DataCell(Text(document['deliveryType'],style: kStyle)),
                              DataCell(Text(document['user'],style: kStyle)),
                            ]);
                          }).toList()),
                    );
                  })),
            ),
          ),
        ],
      ),
    ));
  }
}
String convertEpox(int val){
  DateTime date = new DateTime.fromMillisecondsSinceEpoch(val);
  var format = new DateFormat("d/m/y");
  // String time=date.toString().substring(11)
  print(' date $date');
  var dateString = format.format(date);
  print(' dateString $dateString');
  return date.toString();
}