import 'package:flutter/material.dart';

import './products.dart';

class ProductManager extends StatelessWidget {
  /* final Map<String, dynamic> startingProduct;

  ProductManager({this.startingProduct}) {
    print('[ProductManager Widget] Constructor');
  }

  @override
  State<StatefulWidget> createState() {
    print('[ProductManager Widget] createState()');
    return _ProductManagerState();
  }
}

class _ProductManagerState extends State<ProductManager> {
  List<Map<String, dynamic>> _products = []; */

  /* @override
  void initState() {
    print('[ProductManager State] initState()');
    if (widget.startingProduct != null) {
      _products.add(widget.startingProduct);
    }
    super.initState();
  } 

  @override
  void didUpdateWidget(ProductManager oldWidget) {
    print('[ProductManager State] didUpdateWidget()');
    super.didUpdateWidget(oldWidget);
  }*/

  final List<Map<String, dynamic>> products;
  
  ProductManager(this.products);

  @override
  Widget build(BuildContext context) {
    print('[ProductManager State] build()');
    return Column(
      children: [
        
        Expanded(child: Products(products))
      ],
    );
  }
}
