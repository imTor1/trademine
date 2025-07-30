import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trademine/bloc/user_cubit.dart';
import 'package:trademine/theme/app_styles.dart';

class EditProfileField extends StatelessWidget {
  final TextEditingController usernameController;

  const EditProfileField({required this.usernameController, super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state;
    return SizedBox(
      height: 100,
      child: Row(
        children: [
          Text('Username:', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: usernameController,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.only(bottom: 5),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).dividerColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
