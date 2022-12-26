import 'package:admin_panel_cc/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import '../consts/constants.dart';
import '../responsive.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.fct,
    required this.title,
    this.showText = true,
  }) : super(key: key);

  final Function fct;
  final String title;
  final bool showText;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              fct();
            },
          ),
        if (Responsive.isDesktop(context))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        if (Responsive.isDesktop(context))
          Spacer(flex: Responsive.isDesktop(context) ? 3 : 1),
        !showText
            ? Container()
            : Expanded(
                child: TextWidget(
                    text: 'Creamy Creations Admin Panel',
                    color: Colors.deepOrangeAccent,
                    textSize: 20),
                // child: TextField(
                //   decoration: InputDecoration(
                //     hintText: "Search",
                //     fillColor: Theme.of(context).cardColor,
                //     filled: true,
                //     border: const OutlineInputBorder(
                //       borderSide: BorderSide.none,
                //       borderRadius: BorderRadius.all(Radius.circular(20)),
                //     ),
                //     suffixIcon: InkWell(
                //       onTap: () {},
                //       child: Container(
                //         padding: const EdgeInsets.all(defaultPadding * 1),
                //         margin: const EdgeInsets.symmetric(
                //             horizontal: defaultPadding / 2),
                //         decoration: const BoxDecoration(
                //           color: Colors.deepOrangeAccent,
                //           borderRadius: BorderRadius.all(Radius.circular(50)),
                //         ),
                //         child: const Icon(
                //           Icons.search,
                //           color: Colors.white,
                //           size: 20,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // child: TextField(
                //   decoration: InputDecoration(
                //     hintText: "Search",
                //     fillColor: Theme.of(context).cardColor,
                //     filled: true,
                //     border: const OutlineInputBorder(
                //       borderSide: BorderSide.none,
                //       borderRadius: BorderRadius.all(Radius.circular(20)),
                //     ),
                //     suffixIcon: InkWell(
                //       onTap: () {},
                //       child: Container(
                //         padding: const EdgeInsets.all(defaultPadding * 1),
                //         margin: const EdgeInsets.symmetric(
                //             horizontal: defaultPadding / 2),
                //         decoration: const BoxDecoration(
                //           color: Colors.deepOrangeAccent,
                //           borderRadius: BorderRadius.all(Radius.circular(50)),
                //         ),
                //         child: const Icon(
                //           Icons.search,
                //           color: Colors.white,
                //           size: 20,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ),
      ],
    );
  }
}
