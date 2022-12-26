// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel_cc/services/utils.dart';

import 'text_widget.dart';

class OrdersWidget extends StatefulWidget {
  const OrdersWidget(
      {Key? key,
      required this.address,
      required this.price,
      required this.totalPrice,
      required this.productId,
      required this.userId,
      required this.imageUrl,
      required this.userName,
      required this.quantity,
      required this.orderDate,
      required this.payM})
      : super(key: key);
  final double price, totalPrice;
  final String productId, userId, imageUrl, userName, address, payM;
  final int quantity;
  final Timestamp orderDate;
  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  late String orderDateStr;
  @override
  void initState() {
    var postDate = widget.orderDate.toDate();
    orderDateStr = '${postDate.day}/${postDate.month}/${postDate.year}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    Color color = theme == true ? Colors.white : Colors.black;
    Size size = Utils(context).getScreenSize;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).cardColor.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: size.width < 650 ? 3 : 1,
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.fill,
                  // height: screenWidth * 0.15,
                  // width: screenWidth * 0.15,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: 'Order Information',
                      color: color,
                      textSize: 20,
                      isTitle: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextWidget(
                      text:
                          '${widget.quantity}x For Rs.${widget.price.toString()}',
                      color: color,
                      textSize: 16,
                      isTitle: true,
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          TextWidget(
                            text: 'By',
                            color: Colors.orangeAccent,
                            textSize: 16,
                            isTitle: true,
                          ),
                          TextWidget(
                            text: ' ${widget.userName}',
                            color: color,
                            textSize: 16,
                            isTitle: false,
                          ),
                        ],
                      ),
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          TextWidget(
                            text: 'Payment Method: ',
                            color: color,
                            textSize: 16,
                            isTitle: true,
                          ),
                          TextWidget(text: '${widget.payM}', color: color),
                        ],
                      ),
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          TextWidget(
                            text: 'Address: ',
                            color: color,
                            textSize: 16,
                            isTitle: true,
                          ),
                          TextWidget(text: '${widget.address}', color: color),
                        ],
                      ),
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          TextWidget(
                            text: 'Order Date: ',
                            color: color,
                            textSize: 16,
                            isTitle: true,
                          ),
                          TextWidget(text: orderDateStr, color: color),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
