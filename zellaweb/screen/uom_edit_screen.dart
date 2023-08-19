import 'package:flutter/material.dart';
import 'package:restaurant_app/components/all_file.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/constants.dart';
import 'package:restaurant_app/screen/add_product.dart';
List<TextEditingController> uomNameEditController=[];
List<TextEditingController> decimalsEditController=[];
class EditUom extends StatefulWidget {
  static const String id='edit_uom';
  @override
  _EditUomState createState() => _EditUomState();
}

class _EditUomState extends State<EditUom> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kLightBlueColor,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width/2,
          child: ListView(
            children: [
              DataTable(

                columns: [
                  DataColumn(label: Text('UOM Name',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                    ),
                  ),
                  ),
                  DataColumn(label: Text('No of Decimals',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                    ),
                  ),
                    numeric: true,
                  ),
                  DataColumn(label: Text('',
                  ),
                  ),
                ],
                rows: List.generate(uomNameEditController.length, (index) => DataRow(cells: [
                  DataCell(
                    TextFormField(
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                      ),
                      controller: uomNameEditController[index],
                    ),
                    showEditIcon: true,
                  ),
                  DataCell( TextFormField(
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                    ),
                    controller: decimalsEditController[index],
                  ),
                    showEditIcon: true,
                  ),
                  DataCell(TextButton(onPressed: () async {
                    String temp='${uomNameEditController[index].text}:${decimalsEditController[index].text}';
                    //  await updateData(temp,'uom_data',index+1);
                    await updateData(temp,'uom_data',index+1,'');
                    // uomEditSplit[index]=temp;
                    // print(uomEditSplit);
                    // saveFile(uomEditSplit);
                  }, child: Container(
                    decoration: BoxDecoration(
                      color: kLightBlueColor,
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
void saveFile(List temp){
  String tempBody=temp.toString();
  tempBody=tempBody.substring(1, tempBody.length - 1).replaceAll(',', '~');
  tempBody = tempBody.replaceAll(new RegExp(r"\s+"), " ");
  tempBody+='~';
  // allFile.editFile(tempBody, 'uom');
  // print(tempBody);
  // allFile.readFile('uom');
}
Future getUomData()async{
  await getData('uom_data');
  uomNameEditController=[];
  decimalsEditController=[];
print(uomList);
  // String contents=await allFile.readFile('uom');
  // uomEditSplit=contents.split('~');
  // uomEditSplit.removeLast();
  for(int i=0;i<uomEditSplit.length;i++){
    List contentsSplit2=uomEditSplit[i].toString().split(',');
    uomNameEditController.add(TextEditingController(
      text: contentsSplit2[1].toString().trim(),
    ));
    decimalsEditController.add(TextEditingController(
      text: contentsSplit2[2].toString().trim(),
    ));
  }
  return;
}