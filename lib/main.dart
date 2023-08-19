import 'dart:ui';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restaurant_app/screen/admin_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/screen/customer_visit.dart';
import 'package:restaurant_app/screen/first_page.dart';
import 'package:restaurant_app/screen/route_report.dart';
import 'package:restaurant_app/screen/waiter_screen.dart';
import 'screen/login_page.dart';
import 'screen/pos_screen.dart';
import 'screen/customer_screen.dart';
import 'screen/report_screen.dart';





import 'screen/till_close.dart';




import 'screen/organisation_screen.dart';

import 'screen/receipt_payment_screen.dart';




import 'screen/sequence_manager.dart';

import 'screen/customer_report.dart';

// import 'screen/tax_report.dart';

import 'screen/menu_page.dart';



import 'components/database_con.dart';

import 'screen/expense_transaction.dart';

// import 'screen/stock_report.dart';
import 'screen/expense_report.dart';

import 'screen/splash_screen.dart';
import 'screen/vat_report.dart';

import 'screen/stream_reports.dart';


import 'screen/till_report.dart';
import 'screen/new_dashBoard.dart';

import 'screen/receivable_payable.dart';
import 'screen/receipt_report.dart';
import 'screen/owner_dash.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: FirebaseOptions(
    //     apiKey: "AIzaSyAxIZ59jSofhr0hxGcxgZHCdEZ6es0Ix3o",
    //     authDomain: "apsaravan-a9b6d.firebaseapp.com",
    //     projectId: "apsaravan-a9b6d",
    //     storageBucket: "apsaravan-a9b6d.appspot.com",
    //     messagingSenderId: "58349233299",
    //     appId: "1:58349233299:web:800f68e157bc83053a9966"
    // ),
  );
  FirebaseFirestore.instance.settings =
  const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  runApp(RealGrocery());
}

class RealGrocery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => DbCon(),
      child: MaterialApp(

        debugShowCheckedModeBanner: false,
        initialRoute: LoginScreen.id,
        title: "dotOrders",
        routes: {
          SplashScreen.id:(context)=>SplashScreen(),
       CustomerVisit.id:(context)=>CustomerVisit(),
          FirstScreen.id:(context)=>FirstScreen(),
          RouteReport.id:(context)=>RouteReport(),
          LoginScreen.id: (context) => LoginScreen(),
          PosScreen.id:(context)=>PosScreen(),
          //CustomerScreen.id:(context)=>CustomerScreen(),
          ReportScreen.id:(context)=>ReportScreen(),



          ExpenseTransaction.id:(context)=>ExpenseTransaction(),

          TillClose.id:(context)=>TillClose(),




          OrganisationScreen.id:(context)=>OrganisationScreen(),


          ReceiptPayment.id:(context)=>ReceiptPayment(),


          SequenceManager.id:(context)=>SequenceManager(),

          CustomerReport.id:(context)=>CustomerReport(),

          // TaxReport.id:(context)=>TaxReport(),

         // DashBoardPage.id:(context)=>DashBoardPage(),
          MenuPage.id:(context)=>MenuPage(),

          // CartScreen.id:(context)=>CartScreen(),
          // EditCategory.id:(context)=>EditCategory(),

          // TaxScreen.id:(context)=>TaxScreen(),
          // StockReport.id:(context)=>StockReport(),
          ExpenseReport.id:(context)=>ExpenseReport(),
          VatReport.id:(context)=>VatReport(),

          StreamReports.id:(context)=>StreamReports(),

          // StreamVat.id:(context)=>StreamVat(),
          TillReport.id:(context)=>TillReport(),
          NewDash.id:(context)=>NewDash(),

          ReceivablePayable.id:(context)=>ReceivablePayable(),
          ReceiptReport.id:(context)=>ReceiptReport(),
          OwnerDash.id:(context)=>OwnerDash(),

          // StockTransferReport.id:(context)=>StockTransferReport(),

          WaiterScreen.id:(context)=>WaiterScreen(),
          AdminScreen.id:(context)=>AdminScreen(),

          // KaboozPrinter.id:(context)=>KaboozPrinter(),
        },
      ),
    );
  }
}
