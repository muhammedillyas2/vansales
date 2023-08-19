import 'package:flutter/material.dart';
import 'package:restaurant_app/screen/discount_sales.dart';
import 'package:restaurant_app/screen/item_report.dart';
import 'firebase_con.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:restaurant_app/screen/expense_report.dart';
import 'package:restaurant_app/screen/login_page.dart';
import 'package:restaurant_app/screen/new_dashBoard.dart';
import 'package:restaurant_app/screen/owner_dash.dart';
import 'package:restaurant_app/screen/purchase_report.dart';
import 'package:restaurant_app/screen/receipt_report.dart';
import 'package:restaurant_app/screen/receivable_payable.dart';
import 'package:restaurant_app/screen/stockTransfer_report.dart';
import 'package:restaurant_app/screen/stock_report.dart';
import 'package:restaurant_app/screen/stream_reports.dart';
import 'package:restaurant_app/screen/stream_vat.dart';
import 'package:restaurant_app/screen/till_close.dart';
import 'package:restaurant_app/screen/till_report.dart';

import '../constants.dart';
List<String> reportList = [
  'Sales',
  'Purchase',
  'Sales Return',
  'Purchase Return',
  'Tax',
  'Stock',
  'Expense',
  'Till Close',
  'Receivable',
  'Payable',
  'Receipt',
  'Payment',
  'Stock Transfer',
  'Item Wise',
  'Discount Sales',
  'Dashboard',
];
class Drawer2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  Drawer(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Reports',textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).textScaleFactor*22,
                fontFamily: 'BebasNeue',
                letterSpacing: 2.0,
                color: kAppBarItems,
              ),),
          ),
          Expanded(
            child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3
            ),
                scrollDirection: Axis.vertical,
                itemCount: currentTerminal=='Owner'?reportList.length-1:reportList.length,
                itemBuilder: (context,index){
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: RawMaterialButton(
                 shape:RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(18.0),
                     side: BorderSide(color: kGreenColor)
                 ) ,
                  //fillColor: kGreenColor,
                  onPressed: () async {
                    if (index == 0) {
                      await read('deliverBoy_data');

                      WidgetsBinding.instance.addPostFrameCallback((_){

                        // Add Your Code here.
                        Navigator.push(context, MaterialPageRoute(builder: (context) => StreamReports(transactionType: 'invoice_data')));
                      });
                      } else if(index==1)
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PurchaseReport(transactionType: 'purchase')));
                else if(index==2)
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PurchaseReport(transactionType: 'sales_return')));
                else if(index==3)
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PurchaseReport(transactionType: 'purchase_return')));
                else if(index==4)
                      Navigator.pushNamed(context, StreamVat.id);
                else if(index==5)
                  Navigator.pushNamed(context, StockReport.id);
                    else if(index==6)
                      Navigator.pushNamed(context, ExpenseReport.id);
                    else if(index==7)
                      Navigator.pushNamed(context, TillReport.id);
                    else if(index==15)
                 Navigator.pushNamed(context, NewDash.id);
                    else if(index==14)
                 Navigator.pushNamed(context, DiscountSales.id);
                    else if(index==13)
                 Navigator.pushNamed(context, ItemReport.id);
                    else if(index==12)
                      Navigator.pushNamed(context, StockTransferReport.id);
                    else if(index==8)
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ReceivablePayable(type: 'RECEIVABLE')));
                    else if(index==9)
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ReceivablePayable(type: 'PAYABLE')));
                    else if(index==10)
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ReceiptReport(type: 'RECEIPT')));
                    else if(index==11)
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ReceiptReport(type: 'PAYMENT')));
                    },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(reportList[index],textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: MediaQuery.of(context).textScaleFactor*15,
                        color: kAppBarItems,
                      ),),
                  ),
                ),
              );
                }),
          ),
        ],
      )
      // Populate the Drawer in the next step.
    );
  }
}
