class Chartdata {
  final int? id;
  final String purpose;
  final double amount;
  final bool isExpense;
  final String currencySymbol;
  final String date;
  Chartdata({
    this.id,
    required this.purpose,
    required this.amount,
    required this.isExpense,
    required this.currencySymbol,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'purpose': purpose,
      'amount': amount,
      'currencySymbol': currencySymbol,
      'isExpense': isExpense ? 1 : 0,
      'date': date,
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
    );
  }
}
