import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:equatable/equatable.dart';
import 'package:trademine/services/user_service.dart';

// ----------------- Notification State -----------------
abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

class NotificationLoaded extends NotificationState {
  final List<dynamic> notifications;

  const NotificationLoaded(this.notifications);

  NotificationLoaded copyWith({List<dynamic>? notifications}) {
    return NotificationLoaded(notifications ?? this.notifications);
  }

  @override
  List<Object?> get props => [notifications];

  @override
  String toString() => 'NotificationLoaded(${notifications.length} items)';
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'NotificationError($message)';
}
