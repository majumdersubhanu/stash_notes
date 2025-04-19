import 'package:flutter/material.dart';
import 'package:stash_notes/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 350),
              child: SingleChildScrollView(
                child: Form(
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Welcome back to StashNotes',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 48),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          }

                          final bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                          ).hasMatch(value);

                          if (!emailValid) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Email address',
                          hintText: 'john.doe@xyz.com',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.alternate_email),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.password),
                          suffixIcon: Icon(Icons.visibility),
                        ),
                      ),
                      SizedBox(height: 32),
                      FilledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('WIP')),
                            );
                          }
                        },
                        child: Text('Continue with email'),
                      ),
                      SizedBox(height: 16),
                      TextButton(
                        onPressed: () {},
                        child: Text('Forgot password'),
                      ),
                      SizedBox(height: 8),
                      Row(
                        spacing: 16,
                        children: [
                          Expanded(child: Divider()),
                          Text('OR'),
                          Expanded(child: Divider()),
                        ],
                      ),
                      SizedBox(height: 24),
                      GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Color(0xFF4285F4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Image.asset(
                                      'assets/icons/google.png',
                                      height: 32,
                                      width: 32,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Continue with Google',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Create an account',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor:
                                Theme.of(context).colorScheme.primary,
                            decorationThickness: 1.5,
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
      ),
    );
  }
}
