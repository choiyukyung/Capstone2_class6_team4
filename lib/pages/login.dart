import 'package:capstone/User.dart';
import 'package:capstone/pages/screen_time.dart';
import 'package:flutter/material.dart';
import '../service.dart';
import 'package:capstone/pages/signup.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),

      body: const LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _saving = false;
  Service service = Service();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _saving,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                onChanged: (value){
                  email = value;
                },
              ),
              const SizedBox(height: 20.0,),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                onChanged: (value){
                  password = value;
                },
              ),
              const SizedBox(height: 20.0,),
              ElevatedButton(
                  onPressed: () async {
                    try{
                      setState(() {
                        _saving = true;
                      });
                      final user = await service.searchUser(email);
                      if (user != null){
                        _formKey.currentState!.reset();
                        if (!mounted) return;
                        Navigator.of(context).pushNamed("/screen-time");
                        setState(() {
                          _saving = false;
                        });
                      }
                    } catch(e){
                      print(e);
                    }
                  },
                  child: const Text('Enter')
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('If you did not register,'),
                  TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: const Text('Register your email')
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
