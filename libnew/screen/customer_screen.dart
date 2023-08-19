// import 'dart:convert';
// import 'dart:io';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
// import 'package:badges/badges.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:restaurant_app/constants.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:restaurant_app/components/all_file.dart';
// import 'package:restaurant_app/components/database_con.dart';
// import 'package:restaurant_app/screen/cart_screen.dart';
// import 'login_page.dart';
// import 'pos_screen.dart';
//
// String _selectedItem = '';
// int categoryPressed;
// List<int> quantityList = [];
// List<bool> showQuantity = [];
// List<String> selectedProductImage = [];
// Map<String, int> tempCart = {};
// List<bool> selected = List<bool>();
// List<String> customerCart = [];
// final List<String> imgList = [
// 	'images/slider-1.png',
// 	'images/slider-2.png',
// ];
//
// class CustomerScreen extends StatefulWidget {
// 	static const String id = 'customer';
// 	@override
// 	_CustomerScreenState createState() => _CustomerScreenState();
// }
//
// class _CustomerScreenState extends State<CustomerScreen> {
// 	void addToCart(String name, int index) {
// 		String temp = '';
// 		temp = '$name:${getBaseUom(name)}:${getBasePrice(name, 'price 1')}:1';
// 		customerCart.add(temp);
// 		setState(() {
// 			quantityList[index] = 1;
// 		});
// 		selectedProductImage.add(productImages[index]);
// 	}
//
// 	String getBasePrice(String productName, String priceList) {
// 		String basePrice;
// 		for (int i = 0; i < productFirstSplit.length; i++) {
// 			if (productFirstSplit[i].contains(productName)) {
// 				List temp = productFirstSplit[i].split(':');
// 				List tempUom = temp[4].split('``');
// 				List tempUomSplit = tempUom[1].toString().split('*');
//
// 				if (tempUomSplit[0].toString().contains('>')) {
// 					List tempPriceListSplit = tempUomSplit[0].toString().split('>');
// 					int pos = int.parse(selectedPriceList.substring(6));
// 					pos = pos - 1;
// 					basePrice = tempPriceListSplit[pos];
// 				} else
// 					basePrice = tempUomSplit[0];
// 				return basePrice;
// 			}
// 		}
// 	}
//
// 	void removeFromCart(String name, int index) {
// 		String temp = '';
// 		for (int i = 0; i < customerCart.length; i++) {
// 			if (customerCart[i].contains(name)) {
// 				List tempList = customerCart[i].split(':');
// 				print('tempList $tempList');
// 				int tempQty = int.parse(tempList[3].toString().trim());
// 				if (tempQty == 1) {
// 					setState(() {
// 						selectedProductImage.removeAt(i);
// 						customerCart.removeAt(i);
// 						showQuantity[index] = false;
// 					});
// 					return;
// 				}
// 				tempQty--;
// 				setState(() {
// 					quantityList[index] = tempQty;
// 				});
// 				print('tempQty $tempQty');
// 				double tempPrice = double.parse(getBasePrice(name, 'price 1'));
// 				tempPrice = tempPrice * tempQty;
// 				print('tempPrice $tempPrice');
// 				temp = '$name:${getBaseUom(name)}:$tempPrice:$tempQty';
// 				customerCart[i] = temp;
// 				return;
// 			}
// 		}
// 	}
//
// 	String getPrice(String productName, String uomName) {
// 		print('uomName $uomName');
// 		for (int i = 0; i < productFirstSplit.length; i++) {
// 			if (productFirstSplit[i].contains(productName)) {
// 				List temp = productFirstSplit[i].split(':');
// 				List tempPrice = temp[4].split('``');
// 				List tempUomSplit = tempPrice[0].toString().split('*');
// 				List tempPriceSplit = tempPrice[1].toString().split('*');
// 				print('split');
// 				for (int j = 0; j < tempUomSplit.length; j++) {
// 					print(tempUomSplit[j]);
// 					print(tempPriceSplit[j]);
// 					if (tempUomSplit[j].contains(uomName.trim())) {
// 						print('inside if');
// 						String basePrice;
// 						if (tempPriceSplit[j].toString().trimLeft().contains('>')) {
// 							List tempPriceListSplit = tempPriceSplit[j].toString().split('>');
// 							print(tempPriceListSplit);
// 							int pos = int.parse(selectedPriceList.substring(6));
// 							pos = pos - 1;
// 							basePrice = tempPriceListSplit[pos];
// 						} else
// 							basePrice = tempPriceSplit[j].toString().trimLeft();
// 						return basePrice;
// 						// print(tempPriceSplit[j]);
// 						// return tempPriceSplit[j].toString().trimLeft();
// 					}
// 				}
// 			}
// 		}
// 	}
//
// 	List<String> getUom(String productName) {
// 		for (int i = 0; i < productFirstSplit.length; i++) {
// 			if (productFirstSplit[i].contains(productName)) {
// 				List temp = productFirstSplit[i].split(':');
// 				List tempUom = temp[4].split('``');
// 				List tempUomSplit = tempUom[0].toString().split('*');
// 				tempUomSplit.removeLast();
// 				print('tempUomSplit $tempUomSplit');
// 				return tempUomSplit;
// 			}
// 		}
// 	}
//
// 	void addQuantity(String name, int index) {
// 		String temp = '';
// 		for (int i = 0; i < customerCart.length; i++) {
// 			if (customerCart[i].contains(name)) {
// 				List tempList = customerCart[i].split(':');
// 				print('tempList $tempList');
// 				int tempQty = int.parse(tempList[3].toString().trim());
// 				tempQty++;
// 				setState(() {
// 					quantityList[index] = tempQty;
// 				});
// 				print('tempQty $tempQty');
// 				double tempPrice = double.parse(getBasePrice(name, 'price 1'));
// 				tempPrice = tempPrice * tempQty;
// 				print('tempPrice $tempPrice');
// 				temp = '$name:${getBaseUom(name)}:$tempPrice:$tempQty';
// 				customerCart[i] = temp;
// 				return;
// 			}
// 		}
// 	}
//
// 	String getBaseUom(String productName) {
// 		for (int i = 0; i < productFirstSplit.length; i++) {
// 			if (productFirstSplit[i].contains(productName)) {
// 				List temp = productFirstSplit[i].split(':');
// 				List tempUom = temp[4].split('``');
// 				List tempUomSplit = tempUom[0].toString().split('*');
// 				print('base uom ${tempUomSplit[0].toString().trim()}');
// 				return tempUomSplit[0].toString().trim();
// 			}
// 		}
// 	}
//
// 	void addFromSearch(String name, String quantityValue) {
// 		String tempText = '';
// 		if (cartListText.isEmpty) {
// 			String uom = getBaseUom(name);
// 			String tempr = getPrice(name, getBaseUom(name));
// 			double tempRate = double.parse(tempr);
// 			cartController.add(TextEditingController());
// 			tempRate = double.parse(quantityValue) * tempRate;
// 			tempText = '$name:$uom:$tempRate: $quantityValue';
// 			setState(() {
// 				salesTotalList.add(tempRate);
// 				cartController[0].text = tempRate.toString();
// 				salesUomList.add(getBaseUom(name));
// 				cartListText.add(tempText.trim());
// 			});
// 		} else {
// 			for (int i = 0; i < cartListText.length; i++) {
// 				if (cartListText[i].contains(name)) {
// 					List tempList = cartListText[i].split(':');
// 					if (tempList[1].toString().trim() ==
// 							getBaseUom(name).toString().trim()) {
// 						String tempr = getPrice(tempList[0], tempList[1]);
// 						double tempRate = double.parse(tempr);
// 						int qty = int.parse(tempList[3]) + int.parse(quantityValue);
// 						tempRate = qty * tempRate;
// 						tempList[2] = tempRate.toString();
// 						tempList[3] = qty.toString();
// 						tempText = tempList.toString();
// 						tempText =
// 								tempText.substring(1, tempText.length - 1).replaceAll(',', ':');
// 						tempText = tempText.replaceAll(new RegExp(r"\s+"), " ");
// 						setState(() {
// 							salesTotalList[i] = tempRate;
// 							cartController[i].text = tempRate.toString();
// 							cartListText[i] = tempText.trim();
// 						});
// 						return;
// 					}
// 				}
// 			}
// 			setState(() {
// 				String uom = getBaseUom(name);
// 				String tempr = getPrice(name, getBaseUom(name));
// 				double tempRate = double.parse(tempr);
// 				tempRate = double.parse(quantityValue) * tempRate;
// 				tempText = '$name:$uom:$tempRate: $quantityValue';
// 				cartController.add(TextEditingController(text: tempRate.toString()));
// 				salesTotalList.add(tempRate);
// 				salesUomList.add(getBaseUom(name));
// 				cartListText.add(tempText.trim());
// 			});
// 		}
// 	}
//
// 	PosScreen posScreen = PosScreen();
// 	Future<bool> _onBackPressed() {
// 		return showDialog(
// 			context: context,
// 			builder: (context) => new AlertDialog(
// 				title: new Text('Are you sure?'),
// 				content: new Text('Do you want to Log Out'),
// 				actions: <Widget>[
// 					new GestureDetector(
// 						onTap: () => Navigator.of(context).pop(false),
// 						child: Text("NO"),
// 					),
// 					SizedBox(height: 16),
// 					new GestureDetector(
// 						onTap: () => Navigator.of(context).push(
// 								MaterialPageRoute(builder: (context) => LoginScreen())),
// 						child: Text("YES"),
// 					),
// 				],
// 			),
// 		) ??
// 				false;
// 	}
//
// 	List quantityDisplay() {
// 		quantityList = [];
// 		for (int i = 0; i < productsLength; i++) quantityList.add(0);
// 		for (int j = 0; j < customerCart.length; j++) {
// 			List temp = customerCart[j].split(':');
// 			print('temp $temp');
// 			if (productNameF.contains(temp[0].toString().trim())) {
// 				print('inside first if');
// 				for (int k = 0; k < productNameF.length; k++) {
// 					if (productNameF[k].contains(temp[0].toString().trim())) {
// 						print('inside second if');
// 						setState(() {
// 							showQuantity[k] = true;
// 							quantityList[k] = int.parse(temp[3].toString().trim());
// 						});
// 						print('quantityList $quantityList');
// 						print('showQuantity $showQuantity');
// 					}
// 				}
// 			}
// 		}
// 		return quantityList;
// 	}
//
// 	List showAdd() {
// 		showQuantity = [];
// 		for (int i = 0; i < productsLength; i++) showQuantity.add(false);
// 		return showQuantity;
// 	}
//
// 	@override
// 	void initState() {
// 		// TODO: implement initState
// 		showAdd();
// 		quantityDisplay();
// 		super.initState();
// 	}
//
// 	@override
// 	Widget build(BuildContext context) {
// 		return SafeArea(
// 			child: WillPopScope(
// 				onWillPop: _onBackPressed,
// 				child: Scaffold(
// 					resizeToAvoidBottomInset: false,
// 					appBar: AppBar(
// 						bottom: PreferredSize(
// 							child: Container(
// 								decoration: BoxDecoration(
// 									color: Colors.white,
// 								),
// 								child: SimpleAutoCompleteTextField(
// 									style: TextStyle(
// 										fontSize: MediaQuery.of(context).textScaleFactor * 16,
// 									),
// 									focusNode: nameNode,
// 									decoration: new InputDecoration(),
// 									controller: nameController,
// 									suggestions: allProducts,
// 									clearOnSubmit: false,
// 									textSubmitted: (text) => setState(() {
// 										nameController.text = text;
// 										_selectedItem = text;
// 										if (productNameF.contains(_selectedItem)) {
// 											// quantityNode.requestFocus();
// 										} else {
// 											// barcodeEntry(_selectedItem);
// 											nameController.clear();
// 											nameNode.requestFocus();
// 										}
// 									}),
// 								),
// 							),
// 							preferredSize: Size.fromHeight(50),
// 						),
// 						title: Text('POSIMATE',style: TextStyle(
// 								fontFamily: 'BebasNeue',
// 								letterSpacing: 2.0
// 						),),
// 						backgroundColor: kGreenColor,
// 						automaticallyImplyLeading: false,
// 						actions: <Widget>[
// 							Badge(
// 								badgeColor: Colors.redAccent,
// 								badgeContent: Text('${customerCart.length}'),
// 								child: IconButton(
// 										icon: Icon(Icons.shopping_cart),
// 										onPressed: () {
// 											Navigator.push(
// 													context,
// 													MaterialPageRoute(
// 															builder: (context) => CartScreen()));
// 										}),
// 							),
// 						],
// 					),
// 					body: Column(
// 						children: <Widget>[
// 							CarouselSlider(
// 									items: imgList
// 											.map((item) => Image.asset(item, fit: BoxFit.cover ,))
// 											.toList(),
// 									options: CarouselOptions(
// 										viewportFraction: 1,
// 										autoPlayCurve: Curves.easeIn,
// 										height:MediaQuery.of(context).size.height/6 ,
// 										enlargeCenterPage: false,
// 										scrollDirection: Axis.horizontal,
// 										autoPlay: true,
// 									)),
// 							// Container(
// 							//   width: MediaQuery.of(context).size.width,
// 							//   height: MediaQuery.of(context).size.height / 4,
// 							//   decoration: BoxDecoration(
// 							//     image: DecorationImage(
// 							//       image: AssetImage('images/main.png'),
// 							//       fit: BoxFit.fill,
// 							//     ),
// 							//     shape: BoxShape.rectangle,
// 							//   ),
// 							// ),
// 							Container(
// 								height: MediaQuery.of(context).size.height / 20,
// 								margin: EdgeInsets.only(top: 5.0),
// 								child: ListView.builder(
// 										scrollDirection: Axis.horizontal,
// 										itemCount: productCategoryF.length,
// 										itemBuilder: (context, index) {
// 											return Padding(
// 												padding: const EdgeInsets.only(left: 5.0,right: 5.0),
// 												child: GestureDetector(
// 													onTap: () async {
// 														await displayItems(productCategoryF[index]);
// 														setState(() {
// 															showAdd();
// 															quantityDisplay();
// 														});
// 													},
// 													child: Container(
// 														padding: EdgeInsets.all(8.0),
// 														child: Text(
// 															productCategoryF[index],
// 															textAlign: TextAlign.center,
// 															style: TextStyle(
// 																fontSize:
// 																MediaQuery.of(context).textScaleFactor * 15,
// 																color: kWhiteColor,
// 																letterSpacing: 1.0,
// 															),
// 														),
// 														decoration: BoxDecoration(
// 															borderRadius: BorderRadius.circular(20.0),
// 															color: kLightBlueColor,
// 														),
// 													),
// 												),
// 											);
// 										}),
// 							),
//
// 							Expanded(
// 								child: Container(
// 									child: productNameF.isEmpty
// 											? Center(child: Text('Empty'))
// 											: GridView.builder(
// 											gridDelegate:
// 											SliverGridDelegateWithFixedCrossAxisCount(
// 												crossAxisCount: 2,
// 												childAspectRatio: MediaQuery.of(context).size.width /
// 														(MediaQuery.of(context).size.height / 1.7),
// 											),
// 											scrollDirection: Axis.vertical,
// 											itemCount: productsLength,
// 											itemBuilder: (context, index) {
// 												return Padding(
// 													padding: const EdgeInsets.all(8.0),
// 													child: Card(
// 														elevation: 4.0,
// 														child: Column(
// 															mainAxisAlignment:
// 															MainAxisAlignment.spaceBetween,
// 															children: <Widget>[
// 																SizedBox(
// 																	width: MediaQuery.of(context).size.width,
// 																	height: MediaQuery.of(context).size.height/6.5,
// 																	child: Image.memory(base64Decode(
// 																			productImages[index]),
// 																		fit: BoxFit.cover,
// 																	),
// 																),
// 																Container(
// 																	child: Column(
//
// 																		children: [
// 																			AutoSizeText(
// 																				productNameF[index],
// 																				textAlign: TextAlign.center,
// 																				maxLines: 1,
// 																				style: TextStyle(
// 																					fontSize: MediaQuery.of(context)
// 																							.textScaleFactor *
// 																							15,
// 																					color: kBlack,
// 																				),
// 																			),
// 																			Text(
// 																				'\u{20B9} ${getBasePrice(productNameF[index], 'price 1')}',
// 																				style: TextStyle(
// 																					fontSize: MediaQuery.of(context)
// 																							.textScaleFactor *
// 																							15,
// 																					color: kBlack,
// 																				),
// 																			),
// 																			Visibility(
// 																				visible: showQuantity[index],
// 																				replacement: GestureDetector(
// 																					onTap: () {
// 																						setState(() {
// 																							addToCart(productNameF[index],
// 																									index);
// 																							showQuantity[index] = true;
// 																						});
// 																					},
// 																					child: Card(
// 																						elevation: 5.0,
// 																						color: kLightBlueColor,
// 																						shadowColor: kBlack,
// 																						child: Padding(
// 																							padding:
// 																							const EdgeInsets.all(8.0),
// 																							child: Text(
// 																								'ADD',
// 																								style: TextStyle(
// 																										fontSize: MediaQuery.of(
// 																												context)
// 																												.textScaleFactor *
// 																												12,
// 																										color: kWhiteColor,
// 																										letterSpacing: 2.0),
// 																							),
// 																						),
// 																					),
// 																				),
// 																				child: Row(
// 																					children: <Widget>[
// 																						Expanded(
// 																							child: IconButton(
// 																								icon: FaIcon(
// 																										FontAwesomeIcons
// 																												.minusCircle),
// 																								color: kLightBlueColor,
// 																								onPressed: () {
// 																									removeFromCart(
// 																											productNameF[index],
// 																											index);
// 																								},
// 																							),
// 																						),
// 																						AutoSizeText(
// 																							quantityList[index]
// 																									.toString(),
// 																							style: TextStyle(
// 																								fontSize: MediaQuery.of(
// 																										context)
// 																										.textScaleFactor *
// 																										15,
// 																								color: Colors.black,
// 																							),
// 																						),
// 																						Expanded(
// 																							child: IconButton(
// 																								icon: FaIcon(
// 																										FontAwesomeIcons
// 																												.plusCircle),
// 																								color: kLightBlueColor,
// 																								onPressed: () {
// 																									addQuantity(
// 																											productNameF[index],
// 																											index);
// 																								},
// 																							),
// 																						),
// 																					],
// 																				),
// 																			),
// 																		],
// 																	),
// 																),
// 															],
// 														),
// 													),
// 												);
// 											}),
// 								),
// 							),
// 						],
// 					),
// 				),
// 			),
// 		);
// 	}
// }
