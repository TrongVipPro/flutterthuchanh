import 'package:flutter_application_1/app/data/sqlite.dart';
import 'package:flutter_application_1/app/model/cart.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_application_1/app/page/home/home_screen.dart';
import 'package:flutter_application_1/mainpage.dart';
class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) :super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final DatabaseHelper _databaseService = DatabaseHelper();

 Future<List<Cart>> _getProducts() async {
  List<Cart> products = await _databaseService.products();
  print("Cart items: ${products.map((e) => e.toJson()).toList()}");
    return await _databaseService.products();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giỏ hàng của bạn"),
        backgroundColor: Colors.deepOrange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Mainpage()),
            );
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Giỏ hàng",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
          ),
          Expanded(
            flex: 11,
            child: FutureBuilder<List<Cart>>(
              future: _getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Giỏ hàng của bạn đang trống',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final cartItem = snapshot.data![index];
                    return ListTile(
                      title: Text(cartItem.name),
                      subtitle: Text('Số lượng: ${cartItem.count}'),
                      trailing: Text('Giá: ${cartItem.price}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}
