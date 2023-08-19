import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/constants.dart';
import 'uom_edit_screen.dart';
import 'product_edit_screen.dart';
import 'customer_edit_screen.dart';
import 'category_edit_screen.dart';
class EditScreen extends StatefulWidget {
  static const String id='edit';
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  //List masterList=['UOM','Category','Customer','Item'];
  List masterList=['Item'];
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
          margin: EdgeInsets.only(top:MediaQuery.of(context).size.height/4),
          width: MediaQuery.of(context).size.width/2,
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                crossAxisCount: 5,
              ),
              scrollDirection:Axis.vertical ,
              itemCount: masterList.length,
              itemBuilder: (context,index){
                return GestureDetector(onTap: ()async{
                  // if(index==0) {
                  //   getUomData();
                  //   Navigator.pushNamed(context, EditUom.id);
                  // }
                  // else if(index==1)
                  //  {
                  //    displayCategoryData();
                  //    Navigator.pushNamed(context, EditCategory.id);
                  //  }
                  //  if(index==2) {
                  //   displayCustomerData();
                  //   Navigator.pushNamed(context, EditCustomer.id);
                  // }
                  if(index==0) {
                    await getProductData();
                    Navigator.pushNamed(context, EditItems.id);
                  }
                }, child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/7,
                  height:  MediaQuery.of(context).size.height/6,
                  decoration: BoxDecoration(
                      color: kGreenColor,
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: AutoSizeText(masterList[index],
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
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
