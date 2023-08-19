import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/components/firebase_con.dart';
import 'package:restaurant_app/constants.dart';
import 'package:restaurant_app/screen/administration_screen.dart';
import 'package:restaurant_app/screen/all_reports_screen.dart';
import 'package:restaurant_app/screen/expense_head.dart';
import 'package:restaurant_app/screen/expense_transaction.dart';
import 'package:restaurant_app/screen/sequence_manager.dart';
import 'pos_screen.dart';
import 'login_page.dart';
import 'till_close.dart';
import 'purchase_screen.dart';
import 'receipt_payment_screen.dart';
import 'sales_return.dart';
import 'purchase_return.dart';
import 'package:restaurant_app/components/all_file.dart';
import 'organisation_screen.dart';
import 'dash_board.dart';

import 'kabooz_printer.dart';
import 'receipt_payment_screen.dart';
class MenuScreen extends StatefulWidget {
  static const String id='menu';
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to Log Out'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
            ),
            child: Text("YES"),
          ),
        ],
      ),
    ) ??
        false;
  }
  void runAll()async{
    // await getData('vendor_data');
    // await getData('sequence_manager');
    // await getData('customer_data');
    // await getData('uom_data');
    // await getData('tax_data');
    // await getData('bluetooth_data');


  }
  String dateNow(){
    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    return timestamp;
  }
  //List menuList=['Sales','Purchase','Sales Return','Purchase Return','Expense','Till Close','Receipt/Payment','Administration','Reports','DashBoard'];
  List menuList=['Sales','Purchase','Sales Return','Purchase Return','Expense','Reports','DashBoard'];
  @override
  void initState() {
    // TODO: implement initState
    read('tax_data');
    read('uom_data');
    read('vendor_data');
    read('customer_data');
    read('expense_head');
    getSequenceData();
    //runAll();
    super.initState();



    // getReceiptInvoiceNo();
    // getPaymentInvoiceNo();
    // allFile.readFile('openBalance');
    // allFile.readFile('vendor');
    // allFile.readFile('sequence_data');
    // allFile.readFile('uom');
    // allFile.readFile('customer_report');
    // allFile.readFile('vendor_report');
  }
  @override
  Widget build(BuildContext context) {
    double textSize=MediaQuery.of(context).textScaleFactor;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text('POSIMATE',style: TextStyle(
              fontFamily: 'BebasNeue',
              letterSpacing: 2.0
          ),),
          backgroundColor: kGreenColor,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                icon: Icon(Icons.logout), onPressed: (){
              _onBackPressed();
            }),
          ],
        ),

        body: Center(
          child: Container(
            margin: EdgeInsets.only(top:MediaQuery.of(context).size.height/4),
            width: MediaQuery.of(context).size.width/2,
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  crossAxisCount: 5,
                  //mainAxisExtent: 10.0,
                ),
                scrollDirection: Axis.vertical,
                itemCount: menuList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: ()async{
                      if(index==0) {
                        try{
                          await displayProducts(productCategoryF[0]);
                        }
                        catch(e){

                        }

                        Navigator.pushNamed(context, PosScreen.id);
                      }
                      else if(index==1) {
                        await displayProducts(productCategoryF[0]);
                        Navigator.pushNamed(context, PurchaseScreen.id);
                      }
                      else if(index==2) {
                        await displayProducts(productCategoryF[0]);
                        Navigator.pushNamed(context, SalesReturn.id);
                      }
                      else if(index==3) {
                        await displayProducts(productCategoryF[0]);
                        Navigator.pushNamed(context, PurchaseReturn.id);
                      }
                      else if(index==4)
                      {
                        //await getData('expense_head');
                        Navigator.pushNamed(context, ExpenseTransaction.id);}
                      // else if(index==5)
                      //   Navigator.pushNamed(context, TillClose.id);
                      // else if(index==6)
                      //   Navigator.pushNamed(context, ReceiptPayment.id);
                      // else if(index==5)
                      //   Navigator.pushNamed(context, AdministrationScreen.id);
                      else if(index==5)
                        Navigator.pushNamed(context, AllReports.id);
                      else if(index==6)
                      {
                        try{
                          await displayItems(productCategoryF[0]);
                          await getTotalSales('invoice_data', dateNow());
                          await getTotalSales('purchase_data', dateNow());
                          await getTotalSales('expense_transaction', dateNow());
                        }
                        catch(e){

                        }
                        //Navigator.pushNamed(context, DashBoardPage.id);
                      }

                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: kGreenColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.all(10.0),
                      child: Center(child: AutoSizeText(menuList[index],
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: textSize*18,
                          color: kItemContainer,
                        ),
                      )
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }


  Future getReceiptInvoiceNo()async {
    String tempLastInvoiceNo;
    List invoiceDataList1=[];
    List invoiceDataList=await getData('receipt');
    if(invoiceDataList.isNotEmpty){
      for(int i=0;i<invoiceDataList.length;i++){
        invoiceDataList1.add(invoiceDataList[i].toString().substring(1,invoiceDataList[i].toString().length-1));
      }
      int end=invoiceDataList1.length-1;
      List eachOrder=invoiceDataList1[end].toString().split(',');
      tempLastInvoiceNo=eachOrder[1].toString().trim();
      receiptOrderNo = int.parse(tempLastInvoiceNo.trim().replaceAll(RegExp('[^0-9]'), ''))+1;
    }
    else{
      receiptOrderNo=int.parse(receiptFrom);
    }
    print('receiptOrderNo $receiptOrderNo');
  }
  Future getPaymentInvoiceNo()async {
    String tempLastInvoiceNo;
    List invoiceDataList1=[];
    List invoiceDataList=await getData('payment');
    if(invoiceDataList.isNotEmpty){
      for(int i=0;i<invoiceDataList.length;i++){
        invoiceDataList1.add(invoiceDataList[i].toString().substring(1,invoiceDataList[i].toString().length-1));
      }
      int end=invoiceDataList1.length-1;
      List eachOrder=invoiceDataList1[end].toString().split(',');
      tempLastInvoiceNo=eachOrder[1].toString().trim();
      paymentOrderNo = int.parse(tempLastInvoiceNo.trim().replaceAll(RegExp('[^0-9]'), ''))+1;
    }
    else{
      paymentOrderNo=int.parse(paymentFrom);
    }
    print('paymentOrderNo $paymentOrderNo');
  }
}
Future<int> getSalesInvoiceNo()async {
  await getSequenceData();
  print('inside getSalesInvoiceNo');
  try{
    String tempLastInvoiceNo=await getInvNo('invoice_data');
    print('tempLastInvoiceNo $tempLastInvoiceNo');
    salesOrderNo= int.parse(tempLastInvoiceNo.trim().replaceAll(RegExp('[^0-9]'), ''))+1;
    print('orderNo $salesOrderNo');
  }
  catch(e){
    salesOrderNo=1;
  }
  return salesOrderNo;
}
Future<int> getSavedOrderInvoiceNo()async {
  int orderNo;
  print('inside getSavedOrderInvoiceNo');
  try{
    String tempLastInvoiceNo=await getInvNo('saved_order');
    print('tempLastInvoiceNo $tempLastInvoiceNo');
    orderNo= int.parse(tempLastInvoiceNo.trim().replaceAll(RegExp('[^0-9]'), ''))+1;
    print('orderNo $orderNo');
  }
  catch(e){
    orderNo=1;
  }
  return orderNo;
}
Future<int> getWaiterInvoiceNo()async {
  int orderNo;
  print('inside getWaiterInvoiceNo');
  try{
    String tempLastInvoiceNo=await getInvNo('invoice_list');
    print('tempLastInvoiceNo $tempLastInvoiceNo');
    orderNo= int.parse(tempLastInvoiceNo.trim().replaceAll(RegExp('[^0-9]'), ''))+1;
    print('orderNo $orderNo');
  }
  catch(e){
    orderNo=1;
  }
  return orderNo;
}
Future<int> getPurchaseInvoiceNo()async {
  await getSequenceData();
  print('inside getPurchaseInvoiceNo');
  try{
    String tempLastInvoiceNo=await getInvNo('purchase_data');
    print('tempLastInvoiceNo $tempLastInvoiceNo');
    purchaseOrderNo= int.parse(tempLastInvoiceNo.trim().replaceAll(RegExp('[^0-9]'), ''))+1;
    print('orderNo $purchaseOrderNo');
  }
  catch(e){
    purchaseOrderNo=1;
  }
  return purchaseOrderNo;
}
Future<int> getExpenseInvoiceNo()async {
  await getSequenceData();
  print('inside getExpenseInvoiceNo');
  try{
    String tempLastInvoiceNo=await getInvNo('expense_transaction');
    print('tempLastInvoiceNo $tempLastInvoiceNo');
    expenseInvNo= int.parse(tempLastInvoiceNo.trim().replaceAll(RegExp('[^0-9]'), ''))+1;
    print('orderNo $expenseInvNo');
  }
  catch(e){
    expenseInvNo=1;
  }
  return expenseInvNo;
}
Future getSalesReturnInvoiceNo()async {
  await getSequenceData();
  print('inside getSalesReturnInvoiceNo');
  try{
    String tempLastInvoiceNo=await getInvNo('sales_return');
    print('tempLastInvoiceNo $tempLastInvoiceNo');
    salesReturnOrderNo= int.parse(tempLastInvoiceNo.trim().replaceAll(RegExp('[^0-9]'), ''))+1;
    print('orderNo $salesReturnOrderNo');
  }
  catch(e){
    salesReturnOrderNo=1;
  }
  return salesReturnOrderNo;
}
Future getPurchaseReturnInvoiceNo()async {
  await getSequenceData();
  print('inside getPurchaseReturnInvoiceNo');
  try{
    String tempLastInvoiceNo=await getInvNo('purchase_return');
    print('tempLastInvoiceNo $tempLastInvoiceNo');
    purchaseReturnOrderNo= int.parse(tempLastInvoiceNo.trim().replaceAll(RegExp('[^0-9]'), ''))+1;
    print('orderNo $purchaseReturnOrderNo');
  }
  catch(e){
    purchaseReturnOrderNo=1;
  }
  return purchaseReturnOrderNo;
}