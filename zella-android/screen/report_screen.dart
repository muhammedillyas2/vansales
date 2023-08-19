import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_app/screen/login_page.dart';
import '../constants.dart';
import 'package:restaurant_app/components/all_file.dart';
import 'package:restaurant_app/components/database_con.dart';
String selectedUser=currentUser;
List<String> invoiceNoList=[];
List<String> dateList=[];
List<String> customerNameList=[];
List<String> deliveryList=[];
List<String> paymentList=[];
List<String> userOrdered=[];
List<double> totalList=[];
String itemsList='';
List<String> itemNameList=[];
List<String> itemUomList=[];
List<String> itemPriceList=[];
List<String> itemQtyList=[];
double netTotal=0;
List<String> displayList=[];
DateTime  fromDate;
DateTime toDate =DateTime.now();
var  fromDateUnix ='';
var toDateUnix = '';
var datePicked;

class ReportScreen extends StatefulWidget {
  final String transactionType;
  static const String id = 'report';

  const ReportScreen({Key key, this.transactionType}) : super(key: key);
  @override
  _ReportScreenState createState() => _ReportScreenState(transactionType);
}

class _ReportScreenState extends State<ReportScreen> {

final String transactionType;

  _ReportScreenState(this.transactionType);
  Future displayItems(int index)async{
    print('display ${displayList[index]}');
    itemPriceList=[];
    itemNameList=[];
    itemQtyList=[];
    itemUomList=[];
    String tempText=displayList[index];
    print('dbConnected $dbConnected');
    if(dbConnected=='1')
      tempText=tempText.substring(1,tempText.length-1);
    int ind1=tempText.indexOf('[');
    int ind2=tempText.indexOf(']',ind1);
    print('ind1 $ind1 $ind2');
    String items=tempText.substring(ind1,ind2+1);
    items=items.trim();
    if(items.contains(','))
    {
      items=items.substring(1,items.length-1);
      print('items $items');
      List tempItemList2=items.split(',');
      for(int i=0;i<tempItemList2.length;i++){
        List tempSplit=tempItemList2[i].toString().split(':');
        itemNameList.add(tempSplit[0].toString().trim());
        itemUomList.add(tempSplit[1].toString().trim());
        itemQtyList.add(tempSplit[2].toString().trim());
        itemPriceList.add(tempSplit[3].toString().trim());
      }
    }
    else
    {
      print('items $items');
      items=items.substring(1,items.length-1);
      List tempItemList2=items.split(':');
      itemNameList.add(tempItemList2[0].toString().trim());
      itemUomList.add(tempItemList2[1].toString().trim());
      itemQtyList.add(tempItemList2[2].toString().trim());
      itemPriceList.add(tempItemList2[3].toString().trim());
    }
    return;
  }

@override
  void initState() {
    // TODO: implement initState
  invoiceNoList=[];
  dateList=[];
  deliveryList=[];
  paymentList=[];
  customerNameList=[];
  totalList=[];
  userOrdered=[];
netTotal=0;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text('POSIMATE',style: TextStyle(
            fontFamily: 'BebasNeue',
            letterSpacing: 2.0
        ),),
        titleSpacing: 0.0,
        backgroundColor: kGreenColor,
        automaticallyImplyLeading: true,

      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
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
                                color: kGreenColor,
                                fontWeight: FontWeight.bold
                            ),
                          ),

                          Text(fromDate!=null?fromDate.toString().substring(0,16):"",style: TextStyle(color: kGreenColor),)
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
                            color: kGreenColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(toDate.toString().substring(0,10),style: TextStyle(color: kGreenColor),),
                      ],
                    ),
                  ),
                ),
                TextButton(onPressed: () async {
                  await getInvoiceData(transactionType);
                  setState(()  {

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
                            color: kItemContainer
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
                      DataColumn(label: Text('Customer', style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                      ))),
                      DataColumn(label: Text('Payment', style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                      ))),
                      DataColumn(label: Text('Delivery', style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                      ))),
                      DataColumn(label: Text('Total', style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                      ))),
                      DataColumn(label: Text('User', style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                      ))),
                    ],

                    rows:

                    List.generate(invoiceNoList.length, (index) => DataRow(cells: [
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
                                  rows:List.generate(itemNameList.length, (index) => DataRow(cells: [
                                    DataCell(Text(itemNameList[index], style: TextStyle(
                                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                                    )),),
                                    DataCell(Text(itemUomList[index], style: TextStyle(
                                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                                    )),),
                                    DataCell(Text(itemPriceList[index], style: TextStyle(
                                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                                    )),),
                                    DataCell(Text(itemQtyList[index], style: TextStyle(
                                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                                    )),),
                                  ])),
                                ),
                              ),
                            ),
                          )
                          );


                        },

                        child: Text(invoiceNoList[index], style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                        )),
                      )),

                      DataCell(Text(dateList[index], style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                      ))),
                      DataCell(Text(customerNameList[index], style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                      ))),
                      DataCell(Text(paymentList[index], style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                      ))),
                      DataCell(Text(deliveryList[index], style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                      ))),
                      DataCell(Text(totalList[index].toStringAsFixed(decimals), style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                      ))),
                      DataCell(Text(userOrdered[index], style: TextStyle(
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
                Text(netTotal.toStringAsFixed(decimals),
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
Future getInvoiceData(String transaction)async {
  print('inside get invoice data $transaction');
  displayList=[];
  invoiceNoList=[];
  dateList=[];
  customerNameList=[];
  paymentList=[];
  deliveryList=[];
  totalList=[];
  userOrdered=[];
  netTotal=0;
  if(transaction=='sales'){
    print('inside sales');
    List invoiceDataList1=[];
    invoiceDataList1=await getReports('invoice_data',fromDate.toString(),toDate.toString(),selectedUser);
    print('invoiceDataList1 sales $invoiceDataList1');
    for(int i=0;i<invoiceDataList1.length;i++){
      displayList.add(invoiceDataList1[i].toString());
      List eachOrderSplit=invoiceDataList1[i].toString().split(',');
      invoiceNoList.add(eachOrderSplit[1]);
                   dateList.add(eachOrderSplit[2]);
                   customerNameList.add(eachOrderSplit[3]);
                   paymentList.add(eachOrderSplit[eachOrderSplit.length-5]);
                   deliveryList.add(eachOrderSplit[eachOrderSplit.length-4]);
                   //kfcess = eachOrderSplit[6].toStringAsFixed(2);
      String tempTotal=eachOrderSplit[eachOrderSplit.length-3];
                   totalList.add(double.parse(tempTotal));
                   print('total ${eachOrderSplit[eachOrderSplit.length-3]}');
                   print('user ${eachOrderSplit[eachOrderSplit.length-1]}');
                   netTotal += double.parse(eachOrderSplit[eachOrderSplit.length-3]);
      String tempUser=eachOrderSplit[eachOrderSplit.length-1];
      tempUser=tempUser.substring(0,tempUser.length-1);
      userOrdered.add(tempUser);
    }
  }
  else if(transaction=='purchase'){
    print('inside purchase');
    List invoiceDataList1=[];
    invoiceDataList1=await getReports('purchase_data',fromDate.toString(),toDate.toString(),selectedUser);
    print('invoiceDataList1 $invoiceDataList1');
    for(int i=0;i<invoiceDataList1.length;i++){
      displayList.add(invoiceDataList1[i].toString());
      List eachOrderSplit=invoiceDataList1[i].toString().split(',');
      invoiceNoList.add(eachOrderSplit[1]);
      dateList.add(eachOrderSplit[2]);
      customerNameList.add(eachOrderSplit[3]);
      paymentList.add(eachOrderSplit[eachOrderSplit.length-4]);
      deliveryList.add('##');
      //kfcess = eachOrderSplit[6].toStringAsFixed(2);
      String tempTotal=eachOrderSplit[eachOrderSplit.length-3];
      totalList.add(double.parse(tempTotal));
      print('total ${eachOrderSplit[eachOrderSplit.length-3]}');
      print('user ${eachOrderSplit[eachOrderSplit.length-1]}');
      netTotal += double.parse(eachOrderSplit[eachOrderSplit.length-3]);
      String tempUser=eachOrderSplit[eachOrderSplit.length-1];
      tempUser=tempUser.substring(0,tempUser.length-1);
      userOrdered.add(tempUser);
    }
  }
  else if(transaction=='sales_return'){
    print('inside sales_return');
    List invoiceDataList1=[];
    invoiceDataList1=await getReports('sales_return',fromDate.toString(),toDate.toString(),selectedUser);
    print('invoiceDataList1 $invoiceDataList1');
    for(int i=0;i<invoiceDataList1.length;i++){
      displayList.add(invoiceDataList1[i].toString());
      List eachOrderSplit=invoiceDataList1[i].toString().split(',');
      invoiceNoList.add(eachOrderSplit[1]);
      dateList.add(eachOrderSplit[2]);
      customerNameList.add(eachOrderSplit[3]);
      paymentList.add(eachOrderSplit[eachOrderSplit.length-4]);
      deliveryList.add('##');
      //kfcess = eachOrderSplit[6].toStringAsFixed(2);
      String tempTotal=eachOrderSplit[eachOrderSplit.length-3];
      totalList.add(double.parse(tempTotal));
      print('total ${eachOrderSplit[eachOrderSplit.length-3]}');
      print('user ${eachOrderSplit[eachOrderSplit.length-1]}');
      netTotal += double.parse(eachOrderSplit[eachOrderSplit.length-3]);
      String tempUser=eachOrderSplit[eachOrderSplit.length-1];
      tempUser=tempUser.substring(0,tempUser.length-1);
      userOrdered.add(tempUser);
    }
  }
  else if(transaction=='purchase_return'){
    print('inside purchase return');
    List invoiceDataList1=[];
    invoiceDataList1=await getReports('purchase_return',fromDate.toString(),toDate.toString(),selectedUser);
    print('invoiceDataList1 $invoiceDataList1');
    for(int i=0;i<invoiceDataList1.length;i++){
      displayList.add(invoiceDataList1[i].toString());
      List eachOrderSplit=invoiceDataList1[i].toString().split(',');
      print('eachOrderSplit $eachOrderSplit');
      invoiceNoList.add(eachOrderSplit[1]);
      dateList.add(eachOrderSplit[2]);
      customerNameList.add(eachOrderSplit[3]);
      paymentList.add(eachOrderSplit[eachOrderSplit.length-4]);
      deliveryList.add('##');
      //kfcess = eachOrderSplit[6].toStringAsFixed(2);
      String tempTotal=eachOrderSplit[eachOrderSplit.length-3];
      totalList.add(double.parse(tempTotal));
      print('total ${eachOrderSplit[eachOrderSplit.length-3]}');
      print('user ${eachOrderSplit[eachOrderSplit.length-1]}');
      netTotal += double.parse(eachOrderSplit[eachOrderSplit.length-3]);
      String tempUser=eachOrderSplit[eachOrderSplit.length-1];
      tempUser=tempUser.substring(0,tempUser.length-1);
      userOrdered.add(tempUser);
    }
}
String dtp(String dt)
{
  print('dt $dt');
  String year = dt.substring(6,10);
  String month = dt.substring(3,5);
  String day = dt.substring(0,2);
  return year+"-"+day+"-"+month;

}
}