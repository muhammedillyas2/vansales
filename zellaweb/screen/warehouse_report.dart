import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/components/firebase_con.dart';
import 'package:restaurant_app/screen/login_page.dart';

import '../constants.dart';
class WarehouseReport extends StatefulWidget {
static const String id='warehouse_report';
  @override
  _WarehouseReportState createState() => _WarehouseReportState();
}

class _WarehouseReportState extends State<WarehouseReport> {
  @override
  Widget build(BuildContext context) {
    TextStyle kStyle=TextStyle(
      fontSize: MediaQuery.of(context).textScaleFactor*20,
    );
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text('stock REPORT',style: TextStyle(
            fontFamily: 'BebasNeue',
            letterSpacing: 2.0
        ),),
        titleSpacing: 0.0,
        backgroundColor: kGreenColor,
        automaticallyImplyLeading: true,
      ),
      body: Scrollbar(
        thickness: 15.0,
        showTrackOnHover: true,
        isAlwaysShown: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: StreamBuilder( stream: firebaseFirestore.collection('warehouse').doc(currentWarehouse).snapshots(),
                builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot){
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  Map<String, dynamic> data = snapshot.data.data();
                  List tempQty=data.values.toList();
                  List tempItem=data.keys.toList();
                  return DataTable(columns: [
                    DataColumn(label: Text('ItemName', style: kStyle )),
                    DataColumn(label: Text('Quantity', style: kStyle)),
                  ], rows:List.generate(data.length, (index) => DataRow(cells: [
                    DataCell(Text(tempItem[index],
                      style:kStyle,)),
                    DataCell(Text(tempQty[index].toString(),
                      style:kStyle,)),
                  ]))
                  );
                }),
          ),
        ),
      ),
    ));
  }
}
