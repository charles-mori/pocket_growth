class Repayment {
  final String id;
  final String loanId;
  final DateTime dueDate;
  final double amount;
  final double principal;
  final double interest;
  final double remainingBalance;
  final String status; // 'pending', 'paid', 'late', 'missed'
  final DateTime? paymentDate;
  final String? notes;

  Repayment({
    required this.id,
    required this.loanId,
    required this.dueDate,
    required this.amount,
    required this.principal,
    required this.interest,
    required this.remainingBalance,
    this.status = 'pending',
    this.paymentDate,
    this.notes,
  });

  factory Repayment.fromJson(Map<String, dynamic> json) {
    return Repayment(
      id: json['id'],
      loanId: json['loanId'],
      dueDate: DateTime.parse(json['dueDate']),
      amount: json['amount'].toDouble(),
      principal: json['principal'].toDouble(),
      interest: json['interest'].toDouble(),
      remainingBalance: json['remainingBalance'].toDouble(),
      status: json['status'],
      paymentDate: json['paymentDate'] != null 
          ? DateTime.parse(json['paymentDate']) 
          : null,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loanId': loanId,
      'dueDate': dueDate.toIso8601String(),
      'amount': amount,
      'principal': principal,
      'interest': interest,
      'remainingBalance': remainingBalance,
      'status': status,
      'paymentDate': paymentDate?.toIso8601String(),
      'notes': notes,
    };
  }
}