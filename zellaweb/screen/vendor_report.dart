import 'package:flutter/material.dart';
import 'package:restaurant_app/components/all_file.dart';
import 'package:restaurant_app/components/database_con.dart';
List<String> vendorInvoiceNoList=[];
List<String> vendorDateList=[];
List<String> vendorAmountList=[];
List<String> vendorTransactionList=[];
String vendorItemList='';
List<String> vendorItemNameList=[];
List<String> vendorItemUomList=[];
List<String> vendorItemPriceList=[];
List<String> vendorItemQtyList=[];
String selectedVendorName;
class VendorReport extends StatefulWidget {
  static const String id='vendor_report';
  @override
  _VendorReportState createState() => _VendorReportState();
}

class _VendorReportState extends State<VendorReport> {
  Future displayItems(int index)async{
    vendorItemNameList=[];
    vendorItemPriceList=[];
    vendorItemQtyList=[];
    vendorItemUomList=[];
    List<String> tempItemList=vendorItemList.split('~');
    if(tempItemList[index].contains(','))
    {
      List tempItemList2=tempItemList[index].split(',');
      for(int i=0;i<tempItemList2.length;i++){
        List tempSplit=tempItemList2[i].toString().split(':');
        vendorItemNameList.add(tempSplit[0].toString().trim());
        vendorItemUomList.add(tempSplit[1].toString().trim());
        vendorItemQtyList.add(tempSplit[2].toString().trim());
        vendorItemPriceList.add(tempSplit[3].toString().trim());
      }
    }
    else
    {
      List tempItemList2=tempItemList[index].split(':');
      vendorItemNameList.add(tempItemList2[0].toString().trim());
      vendorItemUomList.add(tempItemList2[1].toString().trim());
      vendorItemQtyList.add(tempItemList2[2].toString().trim());
      vendorItemPriceList.add(tempItemList2[3].toString().trim());
    }
    return;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Vendor ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                    ),),
                  DropdownButton(
                    hint:Text('Select vendor name') ,
                    value: selectedVendorName, // Not necessary for Option 1
                    items: vendorList.map((String val) {
                      return DropdownMenuItem(
                        child: new Text(val.toString()),
                        value: val,
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedVendorName = newValue;
                        getVendorReport(selectedVendorName);
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    DataTable(
                      sortColumnIndex: 0,
                      sortAscending: true,
                      columns: [DataColumn(

                          label: Text('InvoiceNo',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).textScaleFactor*20,
                              )
                          )),
                        DataColumn(label: Text('Date', style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                        ))),
                        DataColumn(label: Text('Transaction', style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                        ))),
                        DataColumn(label: Text('Amount', style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                        ))),
                      ],
                      rows:
                      List.generate(vendorInvoiceNoList.length, (index) => DataRow(cells: [
                        DataCell(TextButton(
                          onPressed: ()async{
                            await displayItems(index);
                            showDialog(
                                context: context, builder: (context) => Center(
                              child: SingleChildScrollView(
                                child: Dialog(
                                  child: DataTable(
                                    columns: [
                                      DataColumn(label: Text('Item',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                        ),
                                      )),
                                      DataColumn(label: Text('UOM',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                        ),
                                      ),

                                      ),
                                      DataColumn(label: Text('Qty',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                        ),
                                      )),
                                      DataColumn(label: Text('Price',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                        ),)),
                                    ],
                                    rows:List.generate(vendorItemNameList.length, (index) => DataRow(cells: [
                                      DataCell(Text(vendorItemNameList[index], style: TextStyle(
                                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                                      )),),
                                      DataCell(Text(vendorItemUomList[index], style: TextStyle(
                                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                                      )),),
                                      DataCell(Text(vendorItemPriceList[index], style: TextStyle(
                                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                                      )),),
                                      DataCell(Text(vendorItemQtyList[index], style: TextStyle(
                                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                                      )),),
                                    ])),
                                  ),
                                ),
                              ),
                            )
                            );


                          },
                          child: Text(vendorInvoiceNoList[index], style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          )),
                        )),
                        DataCell(Text(vendorDateList[index], style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                        ))),
                        DataCell(Text(vendorTransactionList[index], style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                        ))),
                        DataCell(Text(vendorAmountList[index], style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                        ))),

                      ])),

                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/6),
              height:  MediaQuery.of(context).size.height/12,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Balance',
                    style: TextStyle(
                      fontSize: 30.0,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 50.0,
                  ),
                  Text('##',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),),
                ],),
            )
          ],
        ),
      ),
    );
  }
}
void getVendorReport(String vendor){
  // vendorInvoiceNoList=[];
  // vendorDateList=[];
  // vendorTransactionList=[];
  // vendorAmountList=[];
  // vendorItemList='';
  // int ind1  =  vendorReport.indexOf(vendor);
  // int ind2= vendorReport.indexOf('^',ind1);
  // String  vendorBlock= vendorReport.substring(ind1,ind2);
  // List  vendorBlockSplit1= vendorBlock.split('*');
  // List  vendorBlockSplit2= vendorBlockSplit1[1].split('~');
  // vendorBlockSplit2.removeLast();
  // for(int i=0;i< vendorBlockSplit2.length;i++){
  //     List temp= vendorBlockSplit2[i].toString().split('-');
  //     print(temp);
  //     vendorInvoiceNoList.add(temp[0].toString().substring(11));
  //     vendorDateList.add(temp[1].toString().substring(5));
  //     if(temp.contains('Receipt') || temp.contains('Payment') ) {
  //         vendorTransactionList.add(temp[5].toString());
  //         vendorAmountList.add(temp[4].toString().substring(6));
  //     }
  //     else {
  //         vendorTransactionList.add(temp[6].toString());
  //         vendorAmountList.add(temp[5].toString().substring(6));
  //         vendorItemList+=(temp[3].toString().substring(7,temp[3].toString().length-1));
  //         vendorItemList+='~';
  //     }
  //
  // }
  // print(' vendorBlockSplit2 $vendorBlockSplit2');
}