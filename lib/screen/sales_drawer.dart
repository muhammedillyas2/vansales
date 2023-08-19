import 'package:flutter/material.dart';
import 'package:restaurant_app/screen/admin_screen.dart';
import 'package:restaurant_app/screen/expense_transaction.dart';
import 'package:restaurant_app/screen/login_page.dart';
import 'package:restaurant_app/screen/pos_screen.dart';
// import 'package:restaurant_app/screen/purchase_return.dart';
import 'package:restaurant_app/screen/receipt_payment_screen.dart';
// import 'package:restaurant_app/screen/sales_return.dart';
// import 'package:restaurant_app/screen/stock_transfer.dart';
import '../constants.dart';
import 'package:restaurant_app/components/firebase_con.dart';

class SalesDrawer extends StatelessWidget {

  final GlobalKey<NavigatorState> navigator;//1

  const SalesDrawer({Key key, this.navigator}) : super(key: key);
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
                    title: const Text('Expense'),
                    onTap: () async {
                      await read('expense_head');
                      Navigator.pop(context);
                      Navigator.pushNamed(context, ExpenseTransaction.id);
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
                      Navigator.pop(context);
                      // Navigator.pushNamed(context, SalesReturn.id);
                    },
                  ),
                ),
                Divider(thickness: 2.0,color: kGreenColor,),



              ],
            ),
          ),
        ],
      ),
      // Populate the Drawer in the next step.
    );
  }
}