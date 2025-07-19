import 'package:equatable/equatable.dart';
import 'dart:convert'; // สำหรับแปลง List<CreditCard> เป็น String และกลับกัน

// --- 1.1 สร้าง CreditCard Model ---
class CreditCard extends Equatable {
  final String id; // เพิ่ม ID สำหรับระบุบัตรแต่ละใบ
  final String titleCard;
  final String balance;
  final String card_holder;
  final String expires;

  CreditCard({
    required this.id,
    required this.titleCard,
    required this.balance,
    required this.card_holder,
    required this.expires,
  });

  // Equatable: สำหรับเปรียบเทียบ CreditCard Objects
  @override
  List<Object> get props => [id, titleCard, balance, card_holder, expires];

  // เมธอดสำหรับแปลง CreditCard Object เป็น Map (เพื่อบันทึกใน SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleCard': titleCard,
      'balance': balance,
      'card_holder': card_holder,
      'expires': expires,
    };
  }

  // Factory method สำหรับสร้าง CreditCard Object จาก Map (เมื่อโหลดจาก SharedPreferences)
  factory CreditCard.fromJson(Map<String, dynamic> json) {
    return CreditCard(
      id: json['id'] as String,
      titleCard: json['titleCard'] as String,
      balance: json['balance'] as String,
      card_holder: json['card_holder'] as String,
      expires: json['expires'] as String,
    );
  }

  // copyWith method สำหรับการอัปเดตข้อมูลบัตรแต่ละใบ
  CreditCard copyWith({
    String? id,
    String? titleCard,
    String? balance,
    String? card_holder,
    String? expires,
  }) {
    return CreditCard(
      id: id ?? this.id,
      titleCard: titleCard ?? this.titleCard,
      balance: balance ?? this.balance,
      card_holder: card_holder ?? this.card_holder,
      expires: expires ?? this.expires,
    );
  }
}

class UserState extends Equatable {
  final List<CreditCard> creditCards;

  UserState({required this.creditCards});

  @override
  List<Object> get props => [creditCards];

  // copyWith method สำหรับการอัปเดต UserState
  UserState copyWith({List<CreditCard>? creditCards}) {
    return UserState(creditCards: creditCards ?? this.creditCards);
  }
}
