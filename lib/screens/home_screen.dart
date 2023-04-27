import 'package:flutter/material.dart';
import 'package:playground_app_april_2023/firebase/auth_methods.dart';
import 'package:playground_app_april_2023/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //variables

  bool _isLoading = false;

  //methods
  void _logoutMethod() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await AuthMethods().logoutUser();
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
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
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('This is the home page'),
          TextButton(
            onPressed: _logoutMethod,
            child: !_isLoading
                ? const Text('Logout')
                : const CircularProgressIndicator.adaptive(),
          )
        ],
      )),
    );
  }
}
