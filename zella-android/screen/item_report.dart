import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/components/firebase_con.dart';
import 'package:restaurant_app/screen/product_edit_screen.dart';
import 'package:restaurant_app/screen/tax_report.dart';
import '../constants.dart';
import 'login_page.dart';
Rx<List<String>> itemNameList=RxList<String>([]).obs;
Rx<List<String>> searchName=RxList<String>([]).obs;
Rx<List<String>> categoryList=RxList<String>([]).obs;
Rx<List<double>> qtyList=RxList<double>([]).obs;
Rx<List<double>> searchQty=RxList<double>([]).obs;
Rx<List<double>> totalList=RxList<double>([]).obs;
Rx<List<double>> searchTotal=RxList<double>([]).obs;
TextEditingController itemController=TextEditingController();
TextEditingController categoryController=TextEditingController();
List<String> deliveryMode=['*','Dine In','Take Away','Drive Through','QSR','Delivery'];
RxString selectedDelivery='*'.obs;
String reportType='Item';
enum selectedMode { Item, Category }
selectedMode _character = selectedMode.Item;
DateTime  fromDate;
DateTime toDate =DateTime.now();
int toDate1=0;
int fromDate1=0;
var datePicked;
class ItemReport extends StatefulWidget {
  static const String id='item_report';
  @override
  _ItemReportState createState() => _ItemReportState();
}

class _ItemReportState extends State<ItemReport> {
  void searchCategory(String text) {
    searchName.value.clear();
    searchQty.value.clear();
    searchTotal.value.clear();
    if(text.length>0){
      for (int i = 0; i < productCategoryF.length; i++) {
        String data = productCategoryF[i];
        if (data.toLowerCase().contains(text.toLowerCase().replaceAll('/', '#'))) {
          if(categoryList.value.contains(data)){
            int pos=categoryList.value.indexOf(data);
            double tempQty=qtyList.value[pos];
            double tempTotal=totalList.value[pos];
            searchName.value.add(data);
            searchQty.value.add(tempQty);
            searchTotal.value.add(tempTotal);
          }
          else{
            searchName.value.add(data);
            searchQty.value.add(0.0);
            searchTotal.value.add(0.0);
          }
        }
      }
    }
    else{
      searchName.value.clear();
      searchQty.value.clear();
      searchTotal.value.clear();
    }
  }
  void searchProducts(String text) {
    searchName.value.clear();
    searchQty.value.clear();
    searchTotal.value.clear();
    if(text.length>0){
      for (int i = 0; i < allProducts.length; i++) {
        String data = allProducts[i];
        if (data.toLowerCase().contains(text.toLowerCase().replaceAll('/', '#'))) {
          if(itemNameList.value.contains(data)){
            int pos=itemNameList.value.indexOf(data);
            double tempQty=qtyList.value[pos];
            double tempTotal=totalList.value[pos];
            searchName.value.add(data);
            searchQty.value.add(tempQty);
            searchTotal.value.add(tempTotal);
          }
          else{
            searchName.value.add(data);
            searchQty.value.add(0.0);
            searchTotal.value.add(0.0);
          }
        }
      }
    }
    else{
      searchName.value.clear();
      searchQty.value.clear();
      searchTotal.value.clear();
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    fromDate=beginDate;
    toDate =DateTime.now();
    fromDate1=dateNowDash;
    toDate1=DateTime.now().millisecondsSinceEpoch;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    TextStyle kStyle=TextStyle(
      fontSize: MediaQuery.of(context).textScaleFactor*20,
    );
    return SafeArea(child: Scaffold(
      appBar:AppBar(
        title: Text('item wise',style: TextStyle(
            fontFamily: 'BebasNeue',
            letterSpacing: 2.0
        ),),
        titleSpacing: 0.0,
        backgroundColor: kGreenColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.all(2.0),
            child: Card(
              elevation: 10.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                            onPressed: () async {
                              datePicked = await showDatePicker(
                                context: context,
                                initialDate: new DateTime.now(),
                                firstDate:
                                new DateTime.now().subtract(new Duration(days: 300)),
                                lastDate:
                                new DateTime.now().add(new Duration(days: 300)),
                              );
                              var s = datePicked;
                              String a=s.toString().substring(0,10);
                              fromDate=DateTime.parse('$a 0$orgClosedHour:00:00');
                              setState(() {
                                fromDate1=fromDate.millisecondsSinceEpoch;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                // color: kCardColor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'From :',
                                    style: TextStyle(
                                      letterSpacing: 1,
                                    ),
                                  ),

                                  Text(fromDate!=null?fromDate.toString().substring(0,16):"")
                                ],
                              ),
                            )),
                        TextButton(
                          onPressed: () async {
                            datePicked = await showDatePicker(
                              context: context,
                              initialDate: new DateTime.now(),
                              firstDate:
                              new DateTime.now().subtract(new Duration(days: 300)),
                              lastDate: new DateTime.now().add(new Duration(days: 300)),
                            );
                            var s = datePicked;
                            String a=s.toString().substring(0,10);
                            toDate=DateTime.parse('$a 0$orgClosedHour:00:00');
                            setState(() {
                              toDate1=toDate.millisecondsSinceEpoch;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              //color: kCardColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'To :',
                                  style: TextStyle(
                                    letterSpacing: 1,
                                  ),
                                ),
                                Text(toDate.toString().substring(0,16)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width:200,
                              child: RadioListTile(
                                  activeColor: kBackgroundColor,
                                  title: Text(
                                    'Item',
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).textScaleFactor * 20,
                                    ),
                                  ),
                                  value: selectedMode.Item,
                                  groupValue: _character,
                                  onChanged: (value) {
                                    setState(() {
                                      _character = value as selectedMode;
                                      reportType = 'Item';
                                    });
                                  }),
                            ),
                            SizedBox(
                              width: 250,
                              height: 40,
                              child: TextField(
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context).textScaleFactor*14,
                                    color: Colors.black
                                ),
                                controller: itemController,
                                decoration: new InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    suffixIcon: IconButton(onPressed: () {
                                        itemController.clear();
                                        searchName.value.clear();
                                    }, icon: Icon(Icons.clear,color: Colors.black,)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: kBlack)
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: kBlack)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: kBlack)
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: kBlack)
                                    ),
                                    hintText: 'search for items'
                                ),
                                onChanged: searchProducts,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width:200,
                              child: RadioListTile(
                                  activeColor: kBackgroundColor,
                                  title: Text(
                                    'Category',
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).textScaleFactor * 20,
                                    ),
                                  ),
                                  value: selectedMode.Category,
                                  groupValue: _character,
                                  onChanged: (value) {
                                    setState(() {
                                      _character = value as selectedMode;
                                      reportType = 'Category';
                                    });
                                  }),
                            ),
                            SizedBox(
                              width: 250,
                              height: 40,
                              child: TextField(
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context).textScaleFactor*14,
                                    color: Colors.black
                                ),
                                controller: categoryController,
                                decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  suffixIcon: IconButton(onPressed: () {
                                      categoryController.clear();
                                      searchName.value.clear();
                                  }, icon: Icon(Icons.clear,color: Colors.black,)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: kBlack)
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: kBlack)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: kBlack)
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: kBlack)
                                    ),
                                    hintText: 'search for category',
                                ),
                                onChanged: searchCategory,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height:40,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: kAppBarItems,
                                style: BorderStyle.solid,
                                width: 1.5),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: Obx(() => DropdownButton(
                                // isDense: true,
                                icon:FaIcon(FontAwesomeIcons.box) ,
                                value: selectedDelivery.value, // Not necessary for Option 1
                                items: deliveryMode.map((String val) {
                                  return DropdownMenuItem(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: new Text(val.toString(),
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                                            color: kGreenColor
                                        ),
                                      ),
                                    ),
                                    value: val,
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                    selectedDelivery.value= newValue;
                                },
                              )),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextButton(
                          onPressed: () async {
            QuerySnapshot document=await firebaseFirestore.collection('item_report').where('date',isGreaterThanOrEqualTo: fromDate1)
                .where('date',isLessThanOrEqualTo: toDate1).get();
            itemNameList.value=RxList<String>([]);
            categoryList.value=RxList<String>([]);
            qtyList.value=RxList<double>([]);
            totalList.value=RxList<double>([]);
            List<DocumentSnapshot> document2=[];
             if(selectedDelivery.value!='*'){
                  for(int i=0;i<document.size;i++){
                    Map map2=document.docs[i].data();
                    if(map2.length==12 && document.docs[i]['deliveryType']==selectedDelivery.value){
                         document2.add(document.docs[i]);
                    }
                  }
            }
             else{
                 for(int i=0;i<document.size;i++){
                 document2.add(document.docs[i]);
                 }
             }
                if(reportType=='Item'){
                here: for(int i=0;i<document2.length;i++){
                if(i==0){
                itemNameList.value.add(document2[i]['name']);
                qtyList.value.add(double.parse(document2[i]['qty']));
                totalList.value.add(double.parse(document2[i]['lineTotal']));
                }
                else{
                for(int j=0;j<itemNameList.value.length;j++){
                  if(itemNameList.value[j]==document2[i]['name']){
                        qtyList.value[j]=double.parse(document2[i]['qty'])+qtyList.value[j];
                        totalList.value[j]=double.parse(document2[i]['lineTotal'])+totalList.value[j];
                        continue here;
                  }
                }
                itemNameList.value.add(document2[i]['name']);
                qtyList.value.add(double.parse(document2[i]['qty']));
                totalList.value.add(double.parse(document2[i]['lineTotal']));
                }
                }
                }
                else{
                here1: for(int i=0;i<document2.length;i++){
                if(i==0){
                categoryList.value.add(document2[i]['category']);
                qtyList.value.add(double.parse(document2[i]['qty']));
                totalList.value.add(double.parse(document2[i]['lineTotal']));
                }
                else{
                for(int j=0;j<categoryList.value.length;j++){
                  if(categoryList.value[j]==document2[i]['category']){
                        qtyList.value[j]=double.parse(document2[i]['qty'])+qtyList.value[j];
                        totalList.value[j]=double.parse(document2[i]['lineTotal'])+totalList.value[j];
                        continue here1;
                  }
                }
                categoryList.value.add(document2[i]['category']);
                qtyList.value.add(double.parse(document2[i]['qty']));
                totalList.value.add(double.parse(document2[i]['lineTotal']));
                }
                }
                }
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith((states) {
                                // If the button is pressed, return green, otherwise blue
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.grey;
                                }
                                return kBackgroundColor;
                              })
                          ),
                          child: Text('Search',style:TextStyle(
                              color: Colors.white,
                            fontSize: MediaQuery.of(context).textScaleFactor*16,
                          )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Card(
                  elevation: 5.0,
                  child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    child:Obx(()=>DataTable(columns:
                    [
                        DataColumn(label: Text(reportType=='Item'?'Item':'Category', style: kStyle)),
                      DataColumn(label: Text('Qty', style:kStyle)),
                      DataColumn(label: Text('Value', style: kStyle)),
                    ],
                        rows: List.generate(searchName.value.length>0?searchName.value.length:reportType=='Item'?itemNameList.value.length:categoryList.value.length, (index) => DataRow(cells: [
                            DataCell(Text(searchName.value.length>0?searchName.value[index]:reportType=='Item'?itemNameList.value[index]:categoryList.value[index],style: kStyle)),
                          DataCell(Text(searchName.value.length>0?searchQty.value[index].toStringAsFixed(decimals):qtyList.value[index].toStringAsFixed(decimals),style: kStyle)),
                          DataCell(Text(searchName.value.length>0?searchTotal.value[index].toStringAsFixed(decimals):totalList.value[index].toStringAsFixed(decimals),style: kStyle)),
                        ])
                        ).toList()),),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
String convertEpox(int val){
  DateTime date = new DateTime.fromMillisecondsSinceEpoch(val);
  var format = new DateFormat("d/m/y");
  // String time=date.toString().substring(11)
  print(' date $date');
  var dateString = format.format(date);
  print(' dateString $dateString');
  return date.toString();
}
////old item wise report dataTable
// return FittedBox(
// fit: BoxFit.fitWidth,
// child: DataTable(columns:
// [
// DataColumn(label: Text('InvoiceNo', style:kStyle)),
// DataColumn(label: Text('Date', style: kStyle)),
// DataColumn(label: Text('Item', style: kStyle)),
// DataColumn(label: Text('Category', style:kStyle)),
// DataColumn(label: Text('Qty', style:kStyle)),
// DataColumn(label: Text('Total', style: kStyle)),
// ],
// rows: snapshot.data.docs.map((document) {
// return DataRow(cells: [
// DataCell(Text(document['orderNo'],style: kStyle)),
// DataCell(Text(convertEpox(document['date']).substring(0,16),style: kStyle)),
// DataCell(Text(document['name'],style: kStyle)),
// DataCell(Text(document['category'],style: kStyle)),
// DataCell(Text(document['qty'],style: kStyle)),
// DataCell(Text(document['lineTotal'],style: kStyle)),
// ]);
// }).toList()),
// );