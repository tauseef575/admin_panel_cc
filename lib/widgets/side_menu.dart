import 'package:admin_panel_cc/inner_screens/all_orders_screen.dart';
import 'package:admin_panel_cc/inner_screens/all_products.dart';
import 'package:admin_panel_cc/inner_screens/custom_orders_screen.dart';
import 'package:admin_panel_cc/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../providers/dark_theme_provider.dart';
import '../screens/main_screen.dart';
import '../services/utils.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final themeState = Provider.of<DarkThemeProvider>(context);
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage('assets/images/logo.png'),
                    fit: BoxFit.scaleDown),
              ),
            ),
            // child: Image.asset(
            //   "assets/images/logo.png",
            // ),
          ),
          DrawerListTile(
            title: "Main",
            press: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const MainScreen(),
                ),
              );
            },
            icon: Icons.home_filled,
          ),
          DrawerListTile(
            title: "View all product",
            press: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllProductScreen()));
            },
            icon: Icons.store,
          ),
          DrawerListTile(
            title: "View all orders",
            press: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllOrdersScreen()));
            },
            icon: IconlyBold.bag_2,
          ),
          DrawerListTile(
            title: "View all custom orders",
            press: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CustomOrderScreen()));
            },
            icon: IconlyBold.edit,
          ),
          SwitchListTile(
              title: const Text(
                'Theme',
                style: TextStyle(fontSize: 16),
              ),
              secondary: Icon(themeState.getDarkTheme
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined),
              value: theme,
              onChanged: (value) {
                setState(() {
                  themeState.setDarkTheme = value;
                });
              })
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.press,
    required this.icon,
  }) : super(key: key);

  final String title;
  final VoidCallback press;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = theme == true ? Colors.white : Colors.black;

    return ListTile(
        onTap: press,
        horizontalTitleGap: 0.0,
        leading: Icon(
          icon,
          size: 18,
        ),
        title: TextWidget(
          text: title,
          color: color,
        ));
  }
}
