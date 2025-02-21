import 'package:flutter_application_1/app/data/api.dart';
import 'package:flutter_application_1/app/data/sqlite.dart';
import 'package:flutter_application_1/app/model/cart.dart';
import 'package:flutter_application_1/app/model/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBuilder extends StatefulWidget {
  const HomeBuilder({Key? key}) : super(key: key);

  @override
  State<HomeBuilder> createState() => _HomeBuilderState();
}

class _HomeBuilderState extends State<HomeBuilder> {
  final DatabaseHelper _databaseService = DatabaseHelper();

  Future<List<ProductModel>> _getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository().getProductAdmin(
        prefs.getString('accountID').toString(),
        prefs.getString('token').toString());
  }

  Future<void> _onSave(ProductModel pro) async {
    Cart cartItem = Cart(
        productID: pro.id,
        name: pro.name,
        des: pro.description,
        price: pro.price,
        img: pro.imageUrl,
        count: 1);
    print("Sản phẩm : ${cartItem.toJson()}");
    await _databaseService.insertProduct(cartItem);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã thêm ${pro.name} vào giỏ hàng')),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: _getProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có sản phẩm nào'));
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              const Text("Trang chủ"),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final itemProduct = snapshot.data![index];
                    return _buildProduct(itemProduct, context);
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildProduct(ProductModel pro, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              height: 20,
              width: 20,
              alignment: Alignment.center,
              child: Text(
                pro.id.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            if (pro.imageUrl != null && pro.imageUrl!.isNotEmpty)
              Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(pro.imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: Alignment.center,
                child: Image.network(pro.imageUrl!),
              ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pro.name,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    NumberFormat('#,##0').format(pro.price),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(pro.description),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                await _onSave(pro); // Wait for onSave to complete
              },
              icon: const Icon(
                Icons.add,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
