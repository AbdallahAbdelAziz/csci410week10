import 'package:flutter/material.dart';
import 'product.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  // controller to store product pid
  final TextEditingController _controllerID = TextEditingController();
  String _text = ''; // displays product info or error message

  @override
  void dispose() {
    _controllerID.dispose();
    super.dispose();
  }

  // update product info or display error message
  void update(String text) {
    setState(() {
      _text = text;
    });
  }

  // called when user clicks on the find button
  void getProduct() {
    try {
      int pid = int.parse(_controllerID.text);
      searchProduct(update, pid); // search asynchronously for product record
    }
    catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('wrong arguments')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 1'),
        centerTitle: true,
      ),
      body: Center(child: Column(children: [
        const SizedBox(height: 10),
        SizedBox(width: 200, child: TextField(controller: _controllerID, keyboardType: TextInputType.number,
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter ID'))),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: getProduct,
            child: const Text('Find', style: TextStyle(fontSize: 18))),
        const SizedBox(height: 10),
        Center(child: SizedBox(width: 200, child: Flexible(child: Text(_text,
            style: const TextStyle(fontSize: 18))))),
      ],

      ),

      ),
    );
  }
}