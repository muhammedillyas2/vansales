import 'package:flutter/material.dart';
import 'package:restaurant_app/components/all_file.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/constants.dart';
import 'package:restaurant_app/screen/pos_screen.dart';
String selectedPrice='Price 1';
List<String> priceList=['Price 1','Price 2','Price 3'];
String customerName='',address='',mobile='',vat='',customerBalance='';
class AddCustomer extends StatefulWidget {
    static const String id = 'add_customer';
    @override
    _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer>
{

    TextEditingController nameController=TextEditingController();
    TextEditingController addressController=TextEditingController();
    TextEditingController mobileController=TextEditingController();
    TextEditingController vatController=TextEditingController();
    TextEditingController customerOpeningBalance=TextEditingController();
    @override
    Widget build(BuildContext context) {
        return SafeArea(
            child: Scaffold(
                appBar: AppBar(
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
                                            Text('Customer Name',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                ),
                                            ),
                                            TextField(
                                                controller: nameController,
                                                onChanged: (value){
                                                    customerName=value;
                                                },
                                                keyboardType: TextInputType.name,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: 'Enter Customer Name'
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
                                                    address=value;
                                                },
                                                keyboardType: TextInputType.name,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: 'Enter your Address'
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
                                                    mobile=value;
                                                },
                                                keyboardType: TextInputType.name,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: 'Enter Customer Mobile Number'
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
                                                    vat=value;
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
                                                controller: customerOpeningBalance,
                                                onChanged: (value){
                                                    customerBalance=value;
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
                                                value: selectedPrice, // Not necessary for Option 1
                                                items: priceList.map((String val) {
                                                    return DropdownMenuItem(
                                                        child: new Text(val.toString()),
                                                        value: val,
                                                    );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                    setState(() {
                                                        selectedPrice = newValue;
                                                    });
                                                },
                                            ),
                                        ],
                                    ),
                                ),
                                TextButton(onPressed: ()async{
                                    if(customerName==''|| address=='' || mobile==''){
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
                                        for(int i=0;i<customerList.length;i++){
                                            if(customerList[i].toLowerCase() == customerName.toLowerCase()){
                                                inside='contains';
                                                showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                        title: Text("Error"),
                                                        content: Text("Customer name Exists"),
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
                                        if(inside == 'not'){
                                            setState(() {
                                                customerList.isEmpty ? selectedCustomer=customerName:null;
                                                customerList.isEmpty ? selectedPriceList=selectedPrice:null;
                                                customerList.add(customerName.trim());
                                                customerPriceList.add(selectedPrice);
                                                customerBalanceList.add(customerBalance);
                                            });
                                            String body='$customerName:$address:$mobile:$vat:$selectedPrice:$customerBalance~';
                                            await insertData(body.substring(0,body.length-1),'customer_data');
                                            customerName='';
                                            address='';
                                            mobile='';
                                            vat='';
                                            customerBalance='';
                                            // await  allFile.writeFile(body, 'customer');
                                            customerOpeningBalance.clear();
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
