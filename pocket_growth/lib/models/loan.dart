class Loan {
  final String id;
  final double amount;
  final double interestRate;
  final int term;
  final String termUnit; // 'months' or 'years'
  final DateTime startDate;
  final String? description;
  final String? borrowerId;
  final String? userName;
  final String status; // 'active', 'paid', 'defaulted', etc.
  final DateTime disbursementDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Loan({
    required this.id,
    required this.amount,
    required this.interestRate,
    required this.term,
    required this.termUnit,
    required this.startDate,
    required this.disbursementDate,
    this.description,
    this.borrowerId,
    this.userName,
    this.status = 'active',
    required this.createdAt,
    required this.updatedAt,
  });

  // 👇 Add this getter
  double get totalRepayment {
    return amount + (amount * interestRate / 100);
  }

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json['id'],
      amount: json['amount'].toDouble(),
      interestRate: json['interestRate'].toDouble(),
      term: json['term'],
      termUnit: json['termUnit'],
      startDate: DateTime.parse(json['startDate']),
      description: json['description'],
      borrowerId: json['borrowerId'],
      userName: json['usrName'],
      disbursementDate: DateTime.parse(json['disbursementDate']),
      status: json['status'] ?? 'active',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  get paymentHistory => null;

  get amountPaid => null;

  get remainingAmount => null;

  get nextPaymentDate => null;

  get nextPaymentAmount => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'interestRate': interestRate,
      'term': term,
      'termUnit': termUnit,
      'startDate': startDate.toIso8601String(),
      'description': description,
      'borrowerId': borrowerId,
      'username': userName,
      'status': status,
      'disbursementDate': disbursementDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}