import 'package:admin_panel_cc/widgets/products_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../consts/constants.dart';
import '../services/utils.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid(
      {Key? key,
      this.crossAxisCount = 4,
      this.childAspectRatio = 1,
      required this.mainScreen})
      : super(key: key);
  final int crossAxisCount;
  final double childAspectRatio;
  final bool mainScreen;
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    return StreamBuilder<QuerySnapshot>(
      //there was a null error just add those lines
      stream: FirebaseFirestore.instance.collection('products').snapshots(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: Text('No Products Added Yet!'),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            );
          }
        }
        return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: mainScreen && snapshot.data!.docs.length > 4
                ? 4
                : snapshot.data!.docs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: defaultPadding,
              mainAxisSpacing: defaultPadding,
            ),
            itemBuilder: (context, index) {
              return ProductWidget(
                id: snapshot.data!.docs[index]['id'],
              );
            });
      },
    );
  }
}
