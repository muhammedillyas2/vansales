import 'package:flutter/material.dart';
import 'package:restaurant_app/components/all_file.dart';
import 'package:restaurant_app/screen/pos_screen.dart';
import 'package:restaurant_app/screen/report_screen.dart';

import '../constants.dart';
String cashWithdrawn;
double closingBalance;
class TillClose extends StatefulWidget {
  static const String id='till_close';
  @override
  _TillCloseState createState() => _TillCloseState();
}

class _TillCloseState extends State<TillClose> {
  String cashWithdrawn;
  TextEditingController openBalanceController=TextEditingController();
  TextEditingController todaySalesController=TextEditingController();
  TextEditingController cashWithdrawnController=TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // allFile.readFile('openBalance');
    // todaySalesController.text=netTotal.toString();
    // openBalance==null?openBalance=0:null;
    // openBalanceController.text=openBalance.toString();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width/2,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Text(
                'Open Balance',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                ),
              ),
              TextField(
                style: TextStyle(
                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                ),
                controller: openBalanceController,
                enabled: false,
                keyboardType:
                TextInputType.name,
                decoration: InputDecoration(
                  border:
                  OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0,),
              Text(
                'Today Sales',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                style: TextStyle(
                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                ),
                controller: todaySalesController,
                keyboardType:
                TextInputType.name,
                enabled: false,
                decoration: InputDecoration(
                  border:
                  OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0,),
              Text(
                'Cash Withdrawn',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                ),
              ),
              TextField(
                style: TextStyle(
                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                ),
                controller: cashWithdrawnController,
                onChanged: (value) {
                  cashWithdrawn=value;
                },
                keyboardType:
                TextInputType.name,
                decoration: InputDecoration(
                  border:
                  OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0,),
              TextButton(
                onPressed: ()async {
                  // closingBalance=(openBalance+netTotal)-double.parse(cashWithdrawn);
                  // allFile.writeFile(closingBalance.toString(), 'openBalance');
                  // String invoiceData=await allFile.readFile('invoice');
                  // String totalInvoiceBody='${dateNow()}-$invoiceData~';
                  // allFile.writeFile(totalInvoiceBody, 'totalInvoice');
                  // allFile.deleteFile('invoice');
                  print(closingBalance);
                  openBalanceController.clear();
                  todaySalesController.clear();
                  cashWithdrawnController.clear();
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text('TILL CLOSE',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 2.0,
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: kGreenColor,
                    borderRadius:
                    BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

