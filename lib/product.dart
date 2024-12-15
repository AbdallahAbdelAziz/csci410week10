import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// main URL for REST pages
const String _baseURL = 'csci410fall2023.atwebpages.com';

// class to represent a row from the products table
// note: cid is replaced by category name
class Product {
  final int _pid;
  final String _name;
  final int _quantity;
  final double _price;
  final String _category;

  Product(this._pid, this._name, this._quantity, this._price, this._category);

  @override
  String toString() {
    return 'PID: $_pid Name: $_name\nQuantity: $_quantity \nPrice: \$$_price\nCategory: $_category';
  }
}
// list to hold products retrieved from getProducts
List<Product> _products = [];
// asynchronously update _products list
void updateProducts(Function(bool success) update) async {
  try {
    final url = Uri.http(_baseURL, 'getProducts.php');
    final response = await http.get(url)
        .timeout(const Duration(seconds: 5)); // max timeout 5 seconds
    _products.clear(); // clear old products
    if (response.statusCode == 200) { // if successful call
      final jsonResponse = convert.jsonDecode(response.body); // create dart json object from json array
      for (var row in jsonResponse) { // iterate over all rows in the json array
        Product p = Product( // create a product object from JSON row object
            int.parse(row['pid']),
            row['name'],
            int.parse(row['quantity']),
            double.parse(row['price']),
            row['category']);
        _products.add(p); // add the product object to the _products list
      }
      update(true); // callback update method to inform that we completed retrieving data
    }
  }
  catch(e) {
    update(false); // inform through callback that we failed to get data
  }
}

// searches for a single product using product pid
void searchProduct(Function(String text) update, int pid) async {
  try {
    final url = Uri.http(_baseURL, 'searchProduct.php', {'pid':'$pid'});
    final response = await http.get(url)
        .timeout(const Duration(seconds: 5));
    _products.clear();
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      var row = jsonResponse[0];
      Product p = Product(
          int.parse(row['pid']),
          row['name'],
          int.parse(row['quantity']),
          double.parse(row['price']),
          row['category']);
      _products.add(p);
      update(p.toString());
    }
  }
  catch(e) {
    update("can't load data");
  }
}

// shows products stored in the _products list as a ListView
class ShowProducts extends StatelessWidget {
  const ShowProducts({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) => Column(children: [
          const SizedBox(height: 10),
          Container(
              color: index % 2 == 0 ? Colors.amber: Colors.cyan,
              padding: const EdgeInsets.all(5),
              width: width * 0.9, child: Row(children: [
            SizedBox(width: width * 0.15),
            Flexible(child: Text(_products[index].toString(), style: TextStyle(fontSize: width * 0.045)))
          ]))
        ])
    );
  }
}