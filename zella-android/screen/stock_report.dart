import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/components/firebase_con.dart';

import '../constants.dart';
class StockReport extends StatefulWidget {
  static const String id='stock_report';
  @override
  _StockReportState createState() => _StockReportState();
}
List<String> itemNameList=[];
List<String> quantityList=[];
List<String> costPriceList=[];
List<String> stockValueList=[];
class _StockReportState extends State<StockReport> {

  @override
  Widget build(BuildContext context) {
    TextStyle kStyle=TextStyle(
      fontSize: MediaQuery.of(context).textScaleFactor*20,
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('STOCK REPORT',style: TextStyle(
              fontFamily: 'BebasNeue',
              letterSpacing: 2.0
          ),),
          titleSpacing: 0.0,
          backgroundColor: kGreenColor,
        ),
        body: Scrollbar(
          thickness: 15.0,
          showTrackOnHover: true,
          isAlwaysShown: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: StreamBuilder( stream: firebaseFirestore.collection('stock').snapshots(),
                  builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return DataTable(columns: [
                      DataColumn(label: Text('ItemName', style: kStyle )),
                      DataColumn(label: Text('Quantity', style: kStyle)),
                      DataColumn(label: Text('CostPrice', style: kStyle)),
                      DataColumn(label: Text('Value', style: kStyle)),
                    ], rows: snapshot.data.docs.map((document) {
                      return DataRow(cells: [
                        DataCell(TextButton(
                            onPressed: () async {
                              List documentList=[];
                              for(int i=0;i<warehouseList.length;i++){
                                bool exist=await checkIfFieldExists(warehouseList[i], 'warehouse', document['item']);
                                if(exist){
                                  DocumentSnapshot snapshot = await firebaseFirestore.collection('warehouse').doc(warehouseList[i]).get();
                                  documentList.add(snapshot.get(document['item']));
                                }
                                else{
                                  documentList.add(0);
                                }
                              }
                              print(documentList);
                              showDialog(context: context, builder: (context)=>Center(
                                child: SingleChildScrollView(
                                  child: Dialog(
                                    child: DataTable(
                                      columns: [  DataColumn(label: Text('Warehouse',
                                        style: kStyle,
                                      )),
                                        DataColumn(label: Text('Qty',
                                          textAlign: TextAlign.center,
                                          style: kStyle,
                                        )),],
                                      rows:List.generate(warehouseList.length, (index) {
                                        return DataRow(cells: [
                                          DataCell(Text(warehouseList[index],
                                            style:kStyle,)),
                                          DataCell(Text(documentList[index].toString(),
                                            style:kStyle,)),
                                        ]);
                                      }) ,
                                    ),
                                  ),
                                ),
                              ));
                            },
                            child: Text(document['item'],style: kStyle))),
                        DataCell(Text(double.parse(document['qty']).toStringAsFixed(3),style: kStyle)),
                        DataCell(Text(document['cost'],style: kStyle)),
                        DataCell(Text(document['value'],style: kStyle)),
                      ]);
                    }).toList());
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
void getStockList(){
  itemNameList=[];
  quantityList=[];
  costPriceList=[];
  stockValueList=[];
  print('stock data $stockList');
  for(int i=0;i<stockList.length;i++){
    List temp=stockList[i].toString().split(',');
    itemNameList.add(temp[0].toString().trim());
    quantityList.add(temp[1].toString().trim());
    costPriceList.add(temp[2].toString().trim());
    stockValueList.add(temp[3].toString().trim());
  }
}