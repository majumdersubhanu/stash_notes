import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
                        'Register',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Register and STASH away your notes',
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
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
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
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          if (!RegExp(r'[A-Z]').hasMatch(value)) {
                            return 'Password must contain at least one uppercase letter';
                          }
                          if (!RegExp(r'[a-z]').hasMatch(value)) {
                            return 'Password must contain at least one lowercase letter';
                          }
                          if (!RegExp(
                            r'[!@#$%^&*(),.?":{}|<>]',
                          ).hasMatch(value)) {
                            return 'Password must contain at least one special character';
                          }
                          if (!RegExp(r'\d').hasMatch(value)) {
                            return 'Password must contain at least one number';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          helper: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('8 characters'),
                              Text('1 upper case letter'),
                              Text('1 lower case letter'),
                              Text('1 special character'),
                              Text('1 number'),
                            ],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.password),
                          suffixIcon: Icon(Icons.visibility),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the password again';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirm password',

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.password),
                        ),
                      ),
                      SizedBox(height: 32),
                      FilledButton(
                        onPressed: () {},
                        child: Text('Continue with email'),
                      ),
                      SizedBox(height: 24),
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
                          Navigator.maybePop(context);
                        },
                        child: Text(
                          'Existing user? Login here',
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
