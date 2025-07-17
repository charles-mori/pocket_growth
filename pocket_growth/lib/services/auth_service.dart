import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthService with ChangeNotifier {
  User? _currentUser;
  final List<User> _users = []; // Simulated database

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  int get userCount => _users.length;

  get users => null;

  Future<bool> login(String phone, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    // In a real app, this would verify with a backend
    final user = _users.firstWhere(
      (user) => user.phone == phone && password == 'password123', // Default password for demo
      orElse: () => User(
        id: '',
        name: '',
        email: '',
        phone: '',
        mobileMoneyProvider: '',
        mobileMoneyNumber: '',
        joinDate: DateTime.now(),
      ),
    );
    
    if (user.id.isNotEmpty) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String mobileMoneyProvider,
    required String mobileMoneyNumber,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      phone: phone,
      mobileMoneyProvider: mobileMoneyProvider,
      mobileMoneyNumber: mobileMoneyNumber,
      joinDate: DateTime.now(),
    );
    
    _users.add(newUser);
    _currentUser = newUser;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void deleteUser(String id) {}

  Future<void> updateUserProfile({required String name, required String email, required String phone, required String mobileMoneyProvider, required String mobileMoneyNumber}) async {}
}