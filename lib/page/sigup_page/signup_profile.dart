import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/page/loading_page/loading_circle.dart';
import 'package:trademine/page/signin_page/login.dart';
import 'package:trademine/page/splash/splash_screen.dart';
import 'package:trademine/utils/snackbar.dart';
import 'package:trademine/services/auth_service.dart';

class SignUpProfile extends StatefulWidget {
  const SignUpProfile({super.key});

  @override
  State<SignUpProfile> createState() => _SignupProfileState();
}

class _SignupProfileState extends State<SignUpProfile> {
  final _birthdayController = TextEditingController();
  final _usernameController = TextEditingController();
  final List<String> optionsGender = ['Male', 'Female', 'Other'];

  File? _imageFile;
  String? selectedGender;
  DateTime? _selectedDate;
  bool _isLoading = false;

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
    FocusScope.of(context).unfocus();

    try {
      final storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'token-register');

      await AuthService.ProfileRegister(
        token.toString(),
        _usernameController.text,
        _selectedDate!,
        selectedGender!,
        _imageFile!,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
      );
    } catch (e) {
      AppSnackbar.showError(
        context,
        e.toString(),
        Icons.error,
        Theme.of(context).colorScheme.error,
      );
      setState(() => _isLoading = false);
    }
  }

  void _validateAndSubmit() {
    if (_selectedDate == null ||
        selectedGender == null ||
        _usernameController.text.isEmpty) {
      AppSnackbar.showError(
        context,
        'Missing required fields',
        Icons.error,
        Theme.of(context).colorScheme.error,
      );
    } else if (_imageFile == null) {
      AppSnackbar.showError(
        context,
        'Missing required Profile',
        Icons.error,
        Theme.of(context).colorScheme.error,
      );
    } else {
      _submitProfile();
    }
  }

  @override
  void dispose() {
    _birthdayController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: ListView(
            children: [
              Text(
                'Complete You Profile',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'Set up your profile details to get started.',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: 30),
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      child: CircleAvatar(
                        radius: 66,
                        backgroundImage:
                            _imageFile != null
                                ? FileImage(_imageFile!)
                                : AssetImage('assets/avatar/woman.png')
                                    as ImageProvider,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.edit, size: 20, color: Colors.white),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),
              TextFormField(
                controller: _usernameController,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: 'Username',
                  hintStyle: Theme.of(context).textTheme.bodyLarge,
                  prefixIcon: Icon(
                    Icons.account_box,
                    color: Theme.of(context).hintColor,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).dividerColor,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 20.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(20),
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
                        prefixIcon: Icon(
                          Icons.date_range,
                          color: Theme.of(context).hintColor,
                        ),
                        hintText:
                            _selectedDate != null
                                ? DateFormat(
                                  'dd/MM/yyyy',
                                ).format(_selectedDate!)
                                : 'Birthday',
                        hintStyle: Theme.of(context).textTheme.bodyLarge,
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
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 40),
              _isLoading
                  ? Center(child: LoadingCircle())
                  : ElevatedButton(
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
