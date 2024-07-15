// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_application_1/app/data/api.dart';
import 'package:flutter_application_1/app/model/bill.dart';
import 'package:flutter_application_1/app/page/history/history_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/mainpage.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Future<List<BillModel>> _getBills() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository().getHistory(prefs.getString('token').toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch sử mua hàng"),
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
      body: FutureBuilder<List<BillModel>>(
        future: _getBills(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Không có lịch sử',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final itemBill = snapshot.data![index];
                return _billWidget(itemBill, context);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _billWidget(BillModel bill, BuildContext context) {
    return InkWell(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var temp = await APIRepository()
            .getHistoryDetail(bill.id, prefs.getString('token').toString());
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HistoryDetail(bill: temp)));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Text(
                  bill.id,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bill.fullName,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '${NumberFormat('#,##0').format(bill.total)} VND',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Date: ${bill.dateCreated}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
