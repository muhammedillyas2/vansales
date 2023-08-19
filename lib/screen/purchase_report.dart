import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/components/firebase_con.dart';
// import 'package:restaurant_app/screen/purchase_return.dart' as pr;
// import 'sales_return.dart' as sr;

import '../constants.dart';
import 'login_page.dart';
String selectedUser=currentUser;
List<String> displayList=[];
DateTime  fromDate;
DateTime toDate =DateTime.now();
String dateFrom='',dateTo='';
int toDate1=0;
int fromDate1=0;
var datePicked;
class PurchaseReport extends StatefulWidget {
  final String transactionType;
  static const String id='purchase_report';

  const PurchaseReport({Key key, this.transactionType}) : super(key: key);

  @override
  _PurchaseReportState createState() => _PurchaseReportState(transactionType);
}

class _PurchaseReportState extends State<PurchaseReport> {
  final String transactionType;
  int orderIndex=0;
  String title='';
  _PurchaseReportState(this.transactionType);
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
        title: Text(transactionType=='purchase'?'PURCHASE REPORT':transactionType=='purchase_return'?'PURCHASE RETURN':'SALES RETURN',style: TextStyle(
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
                DropdownButton(
                  icon:Icon(Icons.account_circle_rounded) ,
                  underline: SizedBox(),
                  value: selectedUser, // Not necessary for Option 1
                  items: userList.map((String val) {
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
                      print('selectedUser $selectedUser');
                      selectedUser = newValue;
                    });
                  },
                ),
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
            ):
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton(
                  icon:Icon(Icons.account_circle_rounded) ,
                  underline: SizedBox(),
                  value: selectedUser, // Not necessary for Option 1
                  items: userList.map((String val) {
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
                      print('selectedUser $selectedUser');
                      selectedUser = newValue;
                    });
                  },
                ),
                // TextButton(
                //     onPressed: () async {
                //       datePicked = await showDatePicker(
                //         context: context,
                //         initialDate: new DateTime.now(),
                //         firstDate:
                //         new DateTime.now().subtract(new Duration(days: 300)),
                //         lastDate:
                //         new DateTime.now().add(new Duration(days: 300)),
                //       );
                //       var s = datePicked;
                //       String a=s.toString().substring(0,10);
                //       fromDate=DateTime.parse('$a 0$orgClosedHour:00:00');
                //       setState(() {
                //         fromDate1=fromDate.millisecondsSinceEpoch;
                //       });
                //     },
                //     child: Container(
                //       padding: EdgeInsets.all(8.0),
                //       decoration: BoxDecoration(
                //         // color: kCardColor,
                //         borderRadius: BorderRadius.circular(10.0),
                //       ),
                //
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                //         children: [
                //           Text(
                //             'From :',
                //             style: TextStyle(
                //                 letterSpacing: 1,
                //                 color: kGreenColor,
                //                 fontWeight: FontWeight.bold
                //             ),
                //           ),
                //
                //           Text(fromDate!=null?fromDate.toString():"",style: TextStyle(color: kGreenColor),)
                //         ],
                //       ),
                //     )),
                // TextButton(
                //   onPressed: () async {
                //     datePicked = await showDatePicker(
                //       context: context,
                //       initialDate: new DateTime.now(),
                //       firstDate:
                //       new DateTime.now().subtract(new Duration(days: 300)),
                //       lastDate: new DateTime.now().add(new Duration(days: 300)),
                //     );
                //     var s = datePicked;
                //     String a=s.toString().substring(0,10);
                //     toDate=DateTime.parse('$a 0$orgClosedHour:00:00');
                //     setState(() {
                //       toDate1=toDate.millisecondsSinceEpoch;
                //     });
                //   },
                //   child: Container(
                //     padding: EdgeInsets.all(8.0),
                //     decoration: BoxDecoration(
                //       //color: kCardColor,
                //       borderRadius: BorderRadius.circular(10.0),
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                //       children: [
                //         Text(
                //           'To :',
                //           style: TextStyle(
                //             letterSpacing: 1,
                //             color: kGreenColor,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //         Text(toDate.toString(),style: TextStyle(color: kGreenColor),),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: StreamBuilder(
                  stream: firebaseFirestore.collection('$transactionType').where('date',isGreaterThanOrEqualTo: fromDate1).where('date',isLessThanOrEqualTo: toDate1).where('user',isEqualTo: "$selectedUser").orderBy('date',descending: true) .snapshots(),
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
                        DataColumn(label: Text('Date', style: kStyle)),
                        DataColumn(label: Text(transactionType=='sales_return'?'Customer': transactionType=='sales_return'?'Customer' :'Vendor', style: kStyle)),
                        DataColumn(label: Text('Payment', style: kStyle)),
                        DataColumn(label: Text('Total', style: kStyle)),
                        DataColumn(label: Text('User', style: kStyle)),
                        if(orgInvoiceEdit=='true')
                        DataColumn(label: Text('Edit', style: kStyle)),
                      ],
                          rows: snapshot.data.docs.map((document) {
                            return DataRow(cells: [
                              DataCell(TextButton(
                                  onPressed: () async {
                                    DocumentSnapshot snapshot =
                                    await firebaseFirestore
                                        .collection('$transactionType')
                                        .doc(document['orderNo']
                                        .toString())
                                        .get();
                                    orderIndex =
                                        snapshot.get('cartList').length;
                                    showDialog(context: context, builder: (context)=>Center(
                                      child: SingleChildScrollView(
                                        child: Dialog(
                                          child: DataTable(
                                            columns: [
                                              DataColumn(label: Text('Ite',
                                              style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.02),
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
                                                [index]['name'].replaceAll('#', '/'),
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
                              DataCell(Text(convertEpox(document['date']).substring(0,16),style: kStyle)),
                              DataCell(Text(transactionType=='sales_return'?document['customer'] :document['vendor'],style: kStyle)),
                              DataCell(Text(document['payment'],style: kStyle)),
                              DataCell(Text(document['total'],style: kStyle)),
                              DataCell(Text(document['user'],style: kStyle)),
                              if(orgInvoiceEdit=='true')
                              DataCell(IconButton(onPressed: () async {
                                // bool isOnline = await hasNetwork();
                                // if(!isOnline){
                                //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Internet is not available')));
                                //   return;
                                // }
                                // if(transactionType=='purchase'){
                                //   invEdit.value=true;
                                //   invEditNumber.value=document['orderNo'];
                                //   List items=document['cartList'];
                                //   invEditCartList.value=RxList<String>([]);
                                //   purchaseCartController=[];
                                //   purchaseCartUomList=[];
                                //   purchaseCartTotalList=[];
                                //   purchaseTotal=0;
                                //   purchaseCartListText=[];
                                //   for(int i=0;i<items.length;i++)
                                //   {
                                //     setState((){
                                //       purchaseTotal+=double.parse(document['cartList'][i]['price']);
                                //       purchaseCartTotalList.add(double.parse(document['cartList'][i]['price']));
                                //       purchaseCartUomList.add(document['cartList'][i]['uom']);
                                //       purchaseCartController.add(TextEditingController(text: document['cartList'][i]['price']));
                                //       purchaseCartListText.add('${document['cartList'][i]['name']}:${document['cartList'][i]['uom']}:${document['cartList'][i]['price']}:${document['cartList'][i]['qty']}');
                                //     });
                                //     invEditCartList.value.add('${document['cartList'][i]['name']}:${document['cartList'][i]['uom']}:${document['cartList'][i]['price']}:${document['cartList'][i]['qty']}');
                                //   }
                                //   appbarVendorController.text=document['vendor']=='Standard'?'':document['vendor'];
                                //   invEditVendorName.value=selectedVendor=appbarVendorController.text;
                                //   invEditPaymentMethod.value=document['payment'];
                                //   invEditTotal.value=document['total'];
                                //   invDate.value=document['date'];
                                //   await displayAllProducts('Purchasable');
                                //   Navigator.pushReplacement(
                                //     context, MaterialPageRoute(builder: (context) => PurchaseScreen()),
                                //   );
                                // }

                                // else if(transactionType=='sales_return'){
                                //   sr.invEdit.value=true;
                                //   sr.invEditNumber.value=document['orderNo'];
                                //   List items=document['cartList'];
                                //   sr.invEditCartList.value=RxList<String>([]);
                                //   sr.cartController=[];
                                //   sr.salesReturnUomList=[];
                                //   sr.salesReturnTotalList=[];
                                //   sr.salesReturnTotal=0;
                                //   sr.cartListText=[];
                                //   for(int i=0;i<items.length;i++)
                                //   {
                                //     setState((){
                                //       sr.salesReturnTotal+=double.parse(document['cartList'][i]['price']);
                                //       sr.salesReturnTotalList.add(double.parse(document['cartList'][i]['price']));
                                //       sr.salesReturnUomList.add(document['cartList'][i]['uom']);
                                //       sr.cartController.add(TextEditingController(text: document['cartList'][i]['price']));
                                //       sr.cartListText.add('${document['cartList'][i]['name']}:${document['cartList'][i]['uom']}:${document['cartList'][i]['price']}:${document['cartList'][i]['qty']}');
                                //     });
                                //     sr.invEditCartList.value.add('${document['cartList'][i]['name']}:${document['cartList'][i]['uom']}:${document['cartList'][i]['price']}:${document['cartList'][i]['qty']}');
                                //   }
                                //   sr.appbarCustomerController.text=document['customer']=='Standard'?'':document['customer'];
                                //   sr.invEditCustomerName.value=selectedCustomer=sr.appbarCustomerController.text;
                                //
                                //   await displayAllProducts('Salable');
                                //   Navigator.pushReplacement(
                                //     context, MaterialPageRoute(builder: (context) => sr.SalesReturn()),
                                //   );
                                // }
                              },
                                icon: Icon(Icons.edit),
                                iconSize: 40,
                              )),
                            ]);
                          }).toList()),
                    ):
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(columns:
                      [DataColumn(label: Text('InvoiceNo', style:kStyle)),
                        DataColumn(label: Text('Date', style: kStyle)),
                        DataColumn(label: Text(transactionType=='sales_return'?'Customer': transactionType=='sales_return'?'Customer' :'Vendor', style: kStyle)),
                        DataColumn(label: Text('Payment', style: kStyle)),
                        DataColumn(label: Text('Total', style: kStyle)),
                        DataColumn(label: Text('User', style: kStyle)),
                      ],
                          rows: snapshot.data.docs.map((document) {
                            return DataRow(cells: [
                              DataCell(TextButton(
                                  onPressed: () async {
                                    DocumentSnapshot snapshot =
                                    await firebaseFirestore
                                        .collection('$transactionType')
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
                              DataCell(Text(convertEpox(document['date']).substring(0,16),style: kStyle)),
                              DataCell(Text(transactionType=='sales_return'?document['customer'] :document['vendor'],style: kStyle)),
                              DataCell(Text(document['payment'],style: kStyle)),
                              DataCell(Text(document['total'],style: kStyle)),
                              DataCell(Text(document['user'],style: kStyle)),
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
                  StreamBuilder(stream: firebaseFirestore.collection('$transactionType').where('date',isGreaterThan: fromDate1).where('date',isLessThan: toDate1).where('user',isEqualTo: "$selectedUser").orderBy('date',descending: true).snapshots(),
                      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                        if (!snapshot.hasData) {
                          return Text(
                            '0' ,style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                          );
                        }
                        var ds = snapshot.data.docs;
                        double sum = 0.0;
                        for(int i=0; i<ds.length;i++)
                          sum+=double.parse(ds[i]['total']);
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
    ));
  }
}
String convertEpox(int val){
  DateTime date = new DateTime.fromMillisecondsSinceEpoch(val);
  var format = new DateFormat("yMd");
  var dateString = format.format(date);
  return date.toString();
}