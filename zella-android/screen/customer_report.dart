import 'package:flutter/material.dart';
import 'package:restaurant_app/components/all_file.dart';
List<String> customerInvoiceNoList=[];
List<String> customerDateList=[];
List<String> customerAmountList=[];
List<String> customerTransactionList=[];
String customerItemList='';
List<String> customerItemNameList=[];
List<String> customerItemUomList=[];
List<String> customerItemPriceList=[];
List<String> customerItemQtyList=[];
String selectedCustomerName;

DateTime  fromDate;
DateTime toDate =DateTime.now();
var  fromDateUnix ='';
var toDateUnix = '';
var datePicked;

class CustomerReport extends StatefulWidget {
  static const String id='customer_report';
  @override
  _CustomerReportState createState() => _CustomerReportState();
}

class _CustomerReportState extends State<CustomerReport> {
  Future displayItems(int index)async{
    customerItemNameList=[];
    customerItemPriceList=[];
    customerItemQtyList=[];
    customerItemUomList=[];
    List<String> tempItemList=customerItemList.split('~');
    if(tempItemList[index].contains(','))
    {
      List tempItemList2=tempItemList[index].split(',');
      for(int i=0;i<tempItemList2.length;i++){
        List tempSplit=tempItemList2[i].toString().split(':');
        customerItemNameList.add(tempSplit[0].toString().trim());
        customerItemUomList.add(tempSplit[1].toString().trim());
        customerItemQtyList.add(tempSplit[2].toString().trim());
        customerItemPriceList.add(tempSplit[3].toString().trim());
      }
    }
    else
    {
      List tempItemList2=tempItemList[index].split(':');
      customerItemNameList.add(tempItemList2[0].toString().trim());
      customerItemUomList.add(tempItemList2[1].toString().trim());
      customerItemQtyList.add(tempItemList2[2].toString().trim());
      customerItemPriceList.add(tempItemList2[3].toString().trim());
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Customer ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                    ),),
                  /*DropdownButton(
                    hint:Text('Select customer name') ,
                    value: selectedCustomerName, // Not necessary for Option 1
                    items: customerList.map((String val) {
                      return DropdownMenuItem(
                        child: new Text(val.toString()),
                        value: val,
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedCustomerName = newValue;
                       // getCustomerReport(selectedCustomerName);
                      });
                    },
                  ),*/
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
                        width: 250.0,
                        height: 30.0,
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
                      width: 250.0,
                      height: 30.0,
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
                  TextButton(

                      onPressed: ()  {
                        setState(() {
                          getCustomerReport("ABDULLAH");
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
                      List.generate(customerInvoiceNoList.length, (index) => DataRow(cells: [
                        DataCell(TextButton(
                          onPressed: ()async{
                            await displayItems(index);
                            showDialog(context: context, builder: (context) => Center(
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
                                    rows:List.generate(customerItemNameList.length, (index) => DataRow(cells: [
                                      DataCell(Text(customerItemNameList[index], style: TextStyle(
                                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                                      )),),
                                      DataCell(Text(customerItemUomList[index], style: TextStyle(
                                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                                      )),),
                                      DataCell(Text(customerItemPriceList[index], style: TextStyle(
                                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                                      )),),
                                      DataCell(Text(customerItemQtyList[index], style: TextStyle(
                                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                                      )),),
                                    ])),
                                  ),
                                ),
                              ),
                            )
                            );


                          },
                          child: Text(customerInvoiceNoList[index], style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          )),
                        )),
                        DataCell(Text(customerDateList[index], style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                        ))),
                        DataCell(Text(customerTransactionList[index], style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                        ))),
                        DataCell(Text(customerAmountList[index], style: TextStyle(
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
String getCustomerReport(String customer){
  // customerInvoiceNoList=[];
  // customerDateList=[];
  // customerTransactionList=[];
  // customerAmountList=[];
  // customerItemList='';
  // int ind1  = customerReport.indexOf(customer);
  // int ind2=customerReport.indexOf('^',ind1);
  // String customerBlock=customerReport.substring(ind1,ind2);
  // List customerBlockSplit1=customerBlock.split('*');
  // List customerBlockSplit2=customerBlockSplit1[1].split('~');
  // customerBlockSplit2.removeLast();
  // for(int i=0;i<customerBlockSplit2.length;i++){
  //     List temp=customerBlockSplit2[i].toString().split('-');
  //     print(temp);
  //     customerInvoiceNoList.add(temp[0].toString().substring(11));
  //     customerDateList.add(temp[1].toString().substring(5));
  //     if(temp.contains('Receipt') || temp.contains('Payment') ) {
  //         customerTransactionList.add(temp[5].toString());
  //         customerAmountList.add(temp[4].toString().substring(6));
  //
  //     }
  //     else {
  //         customerTransactionList.add(temp[7].toString());
  //         print('customerTransactionList $customerTransactionList');
  //         customerAmountList.add(temp[6].toString().substring(6));
  //         customerItemList+=(temp[3].toString().substring(7,temp[3].toString().length-1));
  //         customerItemList+='~';
  //     }
  // }
  // print('customerBlockSplit2 $customerBlockSplit2');

}