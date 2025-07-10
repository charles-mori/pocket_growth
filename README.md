# 📱 Pocket Growth

**Pocket Growth** is an **Online Savings and Loan Management System** designed to empower individuals and communities to save, borrow, and grow financially — all through a mobile-friendly digital platform. The system integrates with mobile money services like **MTN** and **Airtel**, enabling users to manage savings, apply for loans, and track repayments with ease.

---

## 🚀 Features

### 👤 User Features
- Register & login with email, phone, and password
- Link mobile money account (MTN/Airtel)
- Deposit & withdraw savings
- View savings balance and interest
- Loan eligibility calculator
- Apply for loans and track repayment
- Role-based dashboard (User/Admin)

### 🛠️ Admin Features
- Approve/Deny user registrations
- Manage user savings and loans
- Approve/Deny loan requests
- Set and update interest rates
- View total savings and repayment history

### 📱 Mobile Money Integration
- Simulated integration with MTN and Airtel APIs
- Deposit, withdrawal, and loan disbursement
- Transaction tracking per user

---

## 💻 Tech Stack

| Layer        | Technology             |
|--------------|------------------------|
| Frontend     | Flutter (Dart)         |
| Backend      | Firebase (Auth, Firestore) |
| State Mgmt   | Provider                |
| Auth         | Firebase Authentication |
| Database     | Cloud Firestore         |
| Hosting/API  | Firebase Hosting / Cloud Functions |
| Payments     | Mobile Money APIs (MTN/Airtel - simulated) |

---

## 🧱 Project Structure

```
pocket_growth/
├── lib/
│   ├── screens/
│   │   ├── login.dart
│   │   ├── register.dart
│   │   ├── admin_dashboard/
│   │   └── user_dashboard/
│   ├── providers/
│   │   └── user_provider.dart
│   ├── widgets/
│   └── main.dart
├── pubspec.yaml
├── README.md
└── ...
```

---

## 📝 Installation & Setup

1. **Clone the repository**

```bash
git clone https://github.com/yourusername/pocket_growth.git
cd pocket_growth
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Setup Firebase**

- Create a Firebase project
- Enable **Authentication** (Email/Password)
- Create **Firestore Database**
- Add `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS)

4. **Run the app**

```bash
flutter run
```

---

## 📈 Future Improvements

- Full integration with MTN/Airtel APIs
- Loan repayment reminders (notifications/SMS)
- Credit scoring algorithm
- Offline-first functionality
- Exportable financial reports

---

## 👨‍💻 Author

**Charles Mori Elias**  
Network Engineer | Full-Stack Developer  
📧 charlesmori12@gmail.com  
📞 +211 926129979

---

## 📜 License

This project is licensed under the MIT License.  
See the `LICENSE` file for details.

---

## 🤝 Support & Contribution

Contributions, feature requests, and bug reports are welcome!  
Feel free to fork, raise issues, or suggest improvements.

