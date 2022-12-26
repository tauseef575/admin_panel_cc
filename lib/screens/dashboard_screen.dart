import 'package:admin_panel_cc/controllers/MenuController.dart' as mc;
import 'package:admin_panel_cc/inner_screens/add_prod.dart';
import 'package:admin_panel_cc/inner_screens/all_products.dart';
import 'package:admin_panel_cc/responsive.dart';
import 'package:admin_panel_cc/widgets/buttons.dart';
import 'package:admin_panel_cc/widgets/grid_products.dart';
import 'package:admin_panel_cc/widgets/orders_list.dart';
import 'package:admin_panel_cc/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../consts/constants.dart';
import '../services/utils.dart';
import '../widgets/header.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    Color color = Utils(context).color;

    return SafeArea(
      child: SingleChildScrollView(
        controller: ScrollController(),
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
              title: "Dashboard",
              fct: () {
                context.read<mc.MenuController>().controlDashboardMenu();
              },
            ),
            const SizedBox(height: defaultPadding),
            TextWidget(
                text: "Latest Products",
                color: color,
                isTitle: false,
                textSize: 22),
            const SizedBox(height: defaultPadding),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonsWidget(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AllProductScreen()));
                      },
                      text: "View All",
                      icon: Icons.remove_red_eye,
                      backgroundColor: Colors.deepOrangeAccent),
                  ButtonsWidget(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const UploadProductForm()));
                      },
                      text: "Add Product",
                      icon: Icons.add,
                      backgroundColor: Colors.deepOrangeAccent)
                ],
              ),
            ),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  // flex: 5,
                  child: Column(
                    children: [
                      Responsive(
                        mobile: ProductGrid(
                          mainScreen: true,
                          crossAxisCount: size.width < 650 ? 2 : 4,
                          childAspectRatio:
                              size.width < 650 && size.width > 350 ? 1.1 : 0.8,
                        ),
                        desktop: ProductGrid(
                          mainScreen: true,
                          childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextWidget(
                          text: "Recent Orders",
                          color: color,
                          isTitle: false,
                          textSize: 22),
                      const SizedBox(height: 25),
                      const OrdersList(),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
