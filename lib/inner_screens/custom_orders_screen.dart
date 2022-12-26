import 'package:admin_panel_cc/consts/constants.dart';
import 'package:admin_panel_cc/widgets/custom_orders_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel_cc/widgets/orders_list.dart';
import 'package:provider/provider.dart';
import '../controllers/MenuController.dart' as mc;
import '../responsive.dart';
import '../services/utils.dart';
import '../widgets/header.dart';
import '../widgets/side_menu.dart';

class CustomOrderScreen extends StatefulWidget {
  const CustomOrderScreen({Key? key}) : super(key: key);

  @override
  State<CustomOrderScreen> createState() => _CustomOrdersScreenState();
}

class _CustomOrdersScreenState extends State<CustomOrderScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      key: context.read<mc.MenuController>().getCustomOrderScaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              const Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
                // It takes 5/6 part of the screen
                flex: 5,
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Header(
                        showText: false,
                        fct: () {
                          context
                              .read<mc.MenuController>()
                              .controlCustomOrdersMenu();
                        },
                        title: 'Custom Orders',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CustomOrdersList(IsInDashboard: false),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
