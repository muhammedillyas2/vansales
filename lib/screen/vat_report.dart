import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/screen/pos_screen.dart';


import '../constants.dart';
List<String> invoiceNoList=[];
List<String> dateList=[];
List<String> customerNameList=[];
List<String> vatNoList=[];
List<double> totalList=[];
List<double> taxableAmt5List=[];
List<double> taxAmt5List=[];
List<double> taxTotal5List=[];
List<double> exemptList=[];
List<String> typeList=[];
List<String> invoiceNoList2=[];
List<String> dateList2=[];
List<String> customerNameList2=[];
List<String> vatNoList2=[];
List<double> totalList2=[];
List<double> taxableAmt5List2=[];
List<double> taxAmt5List2=[];
List<double> taxTotal5List2=[];
List<double> exemptList2=[];
List<String> typeList2=[];
//item wise variables
List<String> itemNameList=[];
List<String> itemUomList=[];
List<String> itemPriceList=[];
List<String> itemQtyList=[];
List<double> itemTaxableList=[];
List<String> itemTaxRateList=[];
List<double> itemTaxAmtList=[];
List<double> itemTaxTotalList=[];
List<double> itemLineTotalList=[];
bool showBoth=false;
double netTotal1=0,netTotal2=0,taxable5total=0,tax5Total=0,netTaxTotal=0,exemptTotal1=0;
double taxable5total2=0,tax5Total2=0,netTaxTotal2=0,exemptTotal2=0;
double diff=0;
class VatReport extends StatefulWidget {
  static const String id = 'vat';
  @override
  _VatReportState createState() => _VatReportState();
}

class _VatReportState extends State<VatReport> {
  List<String> taxType=['Input Tax','Output Tax','Both'];
  String selectedTaxType='Input Tax';
  DateTime  fromDate;
  DateTime toDate =DateTime.now();
  var datePicked;
  @override
  void initState() {
    // TODO: implement initState
    invoiceNoList=[];
    invoiceNoList2=[];
    showBoth=false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double currentWidth=MediaQuery.of(context).size.width;
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
      body:SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                child:currentWidth>600?  Row(
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
                                    color: kGreenColor,
                                    fontWeight: FontWeight.bold
                                ),
                              ),

                              Text(fromDate!=null?fromDate.toString():"",style: TextStyle(color: kGreenColor),)
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
                            Text(toDate.toString(),style: TextStyle(color: kGreenColor),),
                          ],
                        ),
                      ),
                    ),
                    Container(
                     // width: MediaQuery.of(context).size.width / 6,
                      height: 30.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black38,
                            style: BorderStyle.solid,
                            width: 0.80),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: selectedTaxType,
                          items: taxType.map((value) {
                            return DropdownMenuItem(value: value, child: Text(value));
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedTaxType = newValue.toString();
                            });
                          },
                        ),
                      ),
                    ),
                    TextButton(onPressed: () async {
await getVatData();
                      setState(()  {
                        if(selectedTaxType=='Both')
                                showBoth=true;
                        else
                          showBoth=false;
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
                ): Column(
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
                                    color: kGreenColor,
                                    fontWeight: FontWeight.bold
                                ),
                              ),

                              Text(fromDate!=null?fromDate.toString():"",style: TextStyle(color: kGreenColor),)
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
                            Text(toDate.toString(),style: TextStyle(color: kGreenColor),),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width / 6,
                      height: 30.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black38,
                            style: BorderStyle.solid,
                            width: 0.80),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: selectedTaxType,
                          items: taxType.map((value) {
                            return DropdownMenuItem(value: value, child: Text(value));
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedTaxType = newValue.toString();
                            });
                          },
                        ),
                      ),
                    ),
                    TextButton(onPressed: () async {
                      await getVatData();
                      setState(()  {
                        if(selectedTaxType=='Both')
                          showBoth=true;
                        else
                          showBoth=false;
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
              SingleChildScrollView(
                physics: ScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(

                    children: [
                      DataTable(
                       // headingRowHeight: 100.0,
                        sortColumnIndex: 0,
                        sortAscending: true,
                        columns: [
                          DataColumn(
                            label: Text('InvoiceNo',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                                )
                            )),
                          DataColumn(label: Text('Date', style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ))),
                          DataColumn(label: Text('PartyName', style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ))),
                          DataColumn(label: Text('Vat No', style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ))),
                          DataColumn(label: Text('Total', style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ))),
                          DataColumn(label: Text('10% Taxable Amt', style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ))),  DataColumn(label: Text('10% Tax Amt', style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ))),  DataColumn(label: Text('10% Total', style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ))),
                          DataColumn(label: Text('Exempt', style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ))),DataColumn(label: Text('Transaction', style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ))),
                        ],

                        rows:

                        List.generate(invoiceNoList.length, (index) => DataRow(cells: [
                          DataCell(TextButton(
                            onPressed: ()async{
                              await  displayVatItems(invoiceNoList[index]);
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
                                    DataColumn(label: Text('Tax excl.',
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          ),)),
                                         DataColumn(label: Text('Tax incl.',
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          ),)),
                                        DataColumn(label: Text('Total Tax',
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          ),)),
                                        DataColumn(label: Text('Tax Rate',
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          ),)),
                                        DataColumn(label: Text('Line Total',
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          ),))
                                      ],
                                      rows:List.generate(itemNameList.length, (index) => DataRow(cells: [
                                        DataCell(Text(itemNameList[index], style: TextStyle(
                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                        )),),
                                        DataCell(Text(itemUomList[index], style: TextStyle(
                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                        )),),
                                        DataCell(Text(itemQtyList[index], style: TextStyle(
                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                        )),),
                                          DataCell(Text(itemTaxableList[index].toStringAsFixed(decimals), style: TextStyle(
                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                        )),),DataCell(Text(itemTaxTotalList[index].toStringAsFixed(decimals), style: TextStyle(
                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                        )),),DataCell(Text(itemTaxAmtList[index].toStringAsFixed(decimals), style: TextStyle(
                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                        )),),DataCell(Text(itemTaxRateList[index], style: TextStyle(
                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                        )),),DataCell(Text(itemLineTotalList[index].toStringAsFixed(decimals), style: TextStyle(
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
                          DataCell(Text(vatNoList[index], style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ))),
                          DataCell(Text(totalList[index].toStringAsFixed(decimals), style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ))),
                          DataCell(Text(taxableAmt5List[index].toStringAsFixed(decimals), style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ))), DataCell(Text(taxAmt5List[index].toStringAsFixed(decimals), style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ))), DataCell(Text(taxTotal5List[index].toStringAsFixed(decimals), style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ))),
                          DataCell(Text(exemptList[index].toStringAsFixed(decimals), style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ))),DataCell(Text(typeList[index], style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ))),

                        ])),

                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: showBoth,
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    child: Column(

                      children: [
                        DataTable(
                         // headingRowHeight: 100.0,
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
                            DataColumn(label: Text('PartyName', style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                            ))),
                            DataColumn(label: Text('Vat No', style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                            ))),
                            DataColumn(label: Text('Total', style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                            ))),
                            DataColumn(label: Text('10% Taxable Amt', style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                            ))),  DataColumn(label: Text('10% Tax Amt', style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                            ))),  DataColumn(label: Text('10% Total', style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                            ))),
                            DataColumn(label: Text('Exempt', style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                            ))),DataColumn(label: Text('Transaction', style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                            ))),
                          ],

                          rows:

                          List.generate(invoiceNoList2.length, (index) => DataRow(cells: [
                            DataCell(TextButton(
                              onPressed: ()async{
                                await  displayVatItems(invoiceNoList[index]);
                              },

                              child: Text(invoiceNoList2[index], style: TextStyle(
                                fontSize: MediaQuery.of(context).textScaleFactor*20,
                              )),
                            )),

                            DataCell(Text(dateList2[index], style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                            ))),
                            DataCell(Text(customerNameList2[index], style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                            ))),
                            DataCell(Text(vatNoList2[index], style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                            ))),
                            DataCell(Text(totalList2[index].toStringAsFixed(decimals), style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                            ))),
                            DataCell(Text(taxableAmt5List2[index].toStringAsFixed(decimals), style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                            ))), DataCell(Text(taxAmt5List2[index].toStringAsFixed(decimals), style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                            ))), DataCell(Text(taxTotal5List2[index].toStringAsFixed(decimals), style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                            ))),
                            DataCell(Text(exemptList2[index].toStringAsFixed(decimals), style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                            ))),DataCell(Text(typeList2[index], style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                            ))),

                          ])),

                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                  visible: showBoth,
                  child: Container(
                child: Column(
                  children: [
                    Text('Output Tax :$tax5Total', style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                    )),
                    Text('Input Tax :$tax5Total2', style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                    )),
                    Text('Difference :$diff', style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                    )),
                  ],
                ),
              ))
            ],
          ),
        ),
      ) ,
    ));
  }
  Future displayVatItems(String invNo)async{
    itemNameList=[];
    itemUomList=[];
    itemQtyList=[];
    itemTaxAmtList=[];
    itemTaxableList=[];
    itemTaxRateList=[];
    itemTaxTotalList=[];
    itemLineTotalList =[];
    print('inside displayVatItems ${invNo.trim()}');
    List invoiceDataList1=[];
    invoiceDataList1=await getVatItemReport(invNo.trim());
    for(int i=0;i<invoiceDataList1.length;i++){
      List temp=invoiceDataList1[i].toString().split(',');
      itemNameList.add(temp[3].toString().trim());
      itemQtyList.add(temp[8].toString().trim());
      itemUomList.add(temp[11].toString().trim());
      itemLineTotalList.add(double.parse(temp[9].toString().trim()));
      itemTaxAmtList.add(double.parse(temp[6].toString().trim()));
      double tempQty=double.parse(temp[8].toString().trim());
      if(tempQty==1){
        print('qty 1');
        double temp1=double.parse(temp[6].toString().trim());
        double temp2=double.parse(temp[9].toString().trim());
        double temp3=temp2-temp1;
        itemTaxableList.add(temp3);
        itemTaxTotalList.add(temp2);
      }
      else {
        double temp1= double.parse(temp[6].toString().trim())/tempQty;
        double temp2=double.parse(temp[9].toString().trim())/tempQty;
        double temp3=temp2-temp1;
        itemTaxableList.add(temp3);
        itemTaxTotalList.add(temp2);
    }
      itemTaxRateList.add(temp[7].toString().trim());

    }
    print('invoiceDataList1 $invoiceDataList1');
  }
  Future getVatData()async {
    invoiceNoList=[];
    dateList=[];
    customerNameList=[];
    vatNoList=[];
    totalList=[];
    taxAmt5List=[];
    taxableAmt5List=[];
    taxTotal5List=[];
    exemptList=[];
    typeList=[];
    netTotal1=0;netTotal2=0;  taxable5total=0;taxable5total2=0;
    tax5Total=0;tax5Total2=0;netTaxTotal=0;netTaxTotal2=0;
    exemptTotal1=0;exemptTotal2=0;
    List vatDataList1=[];
      List vatDataList2=[];
      if(selectedTaxType=='Both'){
        vatDataList1=await getReports('vat_report',fromDate.toString(),toDate.toString(),'Input Tax');
        vatDataList2=await getReports('vat_report',fromDate.toString(),toDate.toString(),'Output Tax');
        for(int i=0;i<vatDataList1.length;i++){
          List eachOrderSplit=vatDataList1[i].toString().split(',');
          invoiceNoList.add(eachOrderSplit[1]);
          dateList.add(eachOrderSplit[2]);
          customerNameList.add(eachOrderSplit[3]);
          vatNoList.add(eachOrderSplit[4]);
          totalList.add(double.parse(eachOrderSplit[5]));
          taxableAmt5List.add(double.parse(eachOrderSplit[6]));
          taxAmt5List.add(double.parse(eachOrderSplit[7]));
          taxTotal5List.add(double.parse(eachOrderSplit[8]));
          exemptList.add(double.parse(eachOrderSplit[9]));
          String tempType=eachOrderSplit[10];
          tempType=tempType.substring(0,tempType.length-1);
          typeList.add(tempType);
          netTotal1+=totalList[i];
          taxable5total+=taxableAmt5List[i];
          tax5Total+=taxAmt5List[i];
          netTaxTotal+=taxTotal5List[i];
          exemptTotal1+=exemptList[i];
        }
        invoiceNoList.add('');
        dateList.add('');
        customerNameList.add('');
        vatNoList.add('');
        totalList.add(netTotal1);
        taxableAmt5List.add(taxable5total);
        taxAmt5List.add(tax5Total);
        taxTotal5List.add(tax5Total);
        exemptList.add(exemptTotal1);
        typeList.add('');

        ///////
        invoiceNoList2=[];
        dateList2=[];
        customerNameList2=[];
        vatNoList2=[];
        totalList2=[];
        taxAmt5List2=[];
        taxableAmt5List2=[];
        taxTotal5List2=[];
        exemptList2=[];
        typeList2=[];
        for(int i=0;i<vatDataList2.length;i++){
          List eachOrderSplit=vatDataList2[i].toString().split(',');
          invoiceNoList2.add(eachOrderSplit[1]);
          dateList2.add(eachOrderSplit[2]);
          customerNameList2.add(eachOrderSplit[3]);
          vatNoList2.add(eachOrderSplit[4]);
          totalList2.add(double.parse(eachOrderSplit[5]));
          taxableAmt5List2.add(double.parse(eachOrderSplit[6]));
          taxAmt5List2.add(double.parse(eachOrderSplit[7]));
          taxTotal5List2.add(double.parse(eachOrderSplit[8]));
          exemptList2.add(double.parse(eachOrderSplit[9]));
          String tempType=eachOrderSplit[10];
          tempType=tempType.substring(0,tempType.length-1);
          typeList2.add(tempType);
          netTotal2+=totalList2[i];
          taxable5total2+=taxableAmt5List2[i];
          tax5Total2+=taxAmt5List2[i];
          netTaxTotal2+=taxTotal5List2[i];
          exemptTotal2+=exemptList2[i];
        }
        invoiceNoList2.add('');
        dateList2.add('');
        customerNameList2.add('');
        vatNoList2.add('');
        totalList2.add(netTotal2);
        taxableAmt5List2.add(taxable5total2);
        taxAmt5List2.add(tax5Total2);
        taxTotal5List2.add(netTaxTotal2);
        exemptList2.add(exemptTotal2);
        typeList2.add('');
        diff=tax5Total-tax5Total2;
        return;
      }
      else{
        vatDataList1=await getReports('vat_report',fromDate.toString(),toDate.toString(),selectedTaxType);
        print('vatDataList1  $vatDataList1');
        for(int i=0;i<vatDataList1.length;i++){
          List eachOrderSplit=vatDataList1[i].toString().split(',');
          invoiceNoList.add(eachOrderSplit[1]);
          dateList.add(eachOrderSplit[2]);
          customerNameList.add(eachOrderSplit[3]);
          vatNoList.add(eachOrderSplit[4]);
          totalList.add(double.parse(eachOrderSplit[5]));
          taxableAmt5List.add(double.parse(eachOrderSplit[6]));
          taxAmt5List.add(double.parse(eachOrderSplit[7]));
          taxTotal5List.add(double.parse(eachOrderSplit[8]));
          exemptList.add(double.parse(eachOrderSplit[9]));
          String tempType=eachOrderSplit[10];
          tempType=tempType.substring(0,tempType.length-1);
          typeList.add(tempType);
          netTotal1+=totalList[i];
          taxable5total+=taxableAmt5List[i];
          tax5Total+=taxAmt5List[i];
          netTaxTotal+=taxTotal5List[i];
          exemptTotal1+=exemptList[i];
        }
        invoiceNoList.add('');
        dateList.add('');
        customerNameList.add('');
        vatNoList.add('');
        totalList.add(netTotal1);
        taxableAmt5List.add(taxable5total);
        taxAmt5List.add(tax5Total);
        taxTotal5List.add(netTaxTotal);
        exemptList.add(exemptTotal1);
        typeList.add('');
        return;
      }
}}
