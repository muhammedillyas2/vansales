import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/components/firebase_con.dart';
import 'package:get/get.dart';
import '../constants.dart';
class KitchenDisplay extends StatefulWidget {
  static const String id='kitchen_display';


  @override
  _KitchenDisplayState createState() => _KitchenDisplayState();
}
class _KitchenDisplayState extends State<KitchenDisplay> {
RxInt totalOrders=0.obs;
  int _currentPage = 0;
  RxInt pageCount=0.obs;
  Timer _timer;
  Rx<List<bool>> allVal=RxList<bool>([]).obs;
  PageController _pageController = PageController(
    initialPage: 0,
  );
  String getTime(String date){
    String temp;
    print('len ${date.length}');
    if(date.length==16)
      temp=date.substring(11,16);
    else{
      temp=date.substring(11,14);
      temp+='0';
      temp+=date.substring(14,15);
    }
    print('temp dateeee $temp');
    return temp;
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getOrderData();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _timer?.cancel();
  }
  @override
  Widget build(BuildContext context) {
      Timer.periodic(Duration(seconds: 3), (Timer timer) {
        if(pageCount.value>1){
          if (_currentPage < pageCount.value) {
            _currentPage++;
          } else {
            _currentPage = 0;
          }
          _pageController.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 350),
            curve: Curves.fastOutSlowIn,
          );
        }
      });
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text('KITCHEN STATION',style: TextStyle(
            fontFamily: 'BebasNeue',
            letterSpacing: 2.0
        ),),
        backgroundColor: kGreenColor,
      ),
      body: Container(
        child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: firebaseFirestore.collection('kot_order').snapshots(),
                  builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot2){
                    if (!snapshot2.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    // totalOrders.value=snapshot2.data.size;
                    else{
                      WidgetsBinding.instance.addPostFrameCallback((_){
                        totalOrders.value=snapshot2.data.size;
                      });
                      pageCount.value=(snapshot2.data.size/5).ceil();
                    }
                    return Obx(()=>PageView.builder(
                              controller: _pageController,
                              scrollDirection: Axis.horizontal,
                              itemCount: pageCount.value,
                              itemBuilder: (BuildContext context,index444){
                                print('index444 $index444');
                                int itemCount=0;
                                if(pageCount.value==1)
                                  itemCount=snapshot2.data.size;
                               else if(index444==pageCount.value-1){
                                 int temp=snapshot2.data.size.remainder(5);
                                 if(temp==0)
                                   itemCount=5;
                                 else
                                   itemCount=temp;
                                }
                               else
                                  itemCount=5;
                                return Container(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount:itemCount,
                                itemBuilder: (context,index2){
                                        index2+=index444*5;
                                        print('index2 $index2');
                                        return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SizedBox(
                                      width:250,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Card(
                                            elevation: 5.0,
                                            child: Container(
                                              padding: EdgeInsets.all(4.0),
                                              decoration:  BoxDecoration(
                                                color:kGreenColor,
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(6.0),topRight: Radius.circular(6.0)),
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      snapshot2.data.docs[index2].get('type').toString()=='Spot'?Center(
                                                        child: Text('Dine In',style: TextStyle(
                                                          fontSize: MediaQuery.of(context).textScaleFactor*18,
                                                          fontWeight: FontWeight.bold,
                                                          color:  Colors.white,
                                                        )),
                                                      ):Center(
                                                        child: Text(snapshot2.data.docs[index2].get('type'),style: TextStyle(
                                                          fontSize: MediaQuery.of(context).textScaleFactor*22,
                                                          fontWeight: FontWeight.bold,
                                                          color:  Colors.white,
                                                        ),),
                                                      ),
                                                      Spacer(),
                                                      Align(
                                                        alignment: Alignment.centerRight,
                                                        child: Text(getTime(snapshot2.data.docs[index2].get('date')),style: TextStyle(
                                                          // fontSize: MediaQuery.of(context).textScaleFactor*22,
                                                          fontWeight: FontWeight.bold,
                                                          color:  Colors.white,
                                                        ),),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Text('${index2+1}',style: TextStyle(
                                                    fontSize: MediaQuery.of(context).textScaleFactor*30,
                                                    fontWeight: FontWeight.bold,
                                                    color:  Colors.white,
                                                  ),),
                                                  SizedBox(height: 5,),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                            Text(snapshot2.data.docs[index2].get('orderNo'),style: TextStyle(
                                                              //fontSize: MediaQuery.of(context).textScaleFactor*15,
                                                              fontWeight: FontWeight.bold,
                                                              color:  Colors.white,
                                                            ),),
                                                      snapshot2.data.docs[index2].get('type').toString()=='Spot'?Text(snapshot2.data.docs[index2].get('tableNo'),style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color:  Colors.white,
                                                      ),):Text(''),
                                                    ],
                                                  ),
                                                ],
                                              ),),
                                          ),
                                          Card(
                                            elevation: 5.0,
                                            child: Container(
                                                width: double.maxFinite,
                                                // decoration:  BoxDecoration(
                                                //     borderRadius: BorderRadius.all(Radius.zero),
                                                //     border: Border.all(color: kGreenColor)
                                                // ),
                                                constraints: BoxConstraints(
                                                  maxHeight: double.infinity,
                                                ),
                                                //padding: EdgeInsets.only(left: 3.0,right: 3.0),
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                    itemCount:snapshot2.data.docs[index2]['cartList'].length ,
                                                    itemBuilder: (context,index3){
                                                      return Padding(
                                                        padding: const EdgeInsets.only(top: 2.0,left: 6.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Text('${snapshot2.data.docs[index2]['cartList'][index3]['qty']}x',style: TextStyle(
                                                                  fontWeight: FontWeight.bold
                                                                ),),
                                                                Text(snapshot2.data.docs[index2]['cartList'][index3]['uom'].toString(),style: TextStyle(
                                                                    fontWeight: FontWeight.bold
                                                                )),
                                                              ],
                                                            ),
                                                            SizedBox(width: 10,),
                                                            Expanded(
                                                              child: Text(snapshot2.data.docs[index2]['cartList'][index3]['name'].toString(),overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(
                                                      fontWeight: FontWeight.bold
                                                      )),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    })
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                                );
                              }));
              }),
            ),
            SizedBox(height: 60,child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(()=>Text('${totalOrders.value} orders in queue',style: GoogleFonts.oswald( fontSize: 30,
                fontWeight: FontWeight.w700,),),)
            ),)
          ],
        ),
      ),
    ));
  }

}