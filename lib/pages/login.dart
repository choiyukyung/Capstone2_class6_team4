import 'package:capstone/pages/screen_time.dart';
import 'package:flutter/material.dart';
import 'package:capstone/data/user.dart';
import '../services/myapi.dart';
import 'package:capstone/pages/signup.dart';

import '../services/mycolor.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.deepGreenBlue,
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
            const Text('Log in to your account', style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),),
            const SizedBox(height: 5.0,),
            const Text('Enter your email and password', style: TextStyle(color: Colors.white, fontSize: 10.0,),),
            const SizedBox(height: 50.0,),
            Container(
              height: 40.0,
              width: 330.0,
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'ID',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0), //TODO: 커서 세로 위치 조정
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                onChanged: (value){
                  id = value;
                },
              ),
            ),
            const SizedBox(height: 20.0,),
            Container(
              height: 40.0,
              width: 330.0,
              child: TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                onChanged: (value){
                  password = value;
                },
              ),
            ),
            const SizedBox(height: 20.0,),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                        backgroundColor: MyColors.brightOrange,
                        minimumSize: Size(340, 37),	//width, height

                    alignment: Alignment.center,
                    textStyle: const TextStyle(fontSize: 12)
                ),
                onPressed: () async {
                  if (id == 'master') { //개발용 - 나중에 삭제
                    Navigator.pushNamed(context, '/main');
                    return;
                  }
                  try{
                    final user = await service.searchUser(id);
                    if (user != null){
                      _formKey.currentState!.reset();
                      if (!mounted) return;
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenTime(id)));
                      //Navigator.of(context).pushNamed("/screen-time");
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
                const Text('If you did not register,', style: TextStyle(color: Colors.white, fontSize: 10.0),),
                TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    child: const Text('Sign up  ', style: TextStyle(color: MyColors.brightOrange, fontSize: 10.0),)
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
