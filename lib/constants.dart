import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
////
var size, height, width;
// DBD9DF
const kGreenColor = Color(0xff10002B);
const dotColor = Color(0xFF5A189A);
const bgCart = Color(0xFFE5E5E5);
const carttext = Color(0xFF11002C);
const cartColor = Color(0xffF5EDFC);
const bottomColor = Color(0xff3D096D);
const bottomColor2 = Color(0xff000000);
const dimColor = Color(0xffE0B0FF);
const cardColor = Color(0xffF5EDFC);
const orderColor = Color(0xffEC5A5A);
const cancelColor = Color(0xff8122DC);
const kFont1Color = Color(0xffC77DFF);
const kFont2Color = Color(0xff5A189A);
const  kFont3Color= Color(0xffE0AAFF);
double tillavailablecash = 0;
TextEditingController searchroute = TextEditingController();
TextEditingController withdrawn = TextEditingController();
//////
//dashBoard box color
const kDash0 = Color(0xff71bd46);
const kDash1 = Color(0xffebd874);
const kDash2 = Color(0xff222b16);
const kDash3 = Color(0xffc84c1f);
const kDash4 = Color(0xfff59519);
const kDash5 = Color(0xffce7d44);
////
const kKitchenGreenColor = Color(0xff1e824c );
const kBoxColor = Color(0xff3C096C);
const kBackgroundColor = Color(0xff10002B);
const kBoxTextColor = Color(0xffFDFDFD);
const kItemContainer = Color(0xffffffff);
//const kLightBlueColor = Color(0xffF54748);
const kLightBlueColor = Color(0xff10002B);
// const kLightBlueColor = Color(0xff0072B5);
const kWhiteColor = Color(0xffffffff);
//const kBadgeColor=Color(0xff1700A8 );
const kBadgeColor=Color(0xff0c1c2c );
const kAppBarItems=Color(0xff0c1c2c );
const kBadgeContentColor=Color(0xffffffff );
const kHighlight=Color(0xff1b2021);
const kBlack=Color(0xff1b2021);
// String body='BURGER BUN:BREAD AND BUN:0001:NORMAL:EACH`PACK``10`50``554410`554411``~CREAM BUN:BREAD AND BUN:0002:NORMAL:EACH`PACK``10`40``554420`554421``~MASALA BUN:BREAD AND BUN:0003:NORMAL:EACH`PACK``15`30``554430`554431``~MILK BREAD:BREAD AND BUN:0004:NORMAL:EACH`PACK``10`50``554440`554441``~SWEET BREAD:BREAD AND BUN:0005:NORMAL:EACH`PACK``10`50``554450`554451``~WHEAT BREAD:BREAD AND BUN:0006:NORMAL:EACH`PACK``10`50``554460`554461``~BUTTER CAKE:CAKES:0007:NORMAL:EACH`PACK``10`50``554470`554471``~PLUM CAKE:CAKES:0008:NORMAL:EACH`PACK``10`50``554480`554481``~MUFFIN CAKE:CAKES:0009:NORMAL:EACH`PACK``10`50``554490`554491``~CUP CAKE:CAKES:0010:NORMAL:EACH`PACK``10`50``554510`554511``~FRUIT CAKE:CAKES:0011:NORMAL:EACH`PACK``10`50``554520`554521``~BARFI BADAM:SWEETS:0012:NORMAL:EACH`PACK``10`50``554530`554531``~GULAB JAM:SWEETS:0013:NORMAL:EACH`PACK``10`50``554540`554541``~JILEBI:SWEETS:0014:NORMAL:EACH`PACK``10`50``554550`554551``~LADDU RED:SWEETS:0014:NORMAL:EACH`PACK``10`50``554560`554561``~LADDU YELLOW:SWEETS:0015:NORMAL:EACH`PACK``10`50``554570`554571``~MILK PEDA:SWEETS:0016:NORMAL:EACH`PACK``10`50``554580`554581``~CHOCOLATE HALWA:HALWA:0017:NORMAL:EACH`PACK``10`50``554590`554591``~DRY FRUIT HALWA:HALWA:0018:NORMAL:EACH`PACK``10`50``554610`554611``~APPLE:FRUITS:0015:WEIGHTED:KG``50``5553331``~';
// String categoryBody='BREAD AND BUN:1:6~CAKES:2:5~SWEETS:3:6~HALWA:4:2~FRUITS:5:1~';
String customerBody='standard:kannur:989999999:98wxz:Price1~';
//String modifierBody='Less Salt:More Salt:Less Sugar:More Sugar';


// class MyCurveClipper extends CustomClipper<Path> {
//   @override
//
//   Path getClip(Size size) {
//     print('size');
//     Path path = Path();
//     path.lineTo(0, size.height - 30);
//     path.quadraticBezierTo(
//         size.width / 2, size.height, size.width, size.height - 30);
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }

