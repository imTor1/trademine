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
  final _username = TextEditingController();
  final List<String> optionsGender = ['Male', 'Female', 'Other'];

  File? _imageFile;
  String? selectedGender;
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _birthdayController.dispose();
    _username.dispose();
    super.dispose();
  }

  void _showCupertinoDatePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 250,
          child: CupertinoDatePicker(
            initialDateTime: _selectedDate ?? DateTime(2004),
            mode: CupertinoDatePickerMode.date,
            minimumDate: DateTime(1960),
            maximumDate: DateTime.now(),
            onDateTimeChanged: (DateTime picked) {
              setState(() {
                _selectedDate = picked;
                _birthdayController.text = DateFormat(
                  'dd/MM/yyyy',
                ).format(picked);
              });
            },
          ),
        );
      },
    );
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
    }
  }

  Future<void> _submitProfile() async {
    setState(() => _isLoading = true);
    LoadingScreen.show(context);
    FocusScope.of(context).unfocus();

    try {
      final storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'token-register');

      await AuthService.ProfileRegister(
        token.toString(),
        _username.text,
        _selectedDate!,
        selectedGender!,
        _imageFile!,
      );

      LoadingScreen.hide(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      LoadingScreen.hide(context);
      AppSnackbar.showError(context, e.toString());
      setState(() => _isLoading = false);
    }
  }

  void _validateAndSubmit() {
    if (_selectedDate == null ||
        selectedGender == null ||
        _username.text.isEmpty) {
      AppSnackbar.showError(context, 'Missing required fields');
    } else if (_imageFile == null) {
      AppSnackbar.showError(context, 'Missing required Profile');
    } else {
      _submitProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Set Your Password',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'Choose a strong password for your account.',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: 30),
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 4.0,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage:
                            _imageFile != null
                                ? FileImage(_imageFile!)
                                : AssetImage('assets/avatar/woman.png')
                                    as ImageProvider,
                      ),
                    ),
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: IconButton(
                        onPressed: _pickImage,
                        icon: Icon(Icons.edit, color: Colors.white, size: 25),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),
              TextFormField(
                controller: _username,
                decoration: InputDecoration(
                  hintText: 'Username',
                  hintStyle: Theme.of(context).textTheme.bodySmall,
                  filled: true,
                  fillColor: Theme.of(context).dividerColor,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).disabledColor,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _birthdayController,
                      onTap: _showCupertinoDatePicker,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText:
                            _selectedDate != null
                                ? DateFormat(
                                  'dd/MM/yyyy',
                                ).format(_selectedDate!)
                                : 'Birthday',
                        hintStyle: Theme.of(context).textTheme.bodySmall,
                        filled: true,
                        fillColor: Theme.of(context).dividerColor,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).disabledColor,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap:
                          () => showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height: 150,
                                child: CupertinoPicker(
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  itemExtent: 32.0,
                                  scrollController: FixedExtentScrollController(
                                    initialItem: optionsGender.indexOf(
                                      selectedGender ?? optionsGender[0],
                                    ),
                                  ),
                                  onSelectedItemChanged: (int index) {
                                    setState(() {
                                      selectedGender = optionsGender[index];
                                    });
                                  },
                                  children:
                                      optionsGender
                                          .map((gender) => Text(gender))
                                          .toList(),
                                ),
                              );
                            },
                          ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Text(
                          selectedGender ?? 'Gender',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _validateAndSubmit,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
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
    );
  }
}
