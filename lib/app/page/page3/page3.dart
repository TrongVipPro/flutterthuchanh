import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/app/data/sqlite.dart';
import 'package:flutter_application_1/app/model/bill.dart';
import 'package:flutter_application_1/app/model/cart.dart';

class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  final DatabaseHelper _databaseService = DatabaseHelper();
  List<Cart> cartItems = [];
  String fullName = '';
  int total = 0;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    List<Cart> items = await _databaseService.products();
    setState(() {
      cartItems = items;
      total = items.fold(0, (sum, item) => sum + (item.price * item.count).toInt());
    });
  }

  Future<void> _saveBill() async {
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giỏ hàng trống')),
      );
      return;
    }

    final bill = BillModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName,
      dateCreated: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
      total: total,
      items: cartItems.map((e) => BillDetailModel(
        productId: e.productID,
        productName: e.name,
        imageUrl: e.img,
        price: e.price,
        count: e.count,
        total: e.price * e.count,
      )).toList(),
    );

    await _databaseService.insertBill(bill);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hóa đơn đã được lưu')),
    );

    await _databaseService.clear();
    await _loadCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo Hóa Đơn'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin khách hàng',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  fullName = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Họ và tên'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Giỏ hàng',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('Số lượng: ${item.count}'),
                    trailing: Text('Giá: ${item.price}'),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Tổng cộng: $total',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveBill,
              child: const Text('Lưu Hóa Đơn'),
            ),
          ],
        ),
      ),
    );
  }
}
