import 'package:flutter/material.dart';

import 'package:restaurant_app/components/database_con.dart';

import '../constants.dart';
List<String> businessTypes=['Retail','WholeSale','Restaurant'];
String selectedBusiness='Retail';
String selectedScreen='';
String orgName,orgAddress,orgVatNo,orgMobileNo,currency,symbol,orgDecimals;
TextEditingController orgNameController=TextEditingController();
TextEditingController orgAddressController=TextEditingController();
TextEditingController orgVatNoController=TextEditingController();
TextEditingController orgMobileNoController=TextEditingController();
TextEditingController currencyController=TextEditingController();
TextEditingController symbolController=TextEditingController();
TextEditingController orgDecimalsController=TextEditingController();
class OrganisationScreen extends StatefulWidget {
  static const String id='organisation';
  @override
  _OrganisationScreenState createState() => _OrganisationScreenState();
}

class _OrganisationScreenState extends State<OrganisationScreen> {
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
                      Text('Organisation Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                        ),
                      ),
                      TextField(
                        controller: orgNameController,
                        onChanged: (value){
                          orgName=value;
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter Organisation Name'
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
                      Text('Type of Business ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                        ),),
                      DropdownButton(
                        value:selectedBusiness.trim() , // Not necessary for Option 1
                        items: businessTypes.map((String val) {
                          return DropdownMenuItem(
                            child: new Text(val.toString()),
                            value: val,
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedBusiness = newValue;
                          });
                        },
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
                        controller: orgAddressController,
                        onChanged: (value){
                          orgAddress=value;
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter Organisation Address'
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
                        controller: orgMobileNoController,
                        onChanged: (value){
                          orgMobileNo=value;
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter Organisation Mobile Number'
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
                        controller: orgVatNoController,
                        onChanged: (value){
                          orgVatNo=value;
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
                      Text('Currency',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                        ),),
                      TextField(
                        controller: currencyController,
                        onChanged: (value){
                          currency=value;
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
                      Text('Symbol',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                        ),),
                      TextField(
                        controller: symbolController,
                        onChanged: (value){
                          symbol=value;
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
                      Text('Decimals',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                        ),),
                      TextField(
                        controller: orgDecimalsController,
                        onChanged: (value){
                          orgDecimals=value;
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(onPressed: ()async{
                  // database('organisation');
                  String body='$orgName:$selectedBusiness:$orgAddress:$orgMobileNo:$orgVatNo:$currency:$symbol:$orgDecimals';
                  await insertData(body,'companyDetails');
                  decimals=int.parse(orgDecimals);
                  // await getData('companyDetails');
                 // getOrganisationData();
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
void getOrganisationData(){
  List  tempData= [];
  try {
    tempData = organisationData.split(':');
    print('temp_data $tempData');
    orgNameController.text = orgName = tempData[0].toString().trim();
    selectedBusiness = tempData[1].toString().trim();
    print('selectedBusiness $selectedBusiness');
    orgAddressController.text = orgAddress = tempData[2].toString().trim();
    orgMobileNoController.text = orgMobileNo = tempData[3].toString().trim();
    orgVatNoController.text = orgVatNo = tempData[4].toString().trim();
    currencyController.text = currency = tempData[5].toString().trim();
    symbolController.text = symbol = tempData[6].toString().trim();
    orgDecimalsController.text = orgDecimals = tempData[7].toString().trim();
  }catch(Exception ){}
}