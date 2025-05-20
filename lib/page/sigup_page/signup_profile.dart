import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/page/signin_page/login.dart';
import 'package:trademine/services/constants/api_constants.dart';
import 'package:trademine/utils/snackbar.dart';
import 'package:trademine/page/loading_page/loading_screen.dart';
import 'package:trademine/services/auth_service.dart';


class SignUpProfile extends StatefulWidget {
  const SignUpProfile({super.key});

  @override
  State<SignUpProfile> createState() => _SignupProfileState();
}

class _SignupProfileState extends State<SignUpProfile> {
  final _birthdayController = TextEditingController();
  File? _imageFile;
  String? selectedGender;
  DateTime? _selectedDate;
  final _username = TextEditingController();
  bool _isLoading = false;

  final List<String> optionsGender = ['Male', 'Female', 'Other'];

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2004),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthdayController.text = DateFormat(
          'dd/MM/yyyy',
        ).format(_selectedDate!);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      print(_imageFile);
    }
  }

  Future<void> ApiConnect() async {
    try {
      setState(() {
        _isLoading = true;
      });
      FocusScope.of(context).unfocus();
      LoadingScreen.show(context);

      final storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'token-register');
      LoadingScreen.hide(context);
      await AuthService.ProfileRegister(
        token.toString(),
        _username.text,
        _selectedDate!,
        selectedGender!,
        _imageFile!,
      );
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage ()),);

    } catch (e) {
        FocusScope.of(context).unfocus();
        LoadingScreen.hide(context);
        AppSnackbar.showError(context, e.toString());
        setState(() {
          _isLoading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Set Your Password',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Roboto', // ตั้งชื่อฟอนต์
                    letterSpacing: -1, // ระยะห่างระหว่างตัวอักษร
                  ),
                ),

                Text(
                  'Choose a strong password for your account.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Roboto',
                    letterSpacing: -1,
                  ),
                ),

                const SizedBox(height: 30),
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 75,
                        backgroundImage:
                            _imageFile != null
                                ? FileImage(_imageFile!) as ImageProvider
                                : AssetImage('assets/avatar/man.png'),
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blue,
                        child: IconButton(
                          onPressed: () {
                            _pickImage();
                          },
                          icon: Icon(Icons.edit, color: Colors.white, size: 25),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                TextFormField(
                  controller: _username,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    filled: true,
                    fillColor: Color(0xffE5E5E5),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _birthdayController,
                        onTap: () => _pickDate(context),
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Brithday',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                          hintText:
                              _selectedDate != null
                                  ? DateFormat(
                                    'dd/MM/yyyy',
                                  ).format(_selectedDate!)
                                  : 'Birthday',
                          filled: true,
                          fillColor: Color(0xffE5E5E5),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField(
                        value: selectedGender,
                        decoration: InputDecoration(hintText: 'Gender'),
                        borderRadius: BorderRadius.circular(20),
                        items:
                            optionsGender.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (newGender) {
                          setState(() {
                            selectedGender = newGender;
                          });
                        },
                        dropdownColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (_imageFile == null ||
                        _selectedDate == null ||
                        selectedGender == null ||
                        _username.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Missing required fields')),
                      );
                      return;
                    } else {
                      ApiConnect();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(MediaQuery.of(context).size.width, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Color(0xffFCA311),
                  ),
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
