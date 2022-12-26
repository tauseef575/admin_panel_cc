// ignore_for_file: library_private_types_in_public_api

import 'package:admin_panel_cc/consts/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel_cc/services/utils.dart';

import 'text_widget.dart';

class CustomOrdersWidget extends StatefulWidget {
  const CustomOrdersWidget(
      {Key? key,
      required this.address,
      required this.contactNumber,
      required this.customOrderId,
      required this.userId,
      required this.imageUrl,
      required this.userName,
      required this.orderDate,
      required this.desc})
      : super(key: key);
  final String contactNumber;
  final String customOrderId, userId, imageUrl, userName, address, desc;
  final Timestamp orderDate;
  @override
  _CustomOrdersWidgetState createState() => _CustomOrdersWidgetState();
}

class _CustomOrdersWidgetState extends State<CustomOrdersWidget> {
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
                      height: defaultPadding,
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          TextWidget(
                            text: 'Contact Number: ',
                            color: color,
                            textSize: 16,
                            isTitle: true,
                          ),
                          TextWidget(
                            text: ' ${widget.contactNumber}',
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
                            text: 'Order Date: ',
                            color: color,
                            textSize: 16,
                            isTitle: true,
                          ),
                          TextWidget(text: orderDateStr, color: color),
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
                          TextWidget(text: widget.address, color: color),
                        ],
                      ),
                    ),
                    TextWidget(
                      text: 'Details',
                      color: color,
                      isTitle: true,
                      textSize: 16,
                    ),
                    TextWidget(text: widget.desc, color: color),
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
