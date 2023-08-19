import 'dart:convert';
import 'dart:io';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
// import 'package:oktoast/oktoast.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/constants.dart';
import 'package:restaurant_app/screen/pos_screen.dart';
import 'organisation_screen.dart';

class PrinterManagement extends StatefulWidget {
  static const String id = 'printer';
  @override
  _PrinterManagementState createState() => _PrinterManagementState();
}

int addKot = 0;
String ipAddress, portNumber, printerName;
TextEditingController ipAddressController1 = TextEditingController();
selectedMode _printerSelected = selectedMode.Network;
TextEditingController ipAddressEditController= TextEditingController();
TextEditingController printerNameEditController1 = TextEditingController();
TextEditingController portNumberEditController1 = TextEditingController();
// PrinterBluetoothManager printerManager = PrinterBluetoothManager();
// PrinterBluetooth selectedPrinter;
// List<PrinterBluetooth> _devices = [];
enum selectedMode { Bluetooth, Network, USB }
bool editPrinter=false;
class _PrinterManagementState extends State<PrinterManagement> {
  @override
  void initState() {
    // TODO: implement initState
    addKot = kotCategory.length;
    print(addKot);
    super.initState();
  }
  // void _startScanDevices() {
  //   setState(() {
  //     _devices = [];
  //   });
  //   printerManager.scanResults.listen((devices) async {
  //     // print('UI: Devices found ${devices.length}');
  //     setState(() {
  //       _devices = devices;
  //     });
  //   });
  //   printerManager.startScan(Duration(seconds: 4));
  //   // setState(() {
  //   //   _devices.add(_devices);
  //   // });
  //   print('inside scan $_devices');
  // }
  //
  // void _stopScanDevices() {
  //   printerManager.stopScan();
  // }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: (){
              Navigator.pushReplacementNamed(context, PosScreen.id);
            },
            icon: Icon(Icons.arrow_back_outlined),
            ),
            backgroundColor: kLightBlueColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available Printers',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor * 20,
                          ),
                        ),
                        printersList == null
                            ? Text(
                          'Empty',
                          style: TextStyle(
                            fontSize:
                            MediaQuery.of(context).textScaleFactor * 16,
                          ),
                        )
                            : Container(
                          width: MediaQuery.of(context).size.width > 1000
                              ? MediaQuery.of(context).size.width / 4
                              : MediaQuery.of(context).size.width / 2,
                          child: ListView.builder(
                            itemCount: printersList.length,
                            scrollDirection: Axis.vertical,
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              List tempPrint = printersList[index].split(',');
                              print('tempPrint $tempPrint');
                              return ListTile(
                                leading: Icon(Icons.print),
                                title: Text(
                                  tempPrint[1].toString().trim(),
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context)
                                        .textScaleFactor *
                                        16,
                                  ),
                                ),
                                subtitle: Text(
                                  'IP Address: ${tempPrint[2].toString().trim()}\nPort Number: ${tempPrint[3].toString().trim()} ',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context)
                                        .textScaleFactor *
                                        16,
                                  ),
                                ),
                                trailing: IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: ()  {
                                      setState(() {
                                        editPrinter=true;
                                        _printerSelected=selectedMode.Network;
                                        printerName=tempPrint[1].toString().trim();
                                        ipAddress=tempPrint[2].toString().trim();
                                        portNumber=tempPrint[3].toString().trim();
                                        printerNameEditController1.text=tempPrint[1].toString().trim();
                                        ipAddressEditController.text=tempPrint[2].toString().trim();
                                        portNumberEditController1.text=tempPrint[3].toString().trim();
                                      });
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(
                                              builder: (context, setState) {
                                                return Dialog(
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.vertical,
                                                    child: Container(
                                                      padding: EdgeInsets.all(8.0),
                                                      height:
                                                      MediaQuery.of(context).size.height /1.5,
                                                      width: MediaQuery.of(context).size.width/2 ,
                                                      child: Stack(
                                                        children: [
                                                          Flex(
                                                            direction: Axis.vertical,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                            children: [
                                                              Container(
                                                                child: Column(
                                                                  children: [
                                                                    // RadioListTile(
                                                                    //     activeColor: kBlueColor,
                                                                    //     title: Text('Bluetooth'),
                                                                    //     value:
                                                                    //         selectedMode.Bluetooth,
                                                                    //     groupValue:
                                                                    //         _printerSelected,
                                                                    //     onChanged: (value) {
                                                                    //       setState(() {
                                                                    //         _printerSelected =
                                                                    //             value;
                                                                    //       });
                                                                    //     }),
                                                                    RadioListTile(
                                                                        activeColor: kGreenColor,
                                                                        title: Text('Network'),
                                                                        value: selectedMode.Network,
                                                                        groupValue:
                                                                        _printerSelected,
                                                                        onChanged: (value) {
                                                                          setState(() {
                                                                            _printerSelected =
                                                                                value;
                                                                          });
                                                                        }),
                                                                    // RadioListTile(
                                                                    //     activeColor: kBlueColor,
                                                                    //     title: Text('USB'),
                                                                    //     value: selectedMode.USB,
                                                                    //     groupValue:
                                                                    //         _printerSelected,
                                                                    //     onChanged: (value) {
                                                                    //       setState(() {
                                                                    //         _printerSelected =
                                                                    //             value;
                                                                    //       });
                                                                    //     }),
                                                                  ],
                                                                ),
                                                              ),
                                                              getWidget(_printerSelected),
                                                            ],
                                                          ),
                                                          Positioned.fill(
                                                            child: Align(
                                                              alignment: Alignment.bottomRight,
                                                              child: TextButton(
                                                                  onPressed: () async {
                                                                    String temp;
                                                                    temp =
                                                                    '${_printerSelected.toString().substring(13)}:$printerName:$ipAddress:$portNumber:${printersList.isEmpty ? 'true' : 'false'}';
                                                                    print('printer edit $temp');
                                                                    await updateData(temp, 'printer_data', 1, '');
                                                                    printersList[index]=temp
                                                                        .replaceAll(':', ',');
                                                                    Navigator.push(
                                                                      context,
                                                                      new MaterialPageRoute(builder: (context) => new PrinterManagement()),
                                                                    );
                                                                    // Navigator.pop(context);
                                                                  },
                                                                  child: Container(
                                                                    padding: EdgeInsets.all(8.0),
                                                                    color: kLightBlueColor,
                                                                    child: Text(
                                                                      'SAVE',
                                                                      style: TextStyle(
                                                                        letterSpacing: 1.5,
                                                                        fontSize: MediaQuery.of(
                                                                            context)
                                                                            .textScaleFactor *
                                                                            20,
                                                                        color: kWhiteColor,
                                                                      ),
                                                                    ),
                                                                  )),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          });
                                    }),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      editPrinter=false;
                      ipAddressEditController.clear();
                      printerNameEditController1.clear();
                      portNumberEditController1.clear();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return Dialog(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      height:
                                      MediaQuery.of(context).size.height /1.5,
                                      width: MediaQuery.of(context).size.width/2 ,
                                      child: Stack(
                                        children: [
                                          Flex(
                                            direction: Axis.vertical,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Column(
                                                  children: [
                                                    // RadioListTile(
                                                    //     activeColor: kBlueColor,
                                                    //     title: Text('Bluetooth'),
                                                    //     value:
                                                    //         selectedMode.Bluetooth,
                                                    //     groupValue:
                                                    //         _printerSelected,
                                                    //     onChanged: (value) {
                                                    //       setState(() {
                                                    //         _printerSelected =
                                                    //             value;
                                                    //       });
                                                    //     }),
                                                    RadioListTile(
                                                        activeColor: kGreenColor,
                                                        title: Text('Network'),
                                                        value: selectedMode.Network,
                                                        groupValue:
                                                        _printerSelected,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _printerSelected =
                                                                value;
                                                          });
                                                        }),
                                                    // RadioListTile(
                                                    //     activeColor: kBlueColor,
                                                    //     title: Text('USB'),
                                                    //     value: selectedMode.USB,
                                                    //     groupValue:
                                                    //         _printerSelected,
                                                    //     onChanged: (value) {
                                                    //       setState(() {
                                                    //         _printerSelected =
                                                    //             value;
                                                    //       });
                                                    //     }),
                                                  ],
                                                ),
                                              ),
                                              getWidget(_printerSelected),
                                            ],
                                          ),
                                          Positioned.fill(
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: TextButton(
                                                  onPressed: () async {
                                                    String temp;
                                                    temp =
                                                    '${_printerSelected.toString().substring(13)}:$printerName:$ipAddress:$portNumber:${printersList.isEmpty ? 'true' : 'false'}';
                                                    await insertData(
                                                        temp, 'printer_data');

                                                    allPrinter.add(printerName);
                                                    if(printersList.isEmpty){
                                                      defaultPrinter =printerName ;
                                                      defaultIpAddress =ipAddress;
                                                      defaultPort = portNumber;
                                                    }
                                                    setState(() {
                                                      printersList.add(temp
                                                          .replaceAll(':', ','));
                                                    });

                                                    Navigator.push(
                                                      context,
                                                      new MaterialPageRoute(builder: (context) => new PrinterManagement()),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(8.0),
                                                    color: kLightBlueColor,
                                                    child: Text(
                                                      'SAVE',
                                                      style: TextStyle(
                                                        letterSpacing: 1.5,
                                                        fontSize: MediaQuery.of(
                                                            context)
                                                            .textScaleFactor *
                                                            20,
                                                        color: kWhiteColor,
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          });
                      setState(() {

                      });
                    },
                    color: kLightBlueColor,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Add Printer',
                        style: TextStyle(
                          letterSpacing: 1.5,
                          fontSize: MediaQuery.of(context).textScaleFactor * 16,
                          color: kWhiteColor,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 3.0,
                  ),
                  Text(
                    'Default Printer',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor * 20,
                    ),
                  ),
                  DropdownButton(
                    icon: Icon(Icons.print),
                    elevation: 5,
                    value:
                    defaultPrinter ?? ''.trim(), // Not necessary for Option 1
                    items: allPrinter.map((String val) {
                      return DropdownMenuItem(
                        child: new Text(
                          val.toString(),
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor * 20,
                              color: kGreenColor),
                        ),
                        value: val,
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      int index;
                      for (int i = 0; i < allPrinter.length; i++) {
                        if (allPrinter[i] == newValue) index = i;
                      }
                      List temp = printersList[index].split(',');
                      setState(() {
                        defaultPrinter = newValue;
                        defaultIpAddress = temp[2].toString().trim();
                        defaultPort = temp[3].toString().trim();
                        print('defaultPrinter $defaultPrinter');
                      });
                    },
                  ),
                  Divider(
                    thickness: 3.0,
                  ),
                  Visibility(
                    // visible: selectedBusiness=='Restaurant'?true:false,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('KOT Settings',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).textScaleFactor * 20,
                                )),
                            SizedBox(
                              height: 15.0,
                            ),
                            MaterialButton(
                              child: Text(
                                'Add ',
                                style: TextStyle(
                                    fontSize:
                                    MediaQuery.of(context).textScaleFactor * 16,
                                    color: kWhiteColor),
                              ),
                              color: kLightBlueColor,
                              onPressed: () {
                                setState(() {
                                  addKot++;
                                  kotCategory.add(productCategoryF[0]);
                                  kotPrinter.add(allPrinter[0]);
                                });
                              },
                            ),
                            DataTable(
                                columns: [
                                  DataColumn(
                                      label: Text(
                                        'Category',
                                        style: TextStyle(
                                          fontSize:
                                          MediaQuery.of(context).textScaleFactor * 20,
                                        ),
                                      )),
                                  DataColumn(
                                      label: Text(
                                        'Printer',
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
                                    addKot,
                                        (index) => DataRow(cells: [
                                      DataCell(
                                        DropdownButton(
                                          hint: Text(
                                            'Select Category',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                  .textScaleFactor *
                                                  20,
                                            ),
                                          ),
                                          value: kotCategory[index],
                                          // Not necessary for Option 1
                                          items: productCategoryF.map((String val) {
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
                                              kotCategory[index] = newValue;
                                            });
                                            print(kotCategory);
                                          },
                                        ),
                                      ),
                                      DataCell(
                                        DropdownButton(
                                          hint: Text(
                                            'Select Printer',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                  .textScaleFactor *
                                                  20,
                                            ),
                                          ),
                                          value: kotPrinter[index].trim(),
                                          // Not necessary for Option 1
                                          items: allPrinter.map((String val) {
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
                                              kotPrinter[index] = newValue;
                                            });
                                            print(kotPrinter);
                                          },
                                        ),
                                      ),
                                      DataCell(GestureDetector(
                                        child: IconButton(
                                          onPressed: () async {
                                            await deleteData(
                                                'kot_data', 0, kotCategory[index]);
                                            setState(() {
                                              addKot--;
                                              kotCategory.removeAt(index);
                                              kotPrinter.removeAt(index);
                                            });
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ))
                                    ]))),
                            Visibility(
                              visible: addKot > 0 ? true : false,
                              child: MaterialButton(
                                child: Text(
                                  'Save ',
                                  style: TextStyle(
                                      fontSize:
                                      MediaQuery.of(context).textScaleFactor * 16,
                                      color: kWhiteColor),
                                ),
                                color: kLightBlueColor,
                                onPressed: () async {
                                  String body = '';
                                  String ip;
                                  String tempPrinter;
                                  for (int i = 0; i < kotCategory.length; i++) {
                                    tempPrinter = kotPrinter[i];
                                    for (int k = 0; k < printersList.length; k++) {
                                      List temp = printersList[k].split(',');
                                      print('temp $temp  k $k');
                                      if (temp[2].toString().trim() == tempPrinter.trim())
                                      {ip = temp[3].toString().trim();
                                      kotPrinterIpAddress.add(ip);
                                      }
                                    }
                                    body += '${kotCategory[i]}:${kotPrinter[i]}:${kotPrinterIpAddress[i]}~';
                                    print('body $body');
                                  }
                                  await insertData(body, 'kot_data');
                                },
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        ));
  }

  Widget getWidget(selectedMode selectedType) {
    if (selectedType == selectedMode.USB) {
      return Container(
          child: Column(
            children: [
              Text('USB selected'),
            ],
          ));
    }
    else if (selectedType == selectedMode.Bluetooth) {
      return Container(
        // child: Column(
        //   children: [
        //     Text('Bluetooth selected'),
        //     MaterialButton(
        //       onPressed: (){
        //           //_startScanDevices();
        //       },
        //       color: kLightBlueColor,
        //       child: Padding(
        //         padding: EdgeInsets.all(8.0),
        //         child: Text('SCAN'),
        //       ),
        //     ),
        //     Container(
        //       child: ListView.builder(
        //           shrinkWrap: true,
        //           itemCount: _devices.length,
        //           itemBuilder: (BuildContext context, int index) {
        //             return InkWell(
        //               onTap: () {
        //                 selectedPrinter=_devices[index];
        //
        //               },
        //               child: Column(
        //                 children: <Widget>[
        //                   Container(
        //                     height: 60,
        //                     padding: EdgeInsets.only(left: 10),
        //                     alignment: Alignment.centerLeft,
        //                     child: Row(
        //                       children: <Widget>[
        //                         Icon(Icons.print),
        //                         SizedBox(width: 10),
        //                         Expanded(
        //                           child: Column(
        //                             crossAxisAlignment: CrossAxisAlignment.start,
        //                             mainAxisAlignment: MainAxisAlignment.center,
        //                             children: <Widget>[
        //                               Text(_devices[index].name ?? ''),
        //                               Text(_devices[index].address),
        //                             ],
        //                           ),
        //                         )
        //                       ],
        //                     ),
        //                   ),
        //                   Divider(),
        //                 ],
        //               ),
        //             );
        //           }),
        //     ),
        //   ],
        // )
      );
    } else if (selectedType == selectedMode.Network) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Printer Name',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).textScaleFactor * 18,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: TextField(
                    controller: printerNameEditController1,
                    keyboardType: TextInputType.text,
                    cursorColor: kLightBlueColor,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kLightBlueColor, width: 2.0)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kLightBlueColor, width: 2.0)),
                    ),
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor * 18,
                    ),
                    autofocus: true,
                    enabled: !editPrinter,
                    onChanged: (value) {
                      printerName = value;
                    },
                  ),
                ),
                Text(
                  'IP Address',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).textScaleFactor * 18,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: TextField(
                    controller: ipAddressEditController,
                    keyboardType: TextInputType.number,
                    cursorColor: kLightBlueColor,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kLightBlueColor, width: 2.0)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kLightBlueColor, width: 2.0)),
                    ),
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor * 18,
                    ),
                    autofocus: true,
                    onChanged: (value) {
                      ipAddress = value;
                    },
                  ),
                ),
                Text(
                  'Port Number',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).textScaleFactor * 18,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: TextField(
                    controller: portNumberEditController1,
                    keyboardType: TextInputType.number,
                    cursorColor: kLightBlueColor,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kLightBlueColor, width: 2.0)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kLightBlueColor, width: 2.0)),
                    ),
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor * 18,
                    ),
                    autofocus: true,
                    onChanged: (value) {
                      portNumber = value;
                    },
                  ),
                ),
              ],
            )),
      );
    }
  }
}
