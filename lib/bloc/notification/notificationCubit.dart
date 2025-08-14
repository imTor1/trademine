import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:trademine/bloc/notification/notificationState.dart';
import 'package:trademine/services/user_service.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  Future<void> fetchLatestNotifications() async {
    emit(NotificationLoading());

    try {
      final storage = const FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      if (token == null) {
        emit(NotificationError('No auth token found'));
        return;
      }

      final notifications = await AuthServiceUser.NotificationFetch(token);
      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError('Error: $e'));
    }
  }

  void deleteAllNotifications() {
    if (state is NotificationLoaded) {
      emit((state as NotificationLoaded).copyWith(notifications: []));
    } else {
      emit(const NotificationLoaded([]));
    }
  }
}
