import 'package:capstone/User.dart';
import 'package:capstone/pages/screen_time.dart';
import 'package:flutter/material.dart';
import '../service.dart';
import 'package:capstone/pages/signup.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../sources/mycolor.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.deepGreen,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(),
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
  final _formKey = GlobalKey<FormState>();

  Service service = Service();
  String id = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Log in to your account', style: TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.bold),),
            const Text('Enter your email and password', style: TextStyle(color: Colors.white, fontSize: 14.0,),),
            const SizedBox(height: 20.0,),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'ID',
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
              ),
              onChanged: (value){
                id = value;
              },
            ),
            const SizedBox(height: 20.0,),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
              ),
              onChanged: (value){
                password = value;
              },
            ),
            const SizedBox(height: 20.0,),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                        backgroundColor: MyColor.brightOrange,
                        minimumSize: Size(600, 40),	//width, height

                    alignment: Alignment.center,
                    textStyle: const TextStyle(fontSize: 16)
                ),
                onPressed: () async {
                  try{
                    final user = await service.searchUser(id);
                    if (user != null){
                      _formKey.currentState!.reset();
                      if (!mounted) return;
                      Navigator.of(context).pushNamed("/screen-time");
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
                const Text('If you did not register,', style: TextStyle(color: Colors.white, fontSize: 12.0),),
                TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    child: const Text('Register your email', style: TextStyle(color: MyColor.brightOrange, fontSize: 12.0),)
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
