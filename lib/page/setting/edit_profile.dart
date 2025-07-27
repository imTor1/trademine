import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trademine/bloc/user_cubit.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _genderController = TextEditingController();
  final TextEditingController _birthdayDisplayController =
      TextEditingController();
  final List<String> optionsGender = ['Male', 'Female', 'Other'];
  String? selectedGender;

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
  }

  DateTime _getMaximumAllowedDate() {
    DateTime now = DateTime.now();
    return DateTime(now.year - 20, now.month, now.day);
  }

  void _showGenderPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext buider) {
        return Container(
          color: CupertinoColors.white,
          height: 200,
          child: CupertinoPicker(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
    final user = context.watch<UserCubit>().state;
    final padding = EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width * 0.05,
    );
    final theme = Theme.of(context);

    if (_usernameController.text.isEmpty)
      _usernameController.text = user.name ?? '';
    _emailController.text = user.email ?? '';

    if (_genderController.text.isEmpty)
      _genderController.text = user.gender ?? '';

    if (_selectedDate == null &&
        user.birthday != null &&
        user.birthday!.isNotEmpty) {
      try {
        _selectedDate = DateFormat('dd/MM/yyyy').parse(user.birthday!);
        _birthdayDisplayController.text = user.birthday!;
      } catch (e) {
        _birthdayDisplayController.text = '';
      }
    } else if (_selectedDate != null) {
      _birthdayDisplayController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(_selectedDate!);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              print('Save tapped');
              final updatedUsername = _usernameController.text;
              final updatedEmail = _emailController.text;
              final updatedBirthday = _birthdayDisplayController.text;
              final actualBirthdayDate = _selectedDate;
              final updatedGender = _genderController.text;
            },
            child: Text(
              'Save',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.white),
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
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 5.0),
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[300],
                          backgroundImage:
                              user.profileImage?.isNotEmpty ?? false
                                  ? NetworkImage(user.profileImage!)
                                  : const AssetImage('assets/avatar/man.png')
                                      as ImageProvider,
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            print('Change profile image');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.primaryColor,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
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
                  const SizedBox(height: 20),
                  _buildTextField('Username', _usernameController, false),
                  const SizedBox(height: 15),
                  _buildTextField('Email', _emailController, true),
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
                        controller: _genderController,
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

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    bool readOnly,
  ) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
