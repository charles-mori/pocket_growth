class Transaction {
  final String id;
  final String type; // 'deposit' or 'withdrawal'
  final double amount;
  final String date; // ISO 8601 string format
  final String? description; // Optional description

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    this.description,
  });

  // Convert a Transaction to a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'date': date,
      'description': description,
    };
  }

  // Create a Transaction from a Map
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      type: json['type'],
      amount: json['amount'],
      date: json['date'],
      description: json['description']
    );
  }

  // Optionally, you can add a method to get the formatted date
  String get formattedDate {
    final dateTime = DateTime.parse(date);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  // Optionally, you can add a method to get a display title
  String get title {
    return type == 'deposit' ? 'Deposit' : 'Withdrawal';
  }
}