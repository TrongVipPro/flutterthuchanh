import 'dart:convert';

import 'package:flutter/material.dart';
import '../model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/mainpage.dart';

class Detail extends StatefulWidget {
  Detail({Key? key}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  // khi dùng tham số truyền vào phải khai báo biến trùng tên require
  User user = User.userEmpty();
  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;

    user = User.fromJson(jsonDecode(strUser));
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    // create style

    TextStyle mystyle = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.amber,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('User Detail'),
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image(
              image: NetworkImage(user.imageURL!),
              height: 200,
              width: 200,
            ),
            Text("NumberID: ${user.idNumber}", style: mystyle),
            Text("Fullname: ${user.fullName}", style: mystyle),
            Text("Phone Number: ${user.phoneNumber}", style: mystyle),
            Text("Gender: ${user.gender}", style: mystyle),
            Text("birthDay: ${user.birthDay}", style: mystyle),
            Text("schoolYear: ${user.schoolYear}", style: mystyle),
            Text("schoolKey: ${user.schoolKey}", style: mystyle),
            Text("dateCreated: ${user.dateCreated}", style: mystyle),
          ]),
        ),
      ),
    );
  }
Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
