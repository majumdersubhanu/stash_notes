import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stash_notes/screens/home_screen.dart';
import 'package:stash_notes/screens/register_screen.dart';
import 'package:stash_notes/widgets/auth_form_container.dart';
import 'package:stash_notes/widgets/auth_text_field.dart';
import 'package:stash_notes/widgets/google_auth_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AuthFormContainer(
        title: 'Login',
        subtitle: 'Welcome back to StashNotes',
        child: Form(
          autovalidateMode: AutovalidateMode.onUnfocus,
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthTextField(
                controller: _emailController,
                label: 'Email address',
                hint: 'john.doe@xyz.com',
                validator: _validateEmail,
                prefixIcon: const Icon(Icons.email_outlined),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: _passwordController,
                label: 'Password',
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter a password'
                            : null,
                obscureText: true,
                prefixIcon: const Icon(Icons.password),
                suffixIcon: const Icon(Icons.visibility),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String emailAddress = _emailController.text;
                    String password = _passwordController.text;
                    final loginStatus = await _loginWithEmailPassword(
                      emailAddress,
                      password,
                    );
                    if (context.mounted) {
                      if (loginStatus) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      }
                    }
                  }
                },
                icon: const Icon(Icons.verified),
                label: const Text('Continue with email'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                child: const Text('Forgot password'),
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('OR'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 24),
              const GoogleAuthButton(),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                child: Text(
                  'Create an account',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: Theme.of(context).colorScheme.primary,
                    decorationThickness: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _loginWithEmailPassword(
    String emailAddress,
    String password,
  ) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      if (credential.user != null) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Logged in successfully')));
        }

        return true;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('[Firebase Auth] No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('[Firebase Auth] Wrong password provided for that user.');
      }
    }
    return false;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    final bool emailValid = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}",
    ).hasMatch(value);
    if (!emailValid) {
      return 'Please enter a valid email';
    }
    return null;
  }
}
