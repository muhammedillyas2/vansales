import 'package:flutter/material.dart';
import 'package:restaurant_app/components/all_file.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/screen/report_screen.dart';

import '../constants.dart';
List<String> invoiceNoList=[];
List<String> dateList=[];
List<String> itemNameList=[];
List<String> categoryList=[];
List<String> taxNamesList=[];
List<double> taxAmtList=[];
List<String> taxRateList=[];
List<String> itemQtyList=[];
List<double> lineTotalList=[];
List<String> typeList=[];

double netTotal=0;double cess1Total=0;double cess12Total=0;
DateTime  fromDate;
DateTime toDate =DateTime.now();
var datePicked;String txName = "GST5";


String selectedVendorName;
class TaxReport extends StatefulWidget {
  static const String id='tax_report';
  @override
  _TaxReportState createState() => _TaxReportState();
}

class _TaxReportState extends State<TaxReport> {

  @override
  Widget build(BuildContext context) {
      double currentWidth=MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          appBar:AppBar(
              title: Text('POSIMATE',style: TextStyle(
                  fontFamily: 'BebasNeue',
                  letterSpacing: 2.0
              ),),
              titleSpacing: 0.0,
              backgroundColor: kGreenColor,
          ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Container(
                    padding: EdgeInsets.all(8.0),
                    child:currentWidth>600?Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        // crossAxisAlignment: CrossAxisAlignment.start,
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
                                    fromDate = datePicked;

                                    setState(() {
                                        fromDate = fromDate;
                                        print(fromDate);
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
                                                ),
                                            ),

                                            Text(fromDate!=null?fromDate.toString():"")
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
                                    toDate = datePicked;
                                    //showDialogBox(datePicked.toString());
                                    setState(() {
                                        toDate = toDate;
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
                                                ),
                                            ),
                                            Text(toDate.toString()),
                                        ],
                                    ),
                                ),
                            ),

                            // Text('Tax Rates ',
                            //     style: TextStyle(
                            //         fontWeight: FontWeight.bold,
                            //         fontSize: MediaQuery.of(context).textScaleFactor*20,
                            //     ),),
                            // DropdownButton(
                            //     hint:Text('Select Tax Name') ,
                            //     value: txName, // Not necessary for Option 1
                            //     items: taxNameList.map((String val) {
                            //         return DropdownMenuItem(
                            //             child: new Text(val.toString()),
                            //             value: val,
                            //         );
                            //     }).toList(),
                            //     onChanged: (newValue) {
                            //         setState(() {
                            //             txName = newValue;
                            //             invoiceNoList = [];  dateList = [];  partyList = [];  amountList = [];cess1List=[];cess12List=[];invoiceValueList=[];
                            //             netTotal = 0;
                            //             cess1Total = 0;
                            //             cess12Total = 0;
                            //             // getTaxData();
                            //             setState(() {
                            //                 print("Bu");
                            //             });
                            //
                            //         });
                            //     },
                            // ),

                            TextButton(onPressed: () async {
                                await getTaxData();
                                setState(() {

                                });
                            },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                        'Search',
                                        style: TextStyle(
                                            letterSpacing: 1.0,
                                            color: Colors.white
                                        ),
                                    ),
                                )),


                        ],
                    ):Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        // crossAxisAlignment: CrossAxisAlignment.start,
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
                                    fromDate = datePicked;

                                    setState(() {
                                        fromDate = fromDate;
                                        print(fromDate);
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
                                                ),
                                            ),

                                            Text(fromDate!=null?fromDate.toString():"")
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
                                    toDate = datePicked;
                                    //showDialogBox(datePicked.toString());
                                    setState(() {
                                        toDate = toDate;
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
                                                ),
                                            ),
                                            Text(toDate.toString()),
                                        ],
                                    ),
                                ),
                            ),

                            // Text('Tax Rates ',
                            //     style: TextStyle(
                            //         fontWeight: FontWeight.bold,
                            //         fontSize: MediaQuery.of(context).textScaleFactor*20,
                            //     ),),
                            // DropdownButton(
                            //     hint:Text('Select Tax Name') ,
                            //     value: txName, // Not necessary for Option 1
                            //     items: taxNameList.map((String val) {
                            //         return DropdownMenuItem(
                            //             child: new Text(val.toString()),
                            //             value: val,
                            //         );
                            //     }).toList(),
                            //     onChanged: (newValue) {
                            //         setState(() {
                            //             txName = newValue;
                            //             invoiceNoList = [];  dateList = [];  partyList = [];  amountList = [];cess1List=[];cess12List=[];invoiceValueList=[];
                            //             netTotal = 0;
                            //             cess1Total = 0;
                            //             cess12Total = 0;
                            //             // getTaxData();
                            //             setState(() {
                            //                 print("Bu");
                            //             });
                            //
                            //         });
                            //     },
                            // ),

                            TextButton(onPressed: () async {
                                await getTaxData();
                                setState(() {

                                });
                            },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                        'Search',
                                        style: TextStyle(
                                            letterSpacing: 1.0,
                                            color: Colors.white
                                        ),
                                    ),
                                )),


                        ],
                    ),
                ),
                Expanded(
                    child: Container(
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: DataTable(
                                      sortColumnIndex: 0,
                                      sortAscending: true,
                                      columns: [
                                          DataColumn(label: Text('InvoiceNo', style: TextStyle(
                                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          ) )),
                                          DataColumn(label: Text('Date', style: TextStyle(
                                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          ))),
                                          DataColumn(label: Text('ItemName', style: TextStyle(
                                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          ))),
                                          DataColumn(label: Text('Category', style: TextStyle(
                                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          ))),
                                          DataColumn(label: Text('TaxName', style: TextStyle(
                                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          ))),
                                          DataColumn(label: Text('TaxAmt ', style: TextStyle(
                                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          ))),
                                          DataColumn(label: Text('TaxRate', style: TextStyle(
                                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          ))),   DataColumn(label: Text('Qty', style: TextStyle(
                                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          ))),DataColumn(label: Text('Total', style: TextStyle(
                                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          ))), DataColumn(label: Text('Transaction', style: TextStyle(
                                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          ))),
                                      ],
                                      rows:
                                      List.generate(invoiceNoList.length, (index) => DataRow(cells: [
                                          DataCell(TextButton(
                                              onPressed: (){

                                              },
                                              child: Text(invoiceNoList[index], style: TextStyle(
                                                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                                              )),
                                          )),
                                          DataCell(Text(dateList[index], style: TextStyle(
                                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          ))),
                                          DataCell(Text(itemNameList[index], style: TextStyle(
                                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          ))),
                                          DataCell(Text(categoryList[index], style: TextStyle(
                                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          ))),
                                          DataCell(Text(taxNamesList[index], style: TextStyle(
                                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          ))),
                                          DataCell(Text(taxAmtList[index].toStringAsFixed(decimals), style: TextStyle(
                                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          ))),
                                          DataCell(Text(taxRateList[index], style: TextStyle(
                                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          ))), DataCell(Text(itemQtyList[index], style: TextStyle(
                                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          ))), DataCell(Text(lineTotalList[index].toStringAsFixed(decimals), style: TextStyle(
                                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          ))), DataCell(Text(typeList[index], style: TextStyle(
                                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          ))),


                                      ])),

                                  ),
                              ),
                          ),
                        ),
                    ),
                ),
            ],
        ),
      ),
    );
  }
}

Future getTaxData()async{
    invoiceNoList=[];
    dateList=[];
    itemNameList=[];
    categoryList=[];
    taxNamesList=[];
    taxAmtList=[];
    taxRateList=[];
    itemQtyList=[];
    lineTotalList=[];
    typeList=[];
    List invoiceDataList1=[];
    invoiceDataList1=await getReports('item_report',fromDate.toString(),toDate.toString(),'');
    print('invoiceDataList1 $invoiceDataList1');
    for(int i=0;i<invoiceDataList1.length;i++){
        List eachOrderSplit=invoiceDataList1[i].toString().split(',');
        invoiceNoList.add(eachOrderSplit[1]);
        dateList.add(eachOrderSplit[2]);
        itemNameList.add(eachOrderSplit[3]);
        categoryList.add(eachOrderSplit[4]);
        taxNamesList.add(eachOrderSplit[5]);
        String tempTaxAmt=eachOrderSplit[6];
        taxAmtList.add(double.parse(tempTaxAmt));
        taxRateList.add(eachOrderSplit[7]);
        itemQtyList.add(eachOrderSplit[8]);
        String tempTotal=eachOrderSplit[9];
        lineTotalList.add(double.parse(tempTotal));
        String tempType=eachOrderSplit[10];
        tempType=tempType.substring(0,tempType.length-1);
        typeList.add(tempType);
    }
}