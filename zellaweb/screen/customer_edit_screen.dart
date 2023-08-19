import 'package:flutter/material.dart';
import 'package:restaurant_app/components/all_file.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/constants.dart';
import 'package:restaurant_app/screen/add_customer.dart';
List<TextEditingController> customerNameEditController=[];
List<TextEditingController> addressEditController=[];
List<TextEditingController> mobileNoEditController=[];
List<TextEditingController> vatNoEditController=[];
List<TextEditingController> balanceEditController=[];
List<String> priceListEdit=[];
class EditCustomer extends StatefulWidget {
  static const String id='customer_edit';
  @override
  _EditCustomerState createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {

  @override
  Widget build(BuildContext context) {

    return SafeArea(

      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kGreenColor,
        ),
        body: Container(
          child: ListView(
            children: [
              DataTable(
                columns: [
                  DataColumn(label: Text('Customer Name',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                    ),
                  ),
                  ),
                  DataColumn(label: Text('Address',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                    ),
                  ),
                  ),
                  DataColumn(label: Text('Mobile No',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                    ),
                  ),
                    numeric: true,
                  ),
                  DataColumn(label: Text('VAT/GST NO',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                    ),
                  ),
                  ),
                  DataColumn(label: Text('Price',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                    ),
                  ),
                    numeric: true,
                  ),
                  DataColumn(label: Text('Balance',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                    ),
                  ),
                    numeric: true,
                  ),
                  DataColumn(label: Text('',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                    ),
                  ),
                  ),
                ],
                rows: List.generate(customerNameEditController.length, (index) => DataRow(cells: [
                  DataCell(
                    TextFormField(
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                      ),
                      controller: customerNameEditController[index],
                    ),
                    showEditIcon: true,
                  ),
                  DataCell(
                    TextButton(
                      onPressed: (){
                        showDialog(context: context, builder: (context) => Dialog(
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            width: MediaQuery.of(context).size.width/2,
                            child: TextFormField(
                              maxLines: 6,
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).textScaleFactor*20,
                              ),
                              controller: addressEditController[index],
                            ),
                          ),
                        )
                        );
                      },

                      child: Text(
                        ' ${addressEditController[index].text.substring(0,4)}..',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                        ),
                      ),
                    ),
                  ),
                  DataCell( TextFormField(
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                    ),
                    controller: mobileNoEditController[index],
                  ),
                    showEditIcon: true,
                  ),
                  DataCell( TextFormField(
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                    ),
                    controller: vatNoEditController[index],
                  ),
                    showEditIcon: true,
                  ),
                  DataCell(
                    DropdownButton(
                      value: priceListEdit[index],
                      // Not necessary for Option 1
                      items: priceList.map((String val) {
                        return DropdownMenuItem(
                          child: new Text(
                            val.toString(),
                            style: TextStyle(
                              fontSize: MediaQuery.of(context)
                                  .textScaleFactor *
                                  20,
                            ),
                          ),
                          value: val,
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          priceListEdit[index] = newValue;
                        });
                      },
                    ),
                  ),
                  DataCell( TextFormField(
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                    ),
                    controller: balanceEditController[index],
                  ),
                    showEditIcon: true,
                  ),
                  DataCell(TextButton(onPressed: ()async{
                    String temp='${customerNameEditController[index].text}:${addressEditController[index].text}:${mobileNoEditController[index].text}:${vatNoEditController[index].text}:${priceListEdit[index]}:${balanceEditController[index].text}';
                    customerFirstSplit[index]=temp;
                    await updateData(temp, 'customer_data', index+1,'');
                    print(customerFirstSplit);
                    // saveFile(customerFirstSplit);
                  }, child: Container(
                    decoration: BoxDecoration(
                      color: kGreenColor,
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: Text('SAVE',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.5,
                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                      ),
                    ),
                  )))
                ])),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
Future<void> displayCustomerData() async {
  await getData('customer_data');
  customerNameEditController=[];
  addressEditController=[];
  mobileNoEditController=[];
  priceListEdit=[];
  vatNoEditController=[];
  balanceEditController=[];
  for(int i=0;i<customerFirstSplit.length;i++){
    print('customerFirstSplit $customerFirstSplit');
    List tempCustomer=customerFirstSplit[i].split(':');
    customerNameEditController.add(TextEditingController(text: tempCustomer[0].toString().trim()));
    addressEditController.add(TextEditingController(text:tempCustomer[1].toString().trim() ));
    mobileNoEditController.add(TextEditingController(text:tempCustomer[2].toString().trim()));
    vatNoEditController.add(TextEditingController(text: tempCustomer[3].toString().trim()));
    balanceEditController.add(TextEditingController(text: tempCustomer[5].toString().trim()));
    priceListEdit.add(tempCustomer[4].toString().trim());
  }
  print(customerNameEditController);
}
void saveFile(List temp){
  String tempBody=temp.toString();
  tempBody=tempBody.substring(1, tempBody.length - 1).replaceAll(',', '~');
  tempBody = tempBody.replaceAll(new RegExp(r"\s+"), " ");
  tempBody+='~';
  // allFile.editFile(tempBody, 'customer');
  // print(tempBody);
  // allFile.readFile('customer');
}