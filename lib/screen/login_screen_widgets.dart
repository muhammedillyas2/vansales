import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
Column numericKeypad(context) {
  String loginPin='';
  RxString obscurePin=''.obs;
  SizedBox kIconNumber(String num){
    TextStyle kNumericText=GoogleFonts.oswald(
      textStyle:const TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 30),);
    return  SizedBox(
      height: 120,
      child: IconButton(onPressed:(){
        loginPin+=num;
        obscurePin.value='*'*loginPin.length;
      }, icon:  Center(child: Text(num,style: kNumericText))),
    );
  }
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Obx(() =>Text(obscurePin.value,style: GoogleFonts.oswald(
        textStyle:const TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 40,letterSpacing: 4),),),),
      SizedBox(
        width: 200,
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder.all(
              color: const Color(0xff8A8A8A),
              style: BorderStyle.solid,
              width: 1),
          children:  [
            TableRow(
                children: [
                  kIconNumber('7'),
                  kIconNumber('8'),
                  kIconNumber('9'),
                ]
            ),
            TableRow(
                children: [
                  kIconNumber('4'),
                  kIconNumber('5'),
                  kIconNumber('6'),
                ]
            ),
            TableRow(
                children: [
                  kIconNumber('1'),
                  kIconNumber('2'),
                  kIconNumber('3'),
                ]
            ),
            TableRow(

                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: IconButton(onPressed: () async {
                       // await login(loginPin);
                    }, icon:  const  Icon(Icons.check,color: Colors.black,size: 40,)),
                  ),
                  kIconNumber('0'),
                  IconButton(onPressed: (){
                    if (loginPin.isNotEmpty) {
                      loginPin = loginPin.substring(0, loginPin.length - 1);
                      obscurePin.value='*'*loginPin.length;
                    }
                  }, icon: const Center(child: Icon(Icons.backspace))),
                ]
            ),

          ],),
      ),
    ],
  );
}