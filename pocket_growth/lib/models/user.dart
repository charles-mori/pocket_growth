class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String mobileMoneyProvider;
  final String mobileMoneyNumber;
  final bool isAdmin;
  final DateTime joinDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.mobileMoneyProvider,
    required this.mobileMoneyNumber,
    this.isAdmin = false,
    required this.joinDate,
  });
}