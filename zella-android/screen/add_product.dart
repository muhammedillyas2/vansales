
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restaurant_app/components/all_file.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:file_picker/file_picker.dart';
import 'package:restaurant_app/constants.dart';
int addUom=0;final validCharacters = RegExp(r'^[a-zA-Z0-9\@ ]+$');
bool ite = false;
String selectedCategory;
String productImage;
List<String> selectedUomList=[];
List<String> sp=[];
List<String> pp=[];
List<String> barcode=[];
List<String> conversion=[];

String itemName='',itemCode='',barcodeType='',tax,discount='';
enum selectedMode { Normal,Weighted}
selectedMode _character = selectedMode.Normal;
class AddProduct extends StatefulWidget {
  static const String id = 'add_product';
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();
    print(directory.path);
    return directory.path;
  }

  TextEditingController nameController=TextEditingController();
  TextEditingController codeController=TextEditingController();
  TextEditingController barcodeController=TextEditingController();
  TextEditingController priceController=TextEditingController();
  TextEditingController costPriceController=TextEditingController();
  TextEditingController taxController=TextEditingController();
  TextEditingController discountController=TextEditingController();
  Set<String> lastFiles;
  @override
  void initState() {
    // TODO: implement initState
    FilePickerCross.listInternalFiles()
        .then((value) => setState(() => lastFiles = value.toSet()));
    productCategoryF.isNotEmpty?selectedCategory=productCategoryF[0]:selectedCategory='';
    taxNameList.isNotEmpty?tax=taxNameList[0]:tax='';
    super.initState();
    sp=[];
    pp=[];
  }
  @override
  Widget build(BuildContext context) {
    double boxWidth=MediaQuery.of(context).size.width/2;

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
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: boxWidth,
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Item Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                        ),
                      ),
                      TextField(
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                        ),
                        controller: nameController,
                        onChanged: (value) {
                        if(value.contains(','))
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Error"),
                                content: Text("Remove , from item name"),
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
                          itemName=value;
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
                  width: boxWidth,
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Category ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                        ),
                      ),
                      Row(
                        children: [
                          DropdownButton(
                            value:
                            selectedCategory, // Not necessary for Option 1
                            items: productCategoryF.map((String val) {
                              return DropdownMenuItem(
                                child: new Text(val.toString(),style: TextStyle(
                                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                                ),),
                                value: val,
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedCategory = newValue;
                              });
                            },
                          ),
                          // MaterialButton(
                          //   onPressed: () {
                          //     showDialog(
                          //       context: context, builder: (context) => Dialog(
                          //       child: SingleChildScrollView(
                          //         child: Container(
                          //           padding: EdgeInsets.all(10.0),
                          //           child: Column(
                          //             // scrollDirection: Axis.vertical,
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             mainAxisSize: MainAxisSize.min,
                          //             children: <Widget>[
                          //               Container(
                          //                 width: MediaQuery.of(context)
                          //                     .size
                          //                     .width /
                          //                     2,
                          //                 padding: EdgeInsets.all(8.0),
                          //                 child: Column(
                          //                   crossAxisAlignment:
                          //                   CrossAxisAlignment.start,
                          //                   children: [
                          //                     Text(
                          //                       'Category Name',
                          //                       style: TextStyle(
                          //                         fontWeight: FontWeight.bold,
                          //                         fontSize: MediaQuery.of(context).textScaleFactor*20,
                          //                       ),
                          //                     ),
                          //                     TextField(
                          //                       style: TextStyle(
                          //                         fontSize: MediaQuery.of(context).textScaleFactor*20,
                          //                       ),
                          //                       onChanged: (value) {},
                          //                       keyboardType:
                          //                       TextInputType.name,
                          //                       decoration: InputDecoration(
                          //                         border:
                          //                         OutlineInputBorder(),
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //               Container(
                          //                 width: MediaQuery.of(context)
                          //                     .size
                          //                     .width /
                          //                     2,
                          //                 padding: EdgeInsets.all(8.0),
                          //                 child: Column(
                          //                   crossAxisAlignment:
                          //                   CrossAxisAlignment.start,
                          //                   children: [
                          //                     Text(
                          //                       'Sequence',
                          //                       style: TextStyle(
                          //                         fontWeight: FontWeight.bold,
                          //                         fontSize: MediaQuery.of(context).textScaleFactor*20,
                          //                       ),
                          //                     ),
                          //                     TextField(
                          //                       style: TextStyle(
                          //                         fontSize: MediaQuery.of(context).textScaleFactor*20,
                          //                       ),
                          //                       onChanged: (value) {},
                          //                       keyboardType:
                          //                       TextInputType.name,
                          //                       decoration: InputDecoration(
                          //                         border:
                          //                         OutlineInputBorder(),
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //               FlatButton(
                          //                 onPressed: () {},
                          //                 child: Container(
                          //                   padding: EdgeInsets.all(8.0),
                          //                   child: Text('SAVE',style: TextStyle(
                          //                     fontSize: MediaQuery.of(context).textScaleFactor*20,
                          //                   ),),
                          //                   decoration: BoxDecoration(
                          //                     color: kBlueColor,
                          //                     borderRadius:
                          //                     BorderRadius.circular(15.0),
                          //                   ),
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //     );
                          //   },
                          //   color: kBlueColor,
                          //   textColor: Colors.white,
                          //   child: Icon(
                          //     Icons.add,
                          //     size: 24,
                          //   ),
                          //   padding: EdgeInsets.all(4),
                          //   shape: CircleBorder(),
                          // )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: boxWidth,
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Item Code',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                        ),
                      ),
                      TextField(
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                        ),
                        controller: codeController,
                        onChanged: (value) {
                          itemCode=value;
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
                  width: boxWidth,
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Image',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                        ),
                      ),
                      Visibility(child:MaterialButton(
                          onPressed: () async {
                            try {
                              FilePickerCross myFile = await FilePickerCross.importFromStorage(
                                  type: FileTypeCross.any,       // Available: `any`, `audio`, `image`, `video`, `custom`. Note: not available using FDE
                                  fileExtension: 'jpg'     // Only if FileTypeCross.custom . May be any file extension like `dot`, `ppt,pptx,odp`
                              );
                              productImage=myFile.toBase64();
                            }
                            catch(e){
                              print('e $e');
                              final path = await _localPath;
                              FilePickerCross myFile = await FilePickerCross.pick(
                                // Only if FileTypeCross.custom . May be any file extension like `dot`, `ppt,pptx,odp`
                              );
                              productImage=myFile.toBase64();
                              print('productImage $productImage');
                            }
                          },
                          child: Text('Add Image')) ,
                        replacement:Text('IMAGE SAVED') ,
                      )
                    ],
                  ),
                ),
                Container(
                  width: boxWidth,
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Barcode Type',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                        ),
                      ),
                      RadioListTile(
                          activeColor: kGreenColor,
                          title: Text('Normal',style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ),),
                          value: selectedMode.Normal,
                          groupValue: _character,
                          onChanged: (value){
                            setState(() {
                              _character=value;
                              barcodeType='Normal';
                            });
                          }
                      ),
                      RadioListTile(
                          activeColor: kGreenColor,
                          title: Text('Weighted',style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ),),
                          value: selectedMode.Weighted,
                          groupValue: _character,
                          onChanged: (value){
                            setState(() {
                              _character=value;
                              barcodeType='Weighted';
                            });

                          }
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'UOM ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            print(uomList);
                            if(addUom<uomList.length){
                              setState(() {
                                print('uomList $uomList');
                                addUom++;
                                selectedUomList.add(uomList[0]);
                                sp.add('0');
                                pp.add('0');
                                barcode.add('0');
                                conversion.add('1');
                                print(selectedUomList);
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            color: kGreenColor,
                            child: Text('ADD',
                              style: TextStyle(
                                letterSpacing: 2.0,
                                fontSize: MediaQuery.of(context).textScaleFactor*20,
                                color: kItemContainer,
                              ),),
                          )),
                      DataTable(

                        columns: [
                          DataColumn(label: Text('UOM',style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ),)),
                          DataColumn(label: Text('S.P',style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ),)),
                          DataColumn(label: Text('P.P',style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ),)),
                          DataColumn(label: Text('Barcode',style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ),)),
                          DataColumn(label: Text('Conversion',style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ),)),
                          DataColumn(label: Text('',style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ),)),
                        ],
                        rows:  List.generate(addUom, (index) => DataRow(

                          cells: [
                            DataCell(DropdownButton(
                              hint: Text('Select UOM',style: TextStyle(
                                fontSize: MediaQuery.of(context).textScaleFactor*20,
                              ),),
                              value:selectedUomList[index],
                              // Not necessary for Option 1
                              items: uomList.map((String val) {
                                return DropdownMenuItem(
                                  child: new Text(val.toString(),style: TextStyle(
                                    fontSize: MediaQuery.of(context).textScaleFactor*20,
                                  ),),
                                  value: val,
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedUomList[index]=newValue;
                                });

                                print(selectedUomList);

                              },
                            ),),
                            DataCell(Container(
                              width: MediaQuery.of(context).size.width/8,
                              child: TextField(
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                                ),
                                onChanged: (value){
                                  sp.insert(index, value);
                                }
                                ,
                                keyboardType: TextInputType.number,
                              ),
                            )),
                            DataCell(Container(
                                width: MediaQuery.of(context).size.width/8,
                                child: TextField(
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).textScaleFactor*20,
                                  ),
                                  onChanged: (value){
                                    pp.insert(index, value);
                                  },
                                  keyboardType: TextInputType.number,
                                ))),
                            DataCell(Container(
                                width: MediaQuery.of(context).size.width/8,
                                child: TextField(
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).textScaleFactor*20,
                                  ),
                                  onChanged: (value){
                                    barcode.insert(index, value);
                                  },
                                  keyboardType: TextInputType.number,
                                ))),
                            DataCell(Container(
                                width: MediaQuery.of(context).size.width/8,
                                child: TextField(
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).textScaleFactor*20,
                                  ),
                                  onChanged: (value){
                                    conversion.insert(index, value);
                                  },
                                  keyboardType: TextInputType.number,
                                ))),
                            DataCell(GestureDetector(
                              child: IconButton(
                                onPressed: (){
                                  setState(() {
                                    print(uomList);
                                    addUom--;
                                    selectedUomList.removeAt(index);
                                    sp.removeAt(index);
                                    pp.removeAt(index);
                                    barcode.removeAt(index);
                                    conversion.removeAt(index);
                                    print(selectedUomList);
                                  });
                                },
                                icon: Icon(Icons.delete,color: Colors.black,),),
                            ))
                          ],
                        ),),
                      ),
                    ],),
                ),
                Container(
                  width: boxWidth,
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tax',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                        ),
                      ),
                      DropdownButton(
                        value:
                        tax, // Not necessary for Option 1
                        items: taxNameList.map((String val) {
                          return DropdownMenuItem(
                            child: new Text(val.toString(),style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                            ),),
                            value: val,
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            tax = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  width: boxWidth,
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Discount',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                        ),
                      ),
                      TextField(
                        controller: discountController,
                        onChanged: (value) {
                          discount=value;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () async{
                      if(itemName==''|| tax=='' || selectedCategory=='' ){
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
                        for(int i=0;i<allProducts.length;i++){
                          if(allProducts[i].toLowerCase() == itemName.toLowerCase().trim()){
                            inside='contains';
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text("Product name Exists"),
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
                          for(int i=0;i<selectedUomList.length;i++){
                            int sameUom=0;
                            for(int j=0;j<selectedUomList.length;j++){
                              if(selectedUomList[i]==selectedUomList[j])
                                sameUom++;
                            }
                            if(sameUom>1) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      child: Text('Invalid UOM List',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                        ),),
                                    );
                                  });
                              return;
                            }
                          }
                          //    String bdy = itemName+selectedCategory+itemCode+tax+discount;
                          String tempUom='';
                          for(int i=0;i<selectedUomList.length;i++){
                            tempUom+='${selectedUomList[i]}*';
                            if(validCharacters.hasMatch(selectedUomList[i])==false)ite=true;
                            print("selectedUomList[i]"+selectedUomList[i]);
                          }
                          tempUom+='``';
                          for(int i=0;i<selectedUomList.length;i++){
                            if(sp[i].contains(',')){
                              sp[i]= sp[i].replaceAll(',', '>');
                              if(validCharacters.hasMatch(sp[i])==false)ite=true;
                              print('sp ${sp[i]}');
                            }
                            tempUom+='${sp[i]}*';
                          }
                          tempUom+='``';
                          for(int i=0;i<selectedUomList.length;i++){
                            tempUom+='${pp[i]}*';
                            if(validCharacters.hasMatch(pp[i])==false)ite=true;
                            print('pp ${pp[i]}');
                          }
                          tempUom+='``';
                          for(int i=0;i<selectedUomList.length;i++){
                            tempUom+='${barcode[i]}*';
                            if(validCharacters.hasMatch(barcode[i])==false)ite=true;
                            print('barcode ${barcode[i]}');
                          }
                          tempUom+='``';
                          for(int i=0;i<selectedUomList.length;i++){
                            tempUom+='${conversion[i]}*';
                            if(validCharacters.hasMatch(conversion[i])==false)ite=true;
                            print('conversion ${conversion[i]}');
                          }
                          print(tempUom);
                          int count=0;
                          String body='$itemName:$selectedCategory:$itemCode:$_character:$tempUom:$tax:$discount:$productImage';
                          String stockBody='$itemName~0~0~0';
                          await insertData(body,'product_data');
                          await insertData(stockBody,'stock_data');
                          await getData('stock_data');
                          await getData('product_data');
                         // productFirstSplit.add(body);
                          print('productFirstSplit $productFirstSplit');
                          discount='';
                          productImage='';
                          itemCode='';
                          itemName='';
                          nameController.clear();
                          codeController.clear();
                          barcodeController.clear();
                          priceController.clear();
                          costPriceController.clear();
                          taxController.clear();
                          discountController.clear();
                          setState(() {
                           // allProducts.add(itemName.trim());
                            print('all products after add $allProducts');
                            addUom = 0;
                            selectedUomList = [];
                            sp = [];
                            pp = [];
                            barcode = [];
                            conversion = [];
                          });
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: kGreenColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(
                          letterSpacing: 2.0,
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                          color: kItemContainer,
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
  String getValue(String val){
    return val;
  }


// bool isItemExist(String itemName,String body)
// {
//   //catName = catName + sequence.toString();
//   print(body);
//   print(validCharacters.hasMatch(body));
//
//   if(validCharacters.hasMatch(body)==false)
//   {ite = true;print("FALSE");}
//   else {
//     print("ENTERING ELSE");
//     for (int i = 0; i < productFirstSplit.length; i++) {
//       try {
//         int m = productFirstSplit[i].indexOf(":");
//         String nam = productFirstSplit[i].toString().substring(0, m).trim();
//         if (nam == itemName) {
//           ite = true;
//           return true;
//           break;
//         };
//       } catch (Exception) {
//         return false;
//       }
//     }
//   }
// }
}
showAlertDialog(BuildContext context) {

  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {  Navigator.of(context).pop(); // dismiss dialog
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Product adding failed!"),
    content: Text("Product already exists or  contain special characters"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}


