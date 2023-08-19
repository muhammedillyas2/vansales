import 'package:flutter/material.dart';
import 'package:restaurant_app/components/all_file.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/screen/purchase_screen.dart';

import '../constants.dart';
String selectedVendorPrice='Price 1';
List<String> priceList=['Price 1','Price 2','Price 3'];

String vendorName='',vendorAddress='',vendorMobile='',vendorVat='',vendorBalance='';
class AddVendor extends StatefulWidget {
    static const String id='vendor';
    @override
    _AddVendorState createState() => _AddVendorState();
}

class _AddVendorState extends State<AddVendor> {
    TextEditingController nameController=TextEditingController();
    TextEditingController addressController=TextEditingController();
    TextEditingController mobileController=TextEditingController();
    TextEditingController vatController=TextEditingController();
    TextEditingController vendorOpeningBalance=TextEditingController();
    @override
    Widget build(BuildContext context) {
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
                body: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                        width: MediaQuery.of(context).size.width/2,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text('Vendor Name',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                ),
                                            ),
                                            TextField(
                                                controller: nameController,
                                                onChanged: (value){
                                                    vendorName=value;
                                                },
                                                keyboardType: TextInputType.name,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: 'Enter Vendor Name'
                                                ),
                                            ),
                                        ],
                                    ),
                                ),

                                Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text('Address',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                ),
                                            ),
                                            TextField(
                                                controller: addressController,
                                                onChanged: (value){
                                                    vendorAddress=value;
                                                },
                                                keyboardType: TextInputType.name,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: 'Enter Vendor Address'
                                                ),
                                            ),
                                        ],
                                    ),
                                ),
                                Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text('Mobile No',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                ),),
                                            TextField(
                                                controller: mobileController,
                                                onChanged: (value){
                                                    vendorMobile=value;
                                                },
                                                keyboardType: TextInputType.name,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: 'Enter Vendor Mobile Number'
                                                ),
                                            ),
                                        ],
                                    ),
                                ),
                                Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text('VAT/GST NO',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                ),),
                                            TextField(
                                                controller: vatController,
                                                onChanged: (value){
                                                    vendorVat=value;
                                                },
                                                keyboardType: TextInputType.name,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                ),
                                            ),
                                        ],
                                    ),
                                ),
                                Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text('Opening Balance',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                ),),
                                            TextField(
                                                controller: vendorOpeningBalance,
                                                onChanged: (value){
                                                    vendorBalance=value;
                                                },
                                                keyboardType: TextInputType.name,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                ),
                                            ),
                                        ],
                                    ),
                                ),
                                Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text('Price ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                ),),
                                            DropdownButton(
                                                value: selectedVendorPrice, // Not necessary for Option 1
                                                items: priceList.map((String val) {
                                                    return DropdownMenuItem(
                                                        child: new Text(val.toString()),
                                                        value: val,
                                                    );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                    setState(() {
                                                        selectedVendorPrice = newValue;
                                                    });
                                                },
                                            ),
                                        ],
                                    ),
                                ),
                                TextButton(onPressed: ()async{
                                    if(vendorName==''|| vendorAddress=='' || vendorMobile=='' ||vendorVat==''){
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                title: Text("Error"),
                                                content: Text("Fill all the fields"),
                                                actions: <Widget>[
                                                    // usually buttons at the bottom of the dialog
                                                    new TextButton(
                                                        child: new Text("Close"),
                                                        onPressed: () {
                                                            Navigator.of(context).pop();
                                                        },
                                                    ),
                                                ],
                                            )
                                        );
                                    }
                                    else{
                                        String inside='not';
                                        for(int i=0;i<vendorList.length;i++){
                                            if(vendorList[i].toLowerCase() == vendorName.toLowerCase()){
                                                inside='contains';
                                                showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                        title: Text("Error"),
                                                        content: Text("Vendor name Exists"),
                                                        actions: <Widget>[
                                                            // usually buttons at the bottom of the dialog
                                                            new TextButton(
                                                                child: new Text("Close"),
                                                                onPressed: () {
                                                                    Navigator.of(context).pop();
                                                                },
                                                            ),
                                                        ],
                                                    )
                                                );
                                            }
                                        }
                                        if(inside=='not'){
                                            setState(() {
                                                vendorList.isEmpty ? selectedVendor=vendorName:null;
                                                vendorList.isEmpty ? selectedVendorPriceList=selectedVendorPrice:null;
                                                vendorList.add(vendorName.trim());
                                                vendorPriceList.add(selectedVendorPrice);
                                                vendorBalanceList.add(vendorBalance);
                                                print(vendorList);
                                                print(selectedVendor);
                                                print(vendorPriceList);
                                            });
                                            String body='$vendorName:$vendorAddress:$vendorMobile:$vendorVat:$selectedVendorPrice:$vendorBalance~';
                                            await insertData(body.substring(0,body.length-1),'vendor_data');
                                            vendorAddress='';
                                            vendorName='';
                                            vendorVat='';
                                            vendorBalance='';
                                            nameController.clear();
                                            addressController.clear();
                                            mobileController.clear();
                                            vatController.clear();
                                        }
                                    }
                                }, child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        color: kGreenColor,
                                        borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Text('SUBMIT',
                                        style: TextStyle(
                                            letterSpacing: 1.5,
                                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                                            color: Colors.white
                                        ),
                                    ),
                                ))
                            ],
                        ),
                    ),
                ),
            ),
        );
    }
}
