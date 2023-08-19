import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/components/all_file.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/constants.dart';
import 'package:restaurant_app/screen/add_customer.dart';
import 'package:restaurant_app/screen/add_product.dart';
import 'package:restaurant_app/screen/category_screen.dart';
import 'package:restaurant_app/screen/customer_screen.dart';
import 'package:restaurant_app/screen/expense_head.dart';
import 'package:restaurant_app/screen/tax_Screen.dart';
import 'package:restaurant_app/screen/user_management.dart';
import 'edit_screen.dart';
import 'package:restaurant_app/screen/uom_screen.dart';
import 'add_vendor.dart';
import 'organisation_screen.dart';
import 'sequence_manager.dart';
import 'modifier.dart';
class AdministrationScreen extends StatefulWidget {
    static const String id='admin';
    @override
    _AdministrationScreenState createState() => _AdministrationScreenState();
}

class _AdministrationScreenState extends State<AdministrationScreen> {
   // List masterList=['Company','User Management','UOM','Category','Customer','Vendor','Item','Sequence Manager','Modifier','Expense Head','Edit','Tax'];
    List masterList=['Company','User Management','UOM','Category','Customer','Vendor','Item','Sequence Manager','Expense Head','Edit','Tax','Modifier'];
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('POSIMATE',style: TextStyle(
                    fontFamily: 'BebasNeue',
                    letterSpacing: 2.0
                ),),
                titleSpacing: 0.0,
                backgroundColor: kGreenColor,
            ),
            body: Center(
                child: Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/4),
                    width: MediaQuery.of(context).size.width/2,
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                            crossAxisCount: 5,
                        ),
                        scrollDirection:Axis.vertical ,
                        itemCount: masterList.length,
                        itemBuilder: (context,index){
                            return GestureDetector(onTap: () async {
                                if(index==0) {
                                    getOrganisationData();
                                    Navigator.pushNamed(context, OrganisationScreen.id);
                                }
                                if(index==1) {

                                    Navigator.pushNamed(context, AddUser.id);
                                }
                                if(index==2)
                                    Navigator.pushNamed(context,UomScreen.id);
                                else if(index==3)
                                    Navigator.pushNamed(context, CategoryScreen.id);
                                else if(index==4)
                                    Navigator.pushNamed(context, AddCustomer.id);
                                else if(index==5)
                                    Navigator.pushNamed(context, AddVendor.id);
                                else if(index==6)
                                    Navigator.pushNamed(context, AddProduct.id);
                                else if(index==7) {
                                  await getSequenceData();
                                    Navigator.pushNamed(context, SequenceManager.id);
                                }
                                else if(index==11)
                                    Navigator.pushNamed(context, AddModifier.id);
                                else if(index==8)
                                  {await getData('expense_head');
                                      Navigator.pushNamed(context, ExpenseHead.id);}
                                else if(index==9)
                                    Navigator.pushNamed(context, EditScreen.id);
                                else if(index==10)
                                    Navigator.pushNamed(context, TaxScreen.id);

                            }, child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: kGreenColor,
                                    borderRadius: BorderRadius.circular(10.0)
                                ),
                                padding: EdgeInsets.all(8.0),
                                child: AutoSizeText(masterList[index],
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: MediaQuery.of(context).textScaleFactor*18,
                                        color: kItemContainer,
                                    ),
                                ),
                            ),);
                        }),
                ),
            ),
        );
    }
}
