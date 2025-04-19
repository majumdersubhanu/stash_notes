import 'package:flutter/material.dart';
import 'package:stash_notes/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
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
                  FilledButton(onPressed: () {}, child: Text('Continue')),
                  TextButton(onPressed: () {}, child: Text('Forgot password')),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: Text('Create an account'),
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
