import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mintworth/screens/login_screen.dart';
import 'package:mintworth/screens/home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final profileNoController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String errorMessage = '';
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    profileNoController.dispose();
    super.dispose();
  }

  Future<void> createUserWithEmailAndPassword() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final user = userCredential.user!;
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'profileNo': profileNoController.text.trim(),
        'currentStreak': 0,
        'totalPoints': 0,
        'achievements': [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'budget': {
          'monthlyIncome': 35000,
          'savingsGoal': 10000,
          'transactions': [
            {
              'id': 'txn1',
              'category': 'Salary',
              'amount': 35000,
              'type': 'income',
              'description': 'Monthly salary',
              'date': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
            }
          ],
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        },
        'portfolio': {
          'virtualCash': 55000,
          'totalInvested': 0,
          'holdings': [],
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        },
        'modules': {
          'completedIds': [],
          'progress': [],
        },
        'fraudScenarios': {
          'completedIds': [],
          'progress': [],
        }
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Signup failed';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.savings, size: 64, color: theme.colorScheme.primary),
                    const SizedBox(height: 12),
                    Text('Create an Account', style: theme.textTheme.headlineMedium),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Enter name' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Enter email' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                      validator: (val) => val == null || val.isEmpty ? 'Enter password' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: profileNoController,
                      decoration: const InputDecoration(
                        labelText: 'Profile No',
                        prefixIcon: Icon(Icons.badge),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Enter profile no.' : null,
                    ),
                    const SizedBox(height: 18),
                    if (errorMessage.isNotEmpty)
                      Text(errorMessage, style: TextStyle(color: theme.colorScheme.error)),
                    if (isLoading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState?.validate() ?? false) {
                            await createUserWithEmailAndPassword();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.secondary,
                          foregroundColor: theme.colorScheme.onSecondary,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          'Sign Up',
                          style: theme.textTheme.titleMedium!.copyWith(color: theme.colorScheme.onSecondary),
                        ),
                      ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: theme.textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
