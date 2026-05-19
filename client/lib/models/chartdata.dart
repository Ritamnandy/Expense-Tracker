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
      id: map['id'],
      purpose: map['purpose'],
      amount: map['amount'],
      currencySymbol: map['currencySymbol'],
      isExpense: map['isExpense'] == 1,
      date: map['date'],
      userId: map['user_id'],
      isDeleted: map['is_deleted'] ?? 0,
      updatedAt: map['updated_at'],
      syncedAt: map['synced_at'],
    );
  }
}
