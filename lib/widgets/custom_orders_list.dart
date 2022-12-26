import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../consts/constants.dart';
import 'custom_orders_widget.dart';
import 'orders_widget.dart';

class CustomOrdersList extends StatelessWidget {
  final bool IsInDashboard;
  const CustomOrdersList({Key? key, this.IsInDashboard = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      //there was a null error just add those lines
      stream: FirebaseFirestore.instance.collection('customOrders').snapshots(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data!.docs.isNotEmpty) {
            return Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: IsInDashboard && snapshot.data!.docs.length > 4
                      ? 4
                      : snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        CustomOrdersWidget(
                          address: snapshot.data!.docs[index]
                              ['shipping-address'],
                          contactNumber: snapshot.data!.docs[index]
                              ['contactNumber'],
                          customOrderId: snapshot.data!.docs[index]
                              ['customOrderId'],
                          userId: snapshot.data!.docs[index]['userId'],
                          orderDate: snapshot.data!.docs[index]['orderDate'],
                          imageUrl: snapshot.data!.docs[index]['imageUrl'],
                          userName: snapshot.data!.docs[index]['userName'],
                          desc: snapshot.data!.docs[index]['description'],
                          // address: snapshot.data!.docs[index]
                          //     ['shipping-address'],
                        ),
                        const Divider(
                          thickness: 3,
                        ),
                      ],
                    );
                  }),
            );
          } else {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: Text('No custom orders yet!'),
              ),
            );
          }
        }
        return const Center(
          child: Text(
            'Something went wrong',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        );
      },
    );
  }
}
