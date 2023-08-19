import 'package:flutter/material.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/screen/customer_report.dart';
import 'package:restaurant_app/screen/expense_report.dart';
import 'package:restaurant_app/screen/item_report.dart';
import 'package:restaurant_app/screen/stream_reports.dart';
import 'package:restaurant_app/screen/stream_tax.dart';
import 'stream_vat.dart';
import 'package:restaurant_app/screen/vendor_report.dart';
import 'report_screen.dart';
import '../constants.dart';
import 'package:restaurant_app/screen/tax_report.dart';
import 'stock_report.dart';
import 'vat_report.dart';
class AllReports extends StatefulWidget {
  static const String id = 'all_reports';
  @override
  _AllReportsState createState() => _AllReportsState();
}

class _AllReportsState extends State<AllReports> {
  List<String> reportList = [
    'Item',
    'Sales',
    'Purchase',
    'Sales Return',
    'Purchase Return',
    'Tax',
    'Stock',
    'Expense'
  ];
  // List<String> reportList = [
  //   'Customer',
  //   'Vendor',
  //   'Item',
  //   'Sales',
  //   'Purchase',
  //   'Sales Return',
  //   'Purchase Return',
  //   'Tax',
  //   'Stock',
  //   'Expense'
  // ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'POSIMATE',
          style: TextStyle(fontFamily: 'BebasNeue', letterSpacing: 2.0),
        ),
        titleSpacing: 0.0,
        backgroundColor: kGreenColor,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
          width: MediaQuery.of(context).size.width / 2,
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                crossAxisCount: 5,
              ),
              scrollDirection: Axis.vertical,
              itemCount: reportList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    if (index == 0)
                      Navigator.pushNamed(context, ItemReport.id);
                    // else if (index == 1)
                    //   Navigator.pushNamed(context, VendorReport.id);
                     if (index == 1) {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>StreamReports(transactionType: 'invoice_data')));
                    } else if (index == 2) {
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>StreamReports(transactionType: 'purchase')));
                    } else if (index == 3) {
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>StreamReports(transactionType: 'sales_return')));
                    } else if (index == 4) {
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>StreamReports(transactionType: 'purchase_return')));
                    } else if (index == 5) {
                      Navigator.pushNamed(context, StreamVat.id);
                    } else if (index == 6) {
                      getStockList();
                      Navigator.pushNamed(context, StockReport.id);
                    } else if (index == 7) {
                      Navigator.pushNamed(context, ExpenseReport.id);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 7,
                    height: MediaQuery.of(context).size.height / 6,
                    decoration: BoxDecoration(
                        color: kGreenColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      reportList[index],
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor * 20,
                        color: kItemContainer,
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
