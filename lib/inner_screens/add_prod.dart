import 'dart:io';
import 'package:admin_panel_cc/consts/constants.dart';
import 'package:admin_panel_cc/screens/loading_manager.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:admin_panel_cc/controllers/MenuController.dart' as mc;
import 'package:admin_panel_cc/services/utils.dart';
import 'package:admin_panel_cc/widgets/buttons.dart';
import 'package:admin_panel_cc/widgets/header.dart';
import 'package:admin_panel_cc/widgets/side_menu.dart';
import 'package:admin_panel_cc/widgets/text_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../responsive.dart';
import 'package:dotted_border/dotted_border.dart';
import '../services/global_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadProductForm extends StatefulWidget {
  static const routeName = '/UploadProductForm';

  const UploadProductForm({Key? key}) : super(key: key);

  @override
  _UploadProductFormState createState() => _UploadProductFormState();
}

class _UploadProductFormState extends State<UploadProductForm> {
  final _formKey = GlobalKey<FormState>();
  String _catValue = 'Cake';
  late final TextEditingController _titleController,
      _priceController,
      _descController;
  int _groupValue = 1;
  bool isPound = false;
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);

  @override
  void initState() {
    _priceController = TextEditingController();
    _titleController = TextEditingController();
    _descController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  void _uploadForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      if (_pickedImage == null) {
        GlobalMethods.errorDialog(
            subtitle: 'Please pick an image first!', context: context);
        return;
      }
      final _uuid = const Uuid().v4();
      try {
        setState(() {
          _isLoading = true;
        });
        final ref = FirebaseStorage.instance
            .ref()
            .child('productsImages')
            .child('$_uuid.jpg');

        if (kIsWeb) /* if web */ {
          // putData() accepts Uint8List type argument
          await ref.putData(webImage).whenComplete(() async {
            final imageUri = await ref.getDownloadURL();
            await FirebaseFirestore.instance
                .collection("products")
                .doc(_uuid)
                .set({
              'id': _uuid,
              'title': _titleController.text,
              'price': _priceController.text,
              'description': _descController.text,
              'salePrice': 0.1,
              'imageUrl': imageUri.toString(),
              'productCategoryName': _catValue,
              'isOnSale': false,
              'isPound': isPound,
              'createdAt': Timestamp.now(),
            });
          });
        } else /* if mobile */ {
          // putFile() accepts File type argument
          await ref.putFile(_pickedImage!).whenComplete(() async {
            final imageUri = await ref.getDownloadURL();
            await FirebaseFirestore.instance
                .collection("products")
                .doc(_uuid)
                .set({
              'id': _uuid,
              'title': _titleController.text,
              'price': _priceController.text,
              'description': _descController.text,
              'salePrice': 0.1,
              'imageUrl': imageUri.toString(),
              'productCategoryName': _catValue,
              'isOnSale': false,
              'isPound': isPound,
              'createdAt': Timestamp.now(),
            });
          });
        }
        Fluttertoast.showToast(
          msg: "Product uploaded successfully!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          // backgroundColor: ,
          // textColor: ,
          // fontSize: 16.0
        );
        _clearForm();
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subtitle: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearForm() {
    _priceController.clear();
    _titleController.clear();
    _descController.clear();
    isPound = false;
    _groupValue = 1;
    setState(() {
      _pickedImage = null;
      webImage = Uint8List(8);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = Utils(context).color;
    final _scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    Size size = Utils(context).getScreenSize;

    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: _scaffoldColor,
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1.0,
        ),
      ),
    );
    return Scaffold(
      key: context.read<mc.MenuController>().getAddProductScaffoldKey,
      drawer: const SideMenu(),
      body: LoadingManager(
        isLoading: _isLoading,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              const Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  children: [
                    Header(
                      showText: false,
                      fct: () {
                        context
                            .read<mc.MenuController>()
                            .controlAddProductsMenu();
                      },
                      title: 'Add New Product',
                    ),
                    Container(
                      width: size.width > 650 ? 650 : size.width,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        color: Theme.of(context).cardColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextWidget(
                              text: 'Product title*',
                              color: color,
                              isTitle: true,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _titleController,
                              key: const ValueKey('Title'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a Title';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18)),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent,
                                        width: 0.7)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18)),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent,
                                        width: 0.7)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18)),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent,
                                        width: 0.7)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18)),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent,
                                        width: 0.7)),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            //Description TextField
                            TextWidget(
                              text: 'Product Description',
                              color: color,
                              isTitle: true,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _descController,
                              key: const ValueKey('Description'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a Description';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18)),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent,
                                        width: 0.7)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18)),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent,
                                        width: 0.7)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18)),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent,
                                        width: 0.7)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18)),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent,
                                        width: 0.7)),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: FittedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        TextWidget(
                                          text: 'Price in RS*',
                                          color: color,
                                          isTitle: true,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: TextFormField(
                                            controller: _priceController,
                                            key: const ValueKey('Price \$'),
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Price is missed';
                                              }
                                              return null;
                                            },
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9.]')),
                                            ],
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(18)),
                                                  borderSide: BorderSide(
                                                      color: Colors
                                                          .deepOrangeAccent,
                                                      width: 0.7)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(18)),
                                                  borderSide: BorderSide(
                                                      color: Colors
                                                          .deepOrangeAccent,
                                                      width: 0.7)),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(18)),
                                                  borderSide: BorderSide(
                                                      color: Colors
                                                          .deepOrangeAccent,
                                                      width: 0.7)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(18)),
                                                  borderSide: BorderSide(
                                                      color: Colors
                                                          .deepOrangeAccent,
                                                      width: 0.7)),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        TextWidget(
                                          text: 'Product category*',
                                          color: color,
                                          isTitle: true,
                                        ),
                                        const SizedBox(height: 10),
                                        _categoryDropDown(),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextWidget(
                                          text: 'Measure unit*',
                                          color: color,
                                          isTitle: true,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            TextWidget(
                                                text: "Kg", color: color),
                                            Radio(
                                                value: 1,
                                                groupValue: _groupValue,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _groupValue = 1;
                                                    isPound = false;
                                                  });
                                                },
                                                activeColor:
                                                    Colors.deepOrangeAccent),
                                            TextWidget(
                                                text: "Piece", color: color),
                                            Radio(
                                              value: 2,
                                              groupValue: _groupValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  _groupValue = 2;
                                                  isPound = true;
                                                });
                                              },
                                              activeColor:
                                                  Colors.deepOrangeAccent,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                // Image to be picked code is here
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: size.width > 650
                                            ? 350
                                            : size.width * 0.45,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        child: _pickedImage == null
                                            ? dottedBorder(color: color)
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: kIsWeb
                                                    ? Image.memory(webImage,
                                                        fit: BoxFit.fill)
                                                    : Image.file(_pickedImage!,
                                                        fit: BoxFit.fill),
                                              ),
                                      )),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: FittedBox(
                                      child: Column(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _pickedImage = null;
                                                webImage = Uint8List(8);
                                              });
                                            },
                                            child: TextWidget(
                                              text: 'Clear',
                                              color: Colors.red,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {},
                                            child: TextWidget(
                                              text: 'Update image',
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ButtonsWidget(
                                    onPressed: () {
                                      _clearForm();
                                    },
                                    text: 'Clear form',
                                    icon: IconlyBold.danger,
                                    backgroundColor: Colors.red.shade300,
                                  ),
                                  ButtonsWidget(
                                    onPressed: () {
                                      _uploadForm();
                                    },
                                    text: 'Upload',
                                    icon: IconlyBold.upload,
                                    backgroundColor: Colors.blue,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedImage = selected;
        });
      } else {
        print('No image has been picked');
      }
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          _pickedImage = File('a');
        });
      } else {
        print('No image has been picked');
      }
    } else {
      print('Something went wrong');
    }
  }

  Widget dottedBorder({
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          _pickImage();
        },
        child: DottedBorder(
            dashPattern: const [10],
            borderType: BorderType.RRect,
            color: color,
            radius: const Radius.circular(12),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_outlined,
                    color: color,
                    size: 50,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextWidget(
                    text: 'Choose an image',
                    color: Colors.deepOrangeAccent,
                  )
                ],
              ),
            )),
      ),
    );
  }

  Widget _categoryDropDown() {
    final color = Utils(context).color;
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(18))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
          style: const TextStyle(
            color: Colors.deepOrangeAccent,
            fontWeight: FontWeight.w300,
            fontSize: 15,
          ),
          value: _catValue,
          onChanged: (value) {
            setState(() {
              _catValue = value!;
            });
            print(_catValue);
          },
          hint: const Text('Select a category'),
          items: const [
            DropdownMenuItem(
              value: 'Cake',
              child: Text(
                'Cake',
              ),
            ),
            DropdownMenuItem(
              value: 'Breads',
              child: Text(
                'Breads',
              ),
            ),
            DropdownMenuItem(
              value: 'Pizza',
              child: Text(
                'Pizza',
              ),
            ),
            DropdownMenuItem(
              value: 'Sweets',
              child: Text(
                'Sweets',
              ),
            ),
            DropdownMenuItem(
              value: 'Patties',
              child: Text(
                'Patties',
              ),
            ),
            DropdownMenuItem(
              value: 'Pastries',
              child: Text(
                'Pastries',
              ),
            )
          ],
        )),
      ),
    );
  }
}
