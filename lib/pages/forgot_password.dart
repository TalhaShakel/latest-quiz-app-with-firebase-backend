import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/utils/snackbars.dart';

import '../configs/color_config.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {

  var formKey = GlobalKey<FormState>();
  var emailCtrl = TextEditingController();
  late String _email;



  void handleSubmit (){
    if(formKey.currentState!.validate()){
      formKey.currentState!.save();
      resetPassword(_email);
    }
  }



  Future<void> resetPassword(String email) async {
    final FirebaseAuth auth = FirebaseAuth.instance; 

    try{
      await auth.sendPasswordResetEmail(email: email);
      // ignore: use_build_context_synchronously
      openSnackbar(context, 'An email has been sent to $email. Go to that link & reset your password.');

    } catch(error){
      openSnackbar(context, error.toString());
      
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConfig.secondaryBgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.grey[900],),
          onPressed: ()=> Navigator.pop(context),
        ),
      ),
        body: Form(
            key: formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Text('reset-password', style: TextStyle(
                  fontSize: 25, fontWeight: FontWeight.w700
                )).tr(),
                const Text('reset-password-subtitle', style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500, color: Colors.blueGrey
                )).tr(),
                const SizedBox(
                  height: 50,
                ),
                
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'username@mail.com',
                    labelText: 'email'.tr()
                    
                  
                    
                  ),
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? value){
                    if (value!.isEmpty) return "Email can't be empty";
                    return null;
                  },
                  onChanged: (String value){
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                const SizedBox(height: 80,),
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor
                    ),
                    child: const Text('submit', style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),).tr(),
                    onPressed: (){
                      handleSubmit();
                  }),
                ),
                const SizedBox(height: 50,),
                ],
              ),
            ),
        ),
      
    );
  }
}