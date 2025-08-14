import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/utils/snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trademine/bloc/user_cubit.dart';
import 'package:trademine/services/constants/api_constants.dart';
import 'package:trademine/services/user_service.dart';
import 'package:trademine/utils/snackbar.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthdayDisplayController = TextEditingController();
  final _genderController = TextEditingController();

  final List<String> optionsGender = ['Male', 'Female', 'Other'];
  File? _imageFile;
  String? selectedGender;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    final user = context.read<UserCubit>().state;

    _usernameController.text = user.name ?? '';
    _emailController.text = user.email ?? '';
    selectedGender =
        user.gender?.isNotEmpty == true ? capitalize(user.gender!) : null;

    if (user.birthday != null && user.birthday!.isNotEmpty) {
      try {
        _selectedDate = DateFormat('yyyy-MM-dd').parse(user.birthday!);
        _birthdayDisplayController.text = DateFormat(
          'dd/MM/yyyy',
        ).format(_selectedDate!);
      } catch (_) {
        _birthdayDisplayController.text = '';
      }
    }
  }

  String capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  DateTime _getMaximumAllowedDate() {
    DateTime now = DateTime.now();
    return DateTime(now.year - 20, now.month, now.day);
  }

  void _showGenderPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          color: CupertinoColors.white,
          height: 200,
          child: CupertinoPicker(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            itemExtent: 32.0,
            scrollController: FixedExtentScrollController(
              initialItem:
                  selectedGender != null
                      ? optionsGender.indexOf(selectedGender!)
                      : 0,
            ),
            onSelectedItemChanged: (int index) {
              setState(() {
                selectedGender = optionsGender[index];
                _genderController.text = selectedGender!;
              });
            },
            children: optionsGender.map((gender) => Text(gender)).toList(),
          ),
        );
      },
    );
  }

  void _showCupertinoDatePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 250,
          color: CupertinoColors.white,
          child: CupertinoDatePicker(
            initialDateTime: _selectedDate ?? _getMaximumAllowedDate(),
            mode: CupertinoDatePickerMode.date,
            minimumDate: DateTime(1900),
            maximumDate: _getMaximumAllowedDate(),
            onDateTimeChanged: (DateTime picked) {
              setState(() {
                _selectedDate = picked;
                _birthdayDisplayController.text = DateFormat(
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

  Future<void> _editProfile() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');
    final user = context.read<UserCubit>().state;

    if (token == null) {
      AppSnackbar.showError(
        context,
        'Token not found',
        Icons.error,
        Colors.red,
      );
      return;
    }

    try {
      final userId = await storage.read(key: 'user_Id');

      final updatedUsername =
          _usernameController.text.trim().isNotEmpty
              ? _usernameController.text.trim()
              : user.name ?? '';

      DateTime updatedBirthday;
      if (_selectedDate != null) {
        updatedBirthday = _selectedDate!;
      } else {
        try {
          updatedBirthday = DateFormat(
            'yyyy-MM-dd',
          ).parse(user.birthday ?? '2000-01-01');
        } catch (_) {
          updatedBirthday = DateTime(2000, 1, 1); // fallback
        }
      }

      final updatedGender = (selectedGender ?? user.gender ?? 'Other').trim();

      await AuthServiceUser.editProfile(
        token,
        userId!,
        updatedUsername,
        updatedBirthday,
        updatedGender,
        _imageFile,
      );

      await _loadingData();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      AppSnackbar.showError(context, e.toString(), Icons.error, Colors.red);
    }
  }

  Future<void> _loadingData() async {
    try {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');
      final userId = await storage.read(key: 'user_Id');
      final profile = await AuthServiceUser.ProfileFecthData(userId!, token!);
      final image =
          ApiConstants.baseUrl + (profile['profileImage'] ?? '/default.jpg');

      context.read<UserCubit>().setUser(
        profile['username'].toString(),
        profile['email'].toString(),
        profile['gender'].toString(),
        profile['birthday'].toString(),
        profile['age'].toString(),
        image,
      );
    } catch (e) {
      AppSnackbar.showError(
        context,
        'Error: $e',
        Icons.error,
        Theme.of(context).colorScheme.error,
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _birthdayDisplayController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width * 0.05,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _editProfile,
            child: Text(
              'Save',
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  color: theme.primaryColor,
                ),
                Positioned(
                  bottom: -65,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.grey[300],
                          backgroundImage:
                              _imageFile == null
                                  ? (context
                                              .read<UserCubit>()
                                              .state
                                              .profileImage
                                              ?.isNotEmpty ??
                                          false
                                      ? NetworkImage(
                                        context
                                            .read<UserCubit>()
                                            .state
                                            .profileImage!,
                                      )
                                      : const AssetImage(
                                            'assets/avatar/man.png',
                                          )
                                          as ImageProvider)
                                  : null, // ถ้ามี _imageFile จะใช้ child แทน
                          child:
                              _imageFile != null
                                  ? ClipOval(
                                    child: Image.file(
                                      _imageFile!,
                                      width: 140,
                                      height: 140,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 80),
            Padding(
              padding: padding,
              child: Column(
                children: [
                  Text('Click Image to change.'),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _emailController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: _showCupertinoDatePicker,
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _birthdayDisplayController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Birthday',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: _showGenderPicker,
                    child: AbsorbPointer(
                      child: TextField(
                        controller: TextEditingController(
                          text: selectedGender ?? '',
                        ),
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Gender',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
