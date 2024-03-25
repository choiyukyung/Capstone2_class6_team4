import 'package:flutter/material.dart';
import 'package:capstone/User.dart';
import '../service.dart';
import '../sources/mycolor.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.deepGreen,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(),
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
  final _formKey = GlobalKey<FormState>();

  Service service = Service();
  String id = '';
  String password = '';
  String name = '';
  String birthdate = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Create your account', style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),),
          const Text('Enter your information', style: TextStyle(color: Colors.white, fontSize: 10.0,),),
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
                contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
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
          Container(
            height: 40.0,
            width: 330.0,
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Name',
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
                name = value;
              },
            ),
          ),
          const SizedBox(height: 20.0,),
          Container(
            height: 40.0,
            width: 330.0,
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Birthdate',
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
                birthdate = value;
              },
            ),
          ),
          const SizedBox(height: 20.0,),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
                  backgroundColor: MyColor.brightOrange,
                  minimumSize: Size(330, 35),	//width, height

                  alignment: Alignment.center,
                  textStyle: const TextStyle(fontSize: 12)
              ),
              onPressed: () async {
                try{
                  User user = User(
                      id: id,
                      password: password,
                      name: name,
                      birthdate: birthdate,
                  );
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
              const Text('If you already registered,', style: TextStyle(color: Colors.white, fontSize: 10.0),),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: const Text('Log in  ', style: TextStyle(color: MyColor.brightOrange, fontSize: 10.0),)
              ),
            ],
          )
        ],
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


