import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restaurant_app/components/all_file.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/screen/add_product.dart';
import '../constants.dart';

int uomCount=0;
int itemIndex=0;
String oldName='';
List<String> itemUomListEdit = [];
List<String> itemName = [];
List<String> itemCode = [];
List<String> itemCategory = [];
List<String> itemTax = [];
List<String> itemDiscount = [];
List<String> itemBarcodeType = [];
List<String> itemImages = [];
TextEditingController itemNameEditController = TextEditingController();
TextEditingController itemCodeEditController = TextEditingController();
TextEditingController itemCategoryEditController = TextEditingController(
  text: productCategoryF[0]
);
TextEditingController taxEditController = TextEditingController();
TextEditingController barcodeTypeController = TextEditingController();
TextEditingController discountEditController = TextEditingController();
TextEditingController imagesEditController = TextEditingController();
List<TextEditingController> uomEditController = [];
List<TextEditingController> spEditController = [];
List<TextEditingController> ppEditController = [];
List<TextEditingController> barcodeEditController = [];
List<TextEditingController> conversionEditController = [];
String _selectedItem;
enum selectedModeEdit { Normal, Weighted }
selectedMode _characterEdit;

Future getProductData() async {

  itemTax = [];
  itemName = [];
  itemCode = [];
  itemCategory = [];
  itemUomListEdit = [];
  itemDiscount = [];
  itemBarcodeType = [];
  for (int i = 0; i < productFirstSplit.length; i++) {
    List temp = productFirstSplit[i].toString().split(':');
    itemName.add(temp[0].toString().trim());
    itemCode.add(temp[2].toString().trim());
    itemCategory.add(temp[1].toString().trim());
    itemTax.add(temp[5].toString().trim());
    itemUomListEdit.add(temp[4].toString().trim());
    itemDiscount.add(temp[6].toString().trim());
    itemImages.add(temp[7].toString().trim());
    itemBarcodeType.add(temp[3].toString().trim());
  }
}
void displayProductData(String name) {
  print('inside display$name');
  int index;
  for(int i=0;i<productFirstSplit.length;i++){
    List temp=productFirstSplit[i].toString().split(':');
    if(temp[0].toString().trim()==name){
      index=i;
      itemIndex=i;
      print('itemIndex $itemIndex');
      break;
    }
  }
  if(index==null)
    return;
  print('inside display ${productFirstSplit[index]}');
  uomEditController=[];
  spEditController=[];
  ppEditController=[];
  barcodeEditController=[];
  conversionEditController=[];
  itemNameEditController.text = itemName[index].trim();
 oldName=itemName[index].trim();
  itemCodeEditController.text = itemCode[index].trim();
  itemCategoryEditController.text = itemCategory[index].trim();
  barcodeTypeController.text = itemBarcodeType[index].trim();
  if (barcodeTypeController.text == 'selectedMode.Normal')
    _characterEdit = selectedMode.Normal;
  else
    _characterEdit = selectedMode.Weighted;
  print(_characterEdit);
  taxEditController.text = itemTax[index].trim();
  discountEditController.text = itemDiscount[index].trim();
  imagesEditController.text = itemImages[index].trim();
  List temp = itemUomListEdit[index].split('``');
  List tempUom = temp[0].toString().split('*');
  List tempSp = temp[1].toString().split('*');
  List tempPp = temp[2].toString().split('*');
  List tempBarcode = temp[3].toString().split('*');
  List tempConversion = temp[4].toString().split('*');
  tempUom.removeLast();
  uomCount = tempUom.length;
  tempSp.removeLast();
  tempPp.removeLast();
  tempBarcode.removeLast();
  tempConversion.removeLast();
  for (int i = 0; i < tempUom.length; i++) {
    uomEditController.add(TextEditingController(text: tempUom[i].toString().trim()));
    print('uom $uomEditController');
  }
  for (int i = 0; i < tempSp.length; i++) {
    String tempSpSplit = tempSp[i];
    if (tempSpSplit.trim().contains('>')) {
      print('>>');
      spEditController
          .add(TextEditingController(text: tempSpSplit.toString().trim().replaceAll('>', ',')));
    } else {
      print('not >');
      spEditController.add(
          TextEditingController(text: tempSp[i].toString().trim()));
    }
  }
  for (int i = 0; i < tempPp.length; i++) {
    ppEditController.add(TextEditingController(text: tempPp[i]));
  }
  for (int i = 0; i < tempBarcode.length; i++) {
    barcodeEditController.add(TextEditingController(text: tempBarcode[i]));
  }
  for (int i = 0; i < tempConversion.length; i++) {
    conversionEditController
        .add(TextEditingController(text: tempConversion[i]));
  }
}
class EditItems extends StatefulWidget {
static const String id='edit_items';
  @override
  _EditItemsState createState() => _EditItemsState();
}

class _EditItemsState extends State<EditItems> {
  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();
    print(directory.path);
    return directory.path;
  }
  @override
  void initState() {
    // TODO: implement initState
   displayProductData(allProducts[0]);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double boxWidth = MediaQuery.of(context).size.width / 2;
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
                          fontSize: MediaQuery.of(context).textScaleFactor * 20,
                        ),
                      ),
                      SimpleAutoCompleteTextField(
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                        ),
                        controller: itemNameEditController,
                        decoration: new InputDecoration(),
                        suggestions: allProducts,
                        clearOnSubmit: false,
                        textSubmitted: (text) {
                          for(int i=0;i<allProducts.length;i++){
                            if(allProducts[i].contains(text))
                              itemIndex=i;
                          }
                          _selectedItem=text;

                            setState(() {
                              itemNameEditController.text=_selectedItem;
                              displayProductData(_selectedItem);
                            });
                            print('inside all products ${allProducts[itemIndex]}');
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
                        'Category ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).textScaleFactor * 20,
                        ),
                      ),
                      Row(
                        children: [
                          DropdownButton(
                            value: itemCategoryEditController
                                .text, // Not necessary for Option 1
                            items: productCategoryF.map((String val) {
                              return DropdownMenuItem(
                                child: new Text(
                                  val.toString(),
                                  style: TextStyle(
                                    fontSize:
                                    MediaQuery.of(context).textScaleFactor *
                                        20,
                                  ),
                                ),
                                value: val,
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                itemCategoryEditController.text = newValue;
                              });
                            },
                          ),
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
                          fontSize: MediaQuery.of(context).textScaleFactor * 20,
                        ),
                      ),
                      TextField(
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor * 20,
                        ),
                        controller: itemCodeEditController,
                        onSubmitted: (value) {
                          itemCodeEditController.text = value;
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
                              imagesEditController.text=myFile.toBase64();
                            }
                            catch(e){
                              print('e $e');
                              final path = await _localPath;
                              FilePickerCross myFile = await FilePickerCross.pick(
                                // Only if FileTypeCross.custom . May be any file extension like `dot`, `ppt,pptx,odp`
                              );
                              imagesEditController.text=myFile.toBase64();
                              print('productImage ${imagesEditController.text}');
                            }
                          },
                          child: Text('Edit Image')) ,
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
                          fontSize: MediaQuery.of(context).textScaleFactor * 20,
                        ),
                      ),
                      RadioListTile(
                          activeColor: kGreenColor,
                          title: Text(
                            'Normal',
                            style: TextStyle(
                              fontSize:
                              MediaQuery.of(context).textScaleFactor * 20,
                            ),
                          ),
                          value: selectedMode.Normal,
                          groupValue: _characterEdit,
                          onChanged: (value) {
                            setState(() {
                              _characterEdit = value;
                            });
                          }),
                      RadioListTile(
                          activeColor: kGreenColor,
                          title: Text(
                            'Weighted',
                            style: TextStyle(
                              fontSize:
                              MediaQuery.of(context).textScaleFactor * 20,
                            ),
                          ),
                          value: selectedMode.Weighted,
                          groupValue: _characterEdit,
                          onChanged: (value) {
                            setState(() {
                              _characterEdit = value;
                            });
                          }),
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
                          fontSize: MediaQuery.of(context).textScaleFactor * 20,
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              uomCount++;
                              uomEditController.add(TextEditingController(
                                text: uomList[0]
                              )
                              );
                              spEditController.add(TextEditingController(
                                text: '0'
                              )
                              );
                              ppEditController.add(TextEditingController(
                                text: '0'
                              )
                              );
                              barcodeEditController.add(TextEditingController(
                                  text: '0'
                              )
                              );
                              conversionEditController.add(TextEditingController(
                                  text: '0'
                              )
                              );
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            color: kGreenColor,
                            child: Text(
                              'ADD',
                              style: TextStyle(
                                letterSpacing: 2.0,
                                fontSize:
                                MediaQuery.of(context).textScaleFactor * 20,
                                color: kItemContainer,
                              ),
                            ),
                          )),
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: DataTable(
                          columns: [
                            DataColumn(
                                label: Text(
                                  'UOM',
                                  style: TextStyle(
                                    fontSize:
                                    MediaQuery.of(context).textScaleFactor * 20,
                                  ),
                                )),
                            DataColumn(
                                label: Text(
                                  'S.P',
                                  style: TextStyle(
                                    fontSize:
                                    MediaQuery.of(context).textScaleFactor * 20,
                                  ),
                                )),
                            DataColumn(
                                label: Text(
                                  'P.P',
                                  style: TextStyle(
                                    fontSize:
                                    MediaQuery.of(context).textScaleFactor * 20,
                                  ),
                                )),
                            DataColumn(
                                label: Text(
                                  'Barcode',
                                  style: TextStyle(
                                    fontSize:
                                    MediaQuery.of(context).textScaleFactor * 20,
                                  ),
                                )),
                            DataColumn(
                                label: Text(
                                  'Conversion',
                                  style: TextStyle(
                                    fontSize:
                                    MediaQuery.of(context).textScaleFactor * 20,
                                  ),
                                )),
                            DataColumn(
                                label: Text(
                                  '',
                                  style: TextStyle(
                                    fontSize:
                                    MediaQuery.of(context).textScaleFactor * 20,
                                  ),
                                )),
                          ],
                          rows: List.generate(
                            uomCount,
                                (index) => DataRow(
                              cells: [
                                DataCell(
                                  DropdownButton(
                                    hint: Text(
                                      'Select UOM',
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context)
                                            .textScaleFactor *
                                            20,
                                      ),
                                    ),
                                    value: uomEditController[index].text,
                                    // Not necessary for Option 1
                                    items: uomList.map((String val) {
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
                                        uomEditController[index].text = newValue;
                                      });
                                    },
                                  ),
                                ),
                                DataCell(Container(
                                  width: MediaQuery.of(context).size.width / 8,
                                  child: TextField(
                                    controller: spEditController[index],
                                    style: TextStyle(
                                      fontSize:
                                      MediaQuery.of(context).textScaleFactor *
                                          20,
                                    ),
                                    onSubmitted: (value) {
                                      spEditController[index].text = value;
                                    },
                                    keyboardType: TextInputType.number,
                                  ),
                                )),
                                DataCell(Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: TextField(
                                      controller: ppEditController[index],
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context)
                                            .textScaleFactor *
                                            20,
                                      ),
                                      onSubmitted: (value) {
                                        ppEditController[index].text = value;
                                      },
                                      keyboardType: TextInputType.number,
                                    ))),
                                DataCell(Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: TextField(
                                      controller: barcodeEditController[index],
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context)
                                            .textScaleFactor *
                                            20,
                                      ),
                                      onSubmitted: (value) {
                                        barcodeEditController[index].text = value;
                                      },
                                      keyboardType: TextInputType.number,
                                    ))),
                                DataCell(Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: TextField(
                                      controller: conversionEditController[index],
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context)
                                            .textScaleFactor *
                                            20,
                                      ),
                                      onSubmitted: (value) {
                                        conversionEditController[index].text =
                                            value;
                                      },
                                      keyboardType: TextInputType.number,
                                    ))),
                                DataCell(GestureDetector(
                                  child: IconButton(
                                    onPressed: (){
                                      setState(() {
                                        print(uomList);
                                        uomCount--;
                                        uomEditController.removeAt(index);
                                        spEditController.removeAt(index);
                                        ppEditController.removeAt(index);
                                        barcodeEditController.removeAt(index);
                                        conversionEditController.removeAt(index);
                                        print(selectedUomList);
                                      });
                                    },
                                    icon: Icon(Icons.delete,color: Colors.black,),),
                                ))
                              ],
                            ),
                          ),
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
                        'Tax',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).textScaleFactor * 20,
                        ),
                      ),
                      TextField(
                        controller: taxEditController,
                        onSubmitted: (value) {
                          taxEditController.text = value;
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
                        'Discount',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).textScaleFactor * 20,
                        ),
                      ),
                      TextField(
                        controller: discountEditController,
                        onSubmitted: (value) {
                          discountEditController.text = value;
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () async {
                      for(int i=0;i<uomEditController.length;i++){
                        int sameUom=0;
                        for(int j=0;j<uomEditController.length;j++){
                          if(uomEditController[i].text==uomEditController[j].text)
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
                      String tempUom='';
                      for(int i=0;i<uomEditController.length;i++){
                        tempUom+='${uomEditController[i].text}*';
                      }
                      tempUom+='``';
                      for(int i=0;i<uomEditController.length;i++){
                        if(spEditController[i].text.contains(',')){
                          spEditController[i].text= spEditController[i].text.replaceAll(',', '>');
                          print('sp ${spEditController[i].text}');
                        }
                        tempUom+='${spEditController[i].text}*';
                      }
                      tempUom+='``';
                      for(int i=0;i<uomEditController.length;i++){
                        tempUom+='${ppEditController[i].text}*';
                      }
                      tempUom+='``';
                      for(int i=0;i<uomEditController.length;i++){
                        tempUom+='${barcodeEditController[i].text}*';
                      }
                      tempUom+='``';
                      for(int i=0;i<uomEditController.length;i++){
                        tempUom+='${conversionEditController[i].text}*';
                      }
                      print(tempUom);
                      int count=0;
                      String body='${itemNameEditController.text}:${itemCategoryEditController.text}:${itemCodeEditController.text}:$_characterEdit:$tempUom:${taxEditController.text}:${discountEditController.text}:${imagesEditController.text}';
                     print(' productFirstSplit[itemIndex]$itemIndex length ${productFirstSplit.length}');
                     print('inside edit $body');
                      setState(() {
                        productFirstSplit[itemIndex]=body;
                        allProducts[itemIndex]=itemNameEditController.text;
                      });
                      await updateData(body, 'product_data', itemIndex+1,'');
                      await updateData(itemNameEditController.text, 'stock_data', 2,oldName);
                      await getData('stock_data');
                      Navigator.pop(context, false);
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: kGreenColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        'SAVE',
                        style: TextStyle(
                          letterSpacing: 2.0,
                          fontSize: MediaQuery.of(context).textScaleFactor * 16,
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
}