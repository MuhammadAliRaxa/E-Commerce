
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app/Configs/sharedPreferances.dart';
import 'package:flutter_e_commerce_app/Screens/HomePage/home_page.dart';
import 'package:flutter_e_commerce_app/auth/services/firebaseServices.dart';
import 'package:flutter_e_commerce_app/Screens/login_User/login.dart';
import 'package:flutter_e_commerce_app/Screens/ProfilePage/profile_page.dart';

class CreateAccount extends StatefulWidget{

  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  Firebaseservices _service=Firebaseservices();
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  final _formKey=GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.sizeOf(context).height,
            minWidth: MediaQuery.sizeOf(context).width
          ),
          child: IntrinsicHeight(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Expanded(flex: 2,child:SizedBox() ),
                  Expanded(flex: 3,child: SizedBox(
                    child: Text("Create your Account",style: TextStyle(fontSize: 50),),
                  )),
                  Expanded(flex: 1,child: SizedBox()),
                  Expanded(flex: 3,child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty ||
											!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
													.hasMatch(value)) {
										return 'Enter a valid email!';
									}
									return null;
                          },
                          controller: emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),),
                            prefixIcon: Icon(Icons.email),
                            hintText: "Email"
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),TextFormField(
                          validator: (value) {
                            if(value!.isEmpty||value.length<8){
                              return "Please Enter Password at least 8 characters !";
                            }
                            return null;
                          },
                          controller: passwordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),),
                            prefixIcon: Icon(Icons.lock),
                            hintText: "Password"
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(onPressed: ()async{
                            if(_formKey.currentState!.validate()){
                              try {
                                final response=await _service.signUpWithEmailandPAssword(email: emailController.text.toString(), password: passwordController.text.toString());
                                if(response!=null){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Success")));   
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProfilePage(email: emailController.text, password: passwordController.text,uid: response,),));
                                }else{
                                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User Already Exists")));
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                log(e.toString());
                              }
                            }
                          },
                          style: ButtonStyle(backgroundColor: WidgetStateColor.resolveWith((states) => Colors.black54,)),
                           child: Text("Sign up",style: TextStyle(
                            fontSize: 15,color: Colors.white
                           ),) ),
                        )
                      ],
                    ),
                  )),
                  Expanded(flex: 1,child: Column(
                    children: [
                      Expanded(child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              color: Colors.black38,
                              height: 2,
                            ),
                          ),
                          Expanded(flex: 3,child: Text("  or continue with",selectionColor: Colors.black38,)),
                          Expanded(flex: 3,child: Container(
                              color: Colors.black38,
                              height: 2,
                            ),)
                        ],
                      ))
                    ],
                  )
                  ),
                  Expanded(flex: 1,child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: ()async{
                        UserCredential? user=await _service.signInWithGoogle();
                        if(user!=null){
                        await SharedpreferancesHelper.setAccountAlreadyLogin(true);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage() ,));
                        }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(width: 2,color: Colors.black45),
                                ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(image: AssetImage("assets/google-logo.png"),fit: BoxFit.fill)
                                  ),
                                ),
                                Text("Signin with Google")
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                  ),
                  Expanded(flex: 1,
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? ", style: TextStyle(color: Colors.black26,fontSize: 15),),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage(),)),
                          child: Text('sign in',style: TextStyle(color: Colors.black,fontSize: 20),),
                        )
                      ],
                    ) 
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