import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../consts/constants.dart';
import '../controllers/MenuController.dart' as mc;
import '../responsive.dart';
import '../services/utils.dart';
import '../widgets/grid_products.dart';
import '../widgets/header.dart';
import '../widgets/side_menu.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({Key? key}) : super(key: key);

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      key: context.read<mc.MenuController>().getGridScaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(children: [
                  Header(
                    title: "All Products",
                    fct: () {
                      context.read<mc.MenuController>().controlProductsMenu();
                    },
                  ),
                  const SizedBox(height: defaultPadding),
                  Responsive(
                    mobile: ProductGrid(
                      mainScreen: false,
                      crossAxisCount: size.width < 650 ? 2 : 4,
                      childAspectRatio:
                          size.width < 650 && size.width > 350 ? 1.1 : 0.8,
                    ),
                    desktop: ProductGrid(
                      mainScreen: false,
                      childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                    ),
                  )
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
