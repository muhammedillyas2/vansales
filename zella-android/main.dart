import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'screen/login_page.dart';
import 'screen/pos_screen.dart';
import 'screen/customer_screen.dart';
import 'screen/report_screen.dart';
import 'screen/add_customer.dart';
import 'screen/add_product.dart';
import 'screen/menu_screen.dart';
import 'screen/administration_screen.dart';
import 'screen/uom_screen.dart';
import 'screen/category_screen.dart';
import 'screen/till_close.dart';
import 'screen/edit_screen.dart';
import 'screen/uom_edit_screen.dart';
import 'screen/product_edit_screen.dart';
import 'screen/customer_edit_screen.dart';
import 'screen/organisation_screen.dart';
import 'screen/add_vendor.dart';
import 'screen/purchase_screen.dart';
import 'screen/receipt_payment_screen.dart';
import 'screen/sales_return.dart';
import 'screen/user_management.dart';
import 'screen/purchase_return.dart';
import 'screen/cart_screen.dart';
import 'screen/sequence_manager.dart';
import 'screen/all_reports_screen.dart';
import 'screen/customer_report.dart';
import 'screen/vendor_report.dart';
import 'screen/tax_report.dart';
import 'screen/dash_board.dart';
import 'screen/menu_page.dart';
import 'screen/modifier.dart';
import 'screen/category_edit_screen.dart';
import 'screen/printer_management.dart';
import 'components/database_con.dart';
import 'screen/expense_head.dart';
import 'screen/expense_transaction.dart';
import 'screen/tax_Screen.dart';
import 'screen/stock_report.dart';
import 'screen/expense_report.dart';
import 'screen/kabooz_printer.dart';
import 'screen/splash_screen.dart';
import 'screen/vat_report.dart';
import 'screen/item_report.dart';
import 'screen/stream_reports.dart';
import 'screen/stream_tax.dart';
import 'screen/stream_vat.dart';
import 'screen/till_report.dart';
import 'screen/new_dashBoard.dart';
import 'screen/purchase_report.dart';
import 'screen/receivable_payable.dart';
import 'screen/receipt_report.dart';
import 'screen/owner_dash.dart';
import 'screen/stock_transfer.dart';
import 'screen/stockTransfer_report.dart';
import 'screen/kitchen_display.dart';
import 'screen/warehouse_report.dart';
import 'screen/admin_screen.dart';
import 'screen/discount_sales.dart';
Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: FirebaseOptions(
    //     apiKey: "AIzaSyCDgHSH6b5hrSPWBkddhLK-yf0naaA1TMA",
    //     authDomain: "zellafoods.firebaseapp.com",
    //     projectId: "zellafoods",
    //     storageBucket: "zellafoods.appspot.com",
    //     messagingSenderId: "708711352133",
    //     appId: "1:708711352133:web:28d0c25c772de0455d202c"
    //
    // ),
  );
  runApp(RealGrocery());
}

class RealGrocery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => DbCon(),
      child: MaterialApp(

        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.id,
        title: "dotOrders",
        routes: {
          SplashScreen.id:(context)=>SplashScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          PosScreen.id:(context)=>PosScreen(),
          //CustomerScreen.id:(context)=>CustomerScreen(),
          ReportScreen.id:(context)=>ReportScreen(),
          AddCustomer.id:(context)=>AddCustomer(),
          AddProduct.id:(context)=>AddProduct(),
          MenuScreen.id:(context)=>MenuScreen(),
          AdministrationScreen.id:(context)=>AdministrationScreen(),
          UomScreen.id:(context)=>UomScreen(),
          ExpenseHead.id:(context)=>ExpenseHead(),
          ExpenseTransaction.id:(context)=>ExpenseTransaction(),
          CategoryScreen.id:(context)=>CategoryScreen(),
          TillClose.id:(context)=>TillClose(),
          EditScreen.id:(context)=>EditScreen(),
          EditUom.id:(context)=>EditUom(),
          EditItems.id:(context)=>EditItems(),
          EditCustomer.id:(context)=>EditCustomer(),
          OrganisationScreen.id:(context)=>OrganisationScreen(),
          AddVendor.id:(context)=>AddVendor(),
          PurchaseScreen.id:(context)=>PurchaseScreen(),
          ReceiptPayment.id:(context)=>ReceiptPayment(),
          SalesReturn.id:(context)=>SalesReturn(),
          PurchaseReturn.id:(context)=>PurchaseReturn(),
          SequenceManager.id:(context)=>SequenceManager(),
          AllReports.id:(context)=>AllReports(),
          CustomerReport.id:(context)=>CustomerReport(),
          VendorReport.id:(context)=>VendorReport(),
          TaxReport.id:(context)=>TaxReport(),
          AddUser.id:(context)=>AddUser(),
         // DashBoardPage.id:(context)=>DashBoardPage(),
          MenuPage.id:(context)=>MenuPage(),
          AddModifier.id:(context)=>AddModifier(),
          // CartScreen.id:(context)=>CartScreen(),
          // EditCategory.id:(context)=>EditCategory(),
          PrinterManagement.id:(context)=>PrinterManagement(),
          TaxScreen.id:(context)=>TaxScreen(),
          StockReport.id:(context)=>StockReport(),
          ExpenseReport.id:(context)=>ExpenseReport(),
          VatReport.id:(context)=>VatReport(),
          ItemReport.id:(context)=>ItemReport(),
          StreamReports.id:(context)=>StreamReports(),
          StreamTax.id:(context)=>StreamTax(),
          StreamVat.id:(context)=>StreamVat(),
          TillReport.id:(context)=>TillReport(),
          NewDash.id:(context)=>NewDash(),
          PurchaseReport.id:(context)=>PurchaseReport(),
          ReceivablePayable.id:(context)=>ReceivablePayable(),
          ReceiptReport.id:(context)=>ReceiptReport(),
          OwnerDash.id:(context)=>OwnerDash(),
          StockTransfer.id:(context)=>StockTransfer(),
          StockTransferReport.id:(context)=>StockTransferReport(),
          KitchenDisplay.id:(context)=>KitchenDisplay(),
          WarehouseReport.id:(context)=>WarehouseReport(),
          AdminScreen.id:(context)=>AdminScreen(),
          DiscountSales.id:(context)=>DiscountSales(),
          // KaboozPrinter.id:(context)=>KaboozPrinter(),
        },
      ),
    );
  }
}
