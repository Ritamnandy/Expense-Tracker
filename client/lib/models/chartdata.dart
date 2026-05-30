class Chartdata {
  final String? id;
  final String purpose;
  final double amount;
  final bool isExpense;
  final String currencySymbol;
  final String date;
  final String? userId;
  final int isDeleted;
  final String? updatedAt;
  final String? syncedAt;
  Chartdata({
    this.id,
    required this.purpose,
    required this.amount,
    required this.isExpense,
    required this.currencySymbol,
    required this.date,
    this.userId,
    this.isDeleted = 0,
    this.updatedAt,
    this.syncedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'purpose': purpose,
      'amount': amount,
      'currencySymbol': currencySymbol,
      'isExpense': isExpense ? 1 : 0,
      'date': date,
      'user_id': userId,
      'is_deleted': isDeleted,
      'updated_at': updatedAt,
      'synced_at': syncedAt,
    };
  }

  factory Chartdata.fromMap(Map<String, dynamic> map) {
    return Chartdata(
      id: map['id'] as String?,
      purpose: map['purpose'] as String? ?? 'Unknown',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      currencySymbol: map['currencySymbol'] as String? ?? '',
      isExpense: (map['isExpense'] as int?) == 1,
      date: map['date'] as String? ?? '',
      userId: map['user_id'] as String?,
      isDeleted: map['is_deleted'] as int? ?? 0,
      updatedAt: map['updated_at'] as String?,
      syncedAt: map['synced_at'] as String?,
    );
  }
}
