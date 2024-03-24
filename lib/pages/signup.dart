import 'package:capstone/User.dart';
import 'package:flutter/material.dart';
import '../service.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),

      body: const SignupForm(),
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  bool _saving = false;
  Service service = Service();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String userName = '';

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
              TextFormField(
                //obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'User name',
                ),
                onChanged: (value){
                  userName = value;
                },
              ),
              const SizedBox(height: 20.0,),
              ElevatedButton(
                  onPressed: () async {
                    try{
                      setState(() {
                        _saving = true;
                      });
                      User user = User(email: email, password: password);
                      final response = await service.saveUser(user);
                      if (response == true){
                        _formKey.currentState!.reset();
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("회원가입에 성공했습니다."),
                        ));
                        //ScaffoldMessenger.of(context).clearSnackBars(); //빠르게 닫고 싶을때 사용
                        Navigator.pop(context);
                      }
                      setState(() {
                        _saving = false;
                      });
                    }
                    catch (e){
                      print(e);
                    }
                  },
                  child: const Text('Enter')
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('If you already registered,'),
                  TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: const Text('Log in with your email')
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

class SuccessSignup extends StatelessWidget {
  const SuccessSignup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Success Register'),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have successfully registered', style: TextStyle(fontSize: 20.0,),),
            const SizedBox(height: 20.0,),
            ElevatedButton(
              onPressed: (){
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}


