import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Tambahkan import ini untuk web
import 'package:firebase_core_web/firebase_core_web.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/dashboard_screen.dart';


// --- FUNGSI UNTUK INISIALISASI FIREBASE DI WEB ---
Future<void> initializeFirebaseForWeb() async {
  // Cek apakah sedang berjalan di web
  if (Firebase.apps.isEmpty) {
    // Konfigurasi Firebase untuk web
    // GANTI NILAI-NILAI INI dengan yang kamu dapat dari Firebase Console
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDUHExlbkwvWDEQQzVrxJbARMf74jYwsHU", // GANTI dengan API Key kamu
        authDomain: "pinterest-app-a45df.firebaseapp.com", // GANTI dengan Auth Domain kamu
        projectId: "pinterest-app-a45df", // GANTI dengan Project ID kamu
        storageBucket: "pinterest-app-a45df.firebasestorage.app", // GANTI dengan Storage Bucket kamu
        messagingSenderId: "679130230941", // GANTI dengan Sender ID kamu
        appId: "1:679130230941:web:a9bc8d77ae3adce28f2474", // GANTI dengan App ID kamu
        measurementId: "G-CDLTQZTXXH" // GANTI dengan Measurement ID kamu
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // PANGGIL FUNGSI INISIALISASI SEBELUM RUN APP
  await initializeFirebaseForWeb();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pinterest Style App',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFFBD2E2E),
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}