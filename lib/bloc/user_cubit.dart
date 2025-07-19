import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bloc/bloc.dart';

class UserState {
  final String name;
  final String email;
  final String gender;
  final String birthday;
  final String age;
  final String profileImage;

  UserState({
    required this.name,
    required this.email,
    required this.gender,
    required this.birthday,
    required this.age,
    required this.profileImage,
  });
}

class UserCubit extends Cubit<UserState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  UserCubit()
    : super(
        UserState(
          name: '',
          email: '',
          gender: '',
          birthday: '',
          age: '',
          profileImage: '',
        ),
      );

  Future<void> loadUser() async {
    final name = await _storage.read(key: 'name') ?? '';
    final email = await _storage.read(key: 'email') ?? '';
    final gender = await _storage.read(key: 'gender') ?? '';
    final birthday = await _storage.read(key: 'birthday') ?? '';
    final age = await _storage.read(key: 'age') ?? '';
    final profileImage = await _storage.read(key: 'profileImage') ?? '';

    emit(
      UserState(
        name: name,
        email: email,
        gender: gender,
        birthday: birthday,
        age: age,
        profileImage: profileImage,
      ),
    );
  }

  Future<void> setUser(
    String name,
    String email,
    String gender,
    String birthday,
    String age,
    String profileImage,
  ) async {
    await _storage.write(key: 'name', value: name);
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'gender', value: gender);
    await _storage.write(key: 'birthday', value: birthday);
    await _storage.write(key: 'age', value: age);
    await _storage.write(key: 'profileImage', value: profileImage);

    emit(
      UserState(
        name: name,
        email: email,
        gender: gender,
        birthday: birthday,
        age: age,
        profileImage: profileImage,
      ),
    );
  }

  Future<void> clearUser() async {
    await _storage.delete(key: 'name');
    await _storage.delete(key: 'email');
    await _storage.delete(key: 'gender');
    await _storage.delete(key: 'birthday');
    await _storage.delete(key: 'age');

    await _storage.delete(key: 'profileImage');

    emit(
      UserState(
        name: '',
        email: '',
        gender: '',
        birthday: '',
        age: '',
        profileImage: '',
      ),
    );
  }
}
