import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stash_notes/screens/home_screen.dart';
import 'package:stash_notes/widgets/auth_form_container.dart';
import 'package:stash_notes/widgets/auth_text_field.dart';
import 'package:stash_notes/widgets/google_auth_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AuthFormContainer(
        title: 'Register',
        subtitle: 'Register and STASH away your notes',
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
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: _passwordController,
                label: 'Password',
                obscureText: true,
                validator: _validatePassword,
                prefixIcon: const Icon(Icons.password),
                suffixIcon: const Icon(Icons.visibility),
                helper: Text(
                  '1 upper case\n1 lower case\n1 number\n1 special char',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: _confirmPasswordController,
                label: 'Confirm password',
                obscureText: true,
                validator:
                    (value) =>
                        value != _passwordController.text
                            ? 'Passwords do not match'
                            : null,
                prefixIcon: const Icon(Icons.password),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String emailAddress = _emailController.text;
                    String password = _passwordController.text;
                    final loginStatus = await _registerWithEmailPassword(
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
              const SizedBox(height: 24),
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
                onPressed: () => Navigator.maybePop(context),
                child: Text(
                  'Existing user? Login here',
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

  Future<bool> _registerWithEmailPassword(
    String emailAddress,
    String password,
  ) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Registered successfully')));
      }
      if (credential.user != null) {
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) return 'Min 8 characters required';
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Must have uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Must have lowercase letter';
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Must have number';
    }
    if (!RegExp(r'[!@#\\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Must have special character';
    }
    return null;
  }
}
