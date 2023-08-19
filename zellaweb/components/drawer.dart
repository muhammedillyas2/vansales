import 'package:flutter/material.dart';
import 'package:restaurant_app/screen/admin_screen.dart';
import 'package:restaurant_app/screen/expense_transaction.dart';
import 'package:restaurant_app/screen/login_page.dart';
import 'package:restaurant_app/screen/pos_screen.dart';
import 'package:restaurant_app/screen/purchase_return.dart';
import 'package:restaurant_app/screen/purchase_screen.dart';
import 'package:restaurant_app/screen/receipt_payment_screen.dart';
import 'package:restaurant_app/screen/sales_return.dart';
import 'package:restaurant_app/screen/stock_transfer.dart';

import '../constants.dart';
import 'firebase_con.dart';

class MyDrawer extends StatelessWidget {

  final GlobalKey<NavigatorState> navigator;//1

  const MyDrawer({Key key, this.navigator}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return  Drawer(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height /5,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/dot_logo.png"),
                fit: BoxFit.fitWidth
            )
        ),
            child: Text('' ),
          ),
          Divider(thickness: 5.0,color: kGreenColor,),
          Expanded(
            child: ListView(
              children: [
                SizedBox(
                  height: 40,
                  child: ListTile(
                    title: const Text('Sales'),
                    onTap: () async {
                      await displayAllProducts('Salable');
                      Navigator.pushNamed(context, PosScreen.id);
                    },
                  ),
                ),
                Divider(thickness: 2.0,color: kGreenColor,),
                SizedBox(
                  height: 40,
                  child: ListTile(
                    title: const Text('Purchase'),
                    onTap: () async{
                      await displayAllProducts('Purchasable');
                      Navigator.pushNamed(context, PurchaseScreen.id);
                    },
                  ),
                ),
                Divider(thickness: 2.0,color: kGreenColor,),
                SizedBox(
                  height: 40,
                  child: ListTile(
                    title: const Text('Sales Return'),
                    onTap: () async{
                      await displayAllProducts('Salable');
                      Navigator.pushNamed(context, SalesReturn.id);
                    },
                  ),
                ),
                Divider(thickness: 2.0,color: kGreenColor,),
                SizedBox(
                  height: 40,
                  child: ListTile(
                    title: const Text('Purchase Return'),
                    onTap: () async{
                      await displayAllProducts('Purchasable');
                      Navigator.pushNamed(context, PurchaseReturn.id);
                    },
                  ),
                ),
                Divider(thickness: 2.0,color: kGreenColor,),
                if(currentTerminal=='Admin-POS')
                  Column(children: [
                    SizedBox(
                      height: 40,
                      child: ListTile(
                        title: const Text('Expense'),
                        onTap: () async {
                          await read('expense_head');
                          Navigator.pushNamed(context, ExpenseTransaction.id);
                        },
                      ),
                    ),
                    Divider(thickness: 2.0,color: kGreenColor,),
                    SizedBox(
                      height: 40,
                      child: ListTile(
                        title: const Text('Receipt/Payment',),
                        onTap: () {
                          Navigator.pushNamed(context, ReceiptPayment.id);
                        },
                      ),
                    ),
                    Divider(thickness: 2.0,color: kGreenColor,),
                    SizedBox(
                      height: 40,
                      child: ListTile(
                        title: const Text('Stock Transfer',),
                        onTap: () {
                          Navigator.pushNamed(context, StockTransfer.id);
                        },
                      ),
                    ),
                    Divider(thickness: 2.0,color: kGreenColor,),
                    SizedBox(
                      height: 40,
                      child: ListTile(
                        title: const Text('Administration',),
                        onTap: () {
                          Navigator.pushNamed(context, AdminScreen.id);
                        },
                      ),
                    ),
                    Divider(thickness: 2.0,color: kGreenColor,),
                  ],),

              ],
            ),
          ),
        ],
      ),
      // Populate the Drawer in the next step.
    );
  }
}
