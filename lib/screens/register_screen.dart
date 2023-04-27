import 'package:flutter/material.dart';
import 'package:playground_app_april_2023/firebase/auth_methods.dart';
import 'package:playground_app_april_2023/screens/home_screen.dart';
import 'package:playground_app_april_2023/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  //variables
  bool _isLoading = false;
  String? _errorMessage = '';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? validatePassword() {
    if (_repeatPasswordController.text.isEmpty) {
      return 'please repeat your password';
    } else if (_repeatPasswordController.text != _passwordController.text) {
      return 'passwords do not match';
    }

    return null;
  }

  void _registerUser() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final passwordError = validatePassword();

    if (passwordError != null) {
      setState(() {
        _errorMessage = passwordError;
        _isLoading = false;
        _repeatPasswordController.clear();
      });

      return;
    }

    try {
      String response = await AuthMethods().registerUser(
          email: _emailController.text, password: _passwordController.text);

      if (response == 'success') {
        if (!mounted) return;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 32),
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png', // Replace with your own logo image path
                  width: 120,
                  height: 120,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'please enter your email address';
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'please enter a valid email address';
                        }

                        return null;
                      },
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _repeatPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Repeat Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _registerUser();
                          }
                        },
                        child: _isLoading
                            ? const CircularProgressIndicator.adaptive(
                                backgroundColor: Colors.white,
                              )
                            : const Text('Sign Up'),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: const Text('Sign In',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(_errorMessage ?? '',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
