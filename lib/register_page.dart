import 'package:diet/ui/auth/auth_service.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  final void Function()? onTap;

  RegisterPage({super.key,
    required this.onTap,
  });

    //regester
  void regester(BuildContext context){
    //get authentication services
    final auth = AuthService();
    //password match => create user

    if(_pwController.text==_confirmPwController.text){
      try{
        auth.signUpWIthEmailPassword(
          _emailController.text,
          _pwController.text,);
      }catch(e){
        showDialog(context: context, builder: (context)=>AlertDialog(
          title: Text(e.toString()),
        ));
      }

    }
    //password dont match =>
    else{
      showDialog(context: context, builder: (context)=> const AlertDialog(
        title: Text("Password dosent match"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),

            //Welcome back Message
            Text("Lets create an account for you !!",
                style:TextStyle(
                  color:Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                )),


            const SizedBox(height:10),
            //email textfield
            MyTextField(
              obscureText: false, hintText: 'Email', controller: _emailController ,
            ),
            //password
            const SizedBox(height:10),
            //email textfield
            MyTextField(
              obscureText: true, hintText: 'password', controller: _pwController,
            ),
            const SizedBox(height:10),
            //email textfield
            MyTextField(
              obscureText: true, hintText: 'Confirm password', controller: _confirmPwController,
            ),
            // login button
            MyButton(
              text: "Regester",
              onTap: ()=>regester(context),
            ),
            const SizedBox(height:10),
            //regester
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account ??",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text("Login Now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
