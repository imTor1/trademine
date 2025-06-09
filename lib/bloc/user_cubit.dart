import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bloc/bloc.dart';

class UserState {
  final String name;
  final String email;

  UserState({required this.name, required this.email});
}

class UserCubit extends Cubit<UserState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  UserCubit() : super(UserState(name: '', email: ''));

  Future<void> loadUser() async {
    final name = await _storage.read(key: 'name') ?? '';
    final email = await _storage.read(key: 'email') ?? '';
    emit(UserState(name: name, email: email));
  }

  Future<void> setUser(String name, String email) async {
    await _storage.write(key: 'name', value: name);
    await _storage.write(key: 'email', value: email);
    emit(UserState(name: name, email: email));
  }

  Future<void> clearUser() async {
    await _storage.delete(key: 'name');
    await _storage.delete(key: 'email');
    emit(UserState(name: '', email: ''));
  }
}
