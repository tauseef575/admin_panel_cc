// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MenuController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _gridScaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _ordersScaffoldKey =
      GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _addProductScaffoldKey =
      GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _customOrderScaffoldKey =
      GlobalKey<ScaffoldState>();

  // Getters
  GlobalKey<ScaffoldState> get getScaffoldKey => _scaffoldKey;

  GlobalKey<ScaffoldState> get getGridScaffoldKey => _gridScaffoldKey;

  GlobalKey<ScaffoldState> get getAddProductScaffoldKey =>
      _addProductScaffoldKey;

  GlobalKey<ScaffoldState> get getCustomOrderScaffoldKey =>
      _customOrderScaffoldKey;

  GlobalKey<ScaffoldState> get getOrdersScaffoldKey => _ordersScaffoldKey;

  // Callbacks
  void controlDashboardMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  void controlProductsMenu() {
    if (!_gridScaffoldKey.currentState!.isDrawerOpen) {
      _gridScaffoldKey.currentState!.openDrawer();
    }
  }

  void controlAllOrders() {
    if (!_ordersScaffoldKey.currentState!.isDrawerOpen) {
      _ordersScaffoldKey.currentState!.openDrawer();
    }
  }

  void controlAddProductsMenu() {
    if (!_addProductScaffoldKey.currentState!.isDrawerOpen) {
      _addProductScaffoldKey.currentState!.openDrawer();
    }
  }

  void controlCustomOrdersMenu() {
    if (!_customOrderScaffoldKey.currentState!.isDrawerOpen) {
      _customOrderScaffoldKey.currentState!.openDrawer();
    }
  }
}
