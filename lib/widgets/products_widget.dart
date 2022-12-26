// ignore_for_file: library_private_types_in_public_api, sort_child_properties_last

import 'package:admin_panel_cc/inner_screens/edit_prod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/global_method.dart';
import '../services/utils.dart';
import 'text_widget.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;
  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  String title = '';
  String description = '';
  String productCat = '';
  String? imageUrl;
  String price = '0.0';
  double salePrice = 0.0;
  bool isOnSale = false;
  bool isPound = false;

  @override
  void initState() {
    getProductsData();
    super.initState();
  }

  Future<void> getProductsData() async {
    try {
      final DocumentSnapshot productsDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.id)
          .get();
      if (productsDoc == null) {
        return;
      } else {
        // Add if mounted here
        if (mounted) {
          setState(() {
            title = productsDoc.get('title');
            description = productsDoc.get('description');
            productCat = productsDoc.get('productCategoryName');
            imageUrl = productsDoc.get('imageUrl');
            price = productsDoc.get('price');
            salePrice = productsDoc.get('salePrice');
            isOnSale = productsDoc.get('isOnSale');
            isPound = productsDoc.get('isPound');
          });
        }
      }
    } catch (error) {
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final color = Utils(context).color;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).cardColor.withOpacity(0.9),
        child: InkWell(
          borderRadius: BorderRadius.circular(18.0),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditProductScreen(
                    id: widget.id,
                    title: title,
                    desc: description,
                    price: price,
                    salePrice: salePrice,
                    productCat: productCat,
                    imageUrl:
                        imageUrl == null ? 'assets/images/box.png' : imageUrl!,
                    isOnSale: isOnSale,
                    isPound: isPound)));
          },
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Image.network(
                        imageUrl == null ? 'assets/images/box.png' : imageUrl!,
                        fit: BoxFit.fitWidth,
                        // width: screenWidth * 0.12,
                        height: size.width * 0.12,
                      ),
                    ),
                    // const Spacer(),
                    // PopupMenuButton(
                    //     itemBuilder: (context) => [
                    //           PopupMenuItem(
                    //             onTap: () {},
                    //             child: const Text('Edit'),
                    //             value: 1,
                    //           ),
                    //           PopupMenuItem(
                    //             onTap: () {},
                    //             child: const Text(
                    //               'Delete',
                    //               style: TextStyle(color: Colors.red),
                    //             ),
                    //             value: 2,
                    //           ),
                    //         ])
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Row(
                    children: [
                      TextWidget(
                        text: isOnSale
                            ? 'Rs.${salePrice.toStringAsFixed(2)}'
                            : 'Rs.$price',
                        color: color,
                        textSize: 18,
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Visibility(
                          visible: isOnSale,
                          child: Text(
                            'Rs.$price',
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: color),
                          )),
                      const Spacer(),
                      TextWidget(
                        text: isPound ? 'Piece' : 'Kg',
                        color: color,
                        textSize: 18,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                TextWidget(
                  text: title,
                  color: color,
                  textSize: 22,
                  isTitle: true,
                ),
                const SizedBox(
                  height: 2,
                ),
                Flexible(
                  child: TextWidget(
                    text: description,
                    color: color,
                    textSize: 14,
                    isTitle: false,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
