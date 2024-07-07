import 'package:flutter_application_1/app/data/api.dart';
import 'package:flutter_application_1/app/model/register.dart';
import 'package:flutter_application_1/app/page/auth/login.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>(); // Thêm GlobalKey
  int _gender = 0;
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _numberIDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _schoolKeyController = TextEditingController();
  final TextEditingController _schoolYearController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();
  final TextEditingController _imageURL = TextEditingController();
  bool _isPasswordVisible = false; //theo doi trang thai hien thi

  Future<String> register() async {
    return await APIRepository().register(Signup(
      accountID: _accountController.text,
      birthDay: _birthDayController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      fullName: _fullNameController.text,
      phoneNumber: _phoneNumberController.text,
      schoolKey: _schoolKeyController.text,
      schoolYear: _schoolYearController.text,
      gender: getGender(),
      imageUrl: _imageURL.text,
      numberID: _numberIDController.text,
    ));
  }

  getGender() {
    if (_gender == 1) {
      return "Male";
    } else if (_gender == 2) {
      return "Female";
    }
    return "Other";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đăng kí"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey, // Gắn GlobalKey vào Form
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Thông tin đăng kí',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                  signUpWidget(),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              String response = await register();
                              if (response == "ok") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Đăng kí thành công!'),
                                  ),
                                );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const LoginScreen()));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(response),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text('Đăng kí'),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget textField(
    TextEditingController controller, String label, IconData icon, bool isPassword) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? !_isPasswordVisible : false, // Hiển thị hoặc ẩn mật khẩu
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Nhập $label';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          icon: Icon(icon),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget signUpWidget() {
    return Column(
      children: [
        textField(_accountController, "Account", Icons.person, false),
        textField(_passwordController, "Password", Icons.password, true),
        textField(_confirmPasswordController, "Confirm password", Icons.password, true),
        textField(_fullNameController, "Full Name", Icons.text_fields_outlined, false),
        textField(_numberIDController, "NumberID", Icons.key, false),
        textField(_phoneNumberController, "PhoneNumber", Icons.phone, false),
        textField(_birthDayController, "BirthDay", Icons.date_range, false),
        textField(_schoolYearController, "SchoolYear", Icons.school, false),
        textField(_schoolKeyController, "SchoolKey", Icons.school, false),
        const Text("What is your Gender?"),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: const Text("Male"),
                leading: Transform.translate(
                    offset: const Offset(16, 0),
                    child: Radio(
                      value: 1,
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    )),
              ),
            ),
            Expanded(
              child: ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text("Female"),
                  leading: Transform.translate(
                    offset: const Offset(16, 0),
                    child: Radio(
                      value: 2,
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                  )),
            ),
            Expanded(
                child: ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: const Text("Other"),
              leading: Transform.translate(
                  offset: const Offset(16, 0),
                  child: Radio(
                    value: 3,
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  )),
            )),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _imageURL,
          decoration: const InputDecoration(
            labelText: "Image URL",
            icon: Icon(Icons.image),
          ),
        ),
      ],
    );

  //}
  // @override
  // void dispose() {
  //   _accountController.dispose();
  //   _fullNameController.dispose();
  //   _numberIDController.dispose();
  //   _passwordController.dispose();
  //   _confirmPasswordController.dispose();
  //   _phoneNumberController.dispose();
  //   _schoolKeyController.dispose();
  //   _schoolYearController.dispose();
  //   _birthDayController.dispose();
  //   _imageURL.dispose();
  //   super.dispose();
  }
}
