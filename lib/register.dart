import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 350),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Email address',
                      hintText: 'john.doe@xyz.com',
                    ),
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Confirm password'),
                  ),
                  FilledButton(onPressed: () {}, child: Text('Continue')),
                  Row(
                    spacing: 16,
                    children: [
                      Expanded(child: Divider()),
                      Text('OR'),
                      Expanded(child: Divider()),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Continue with Google'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                    child: Text('Already have an account? Login here'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
