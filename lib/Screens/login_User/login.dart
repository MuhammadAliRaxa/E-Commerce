import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app/Screens/HomePage/home_page.dart';
import 'package:flutter_e_commerce_app/Screens/createAccountPage/create_account.dart';
import 'package:flutter_e_commerce_app/auth/services/firebaseServices.dart';
import 'package:flutter_e_commerce_app/configs/sharedPreferances.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginScreemState();
}

class _LoginScreemState extends State<LoginPage> {
  Firebaseservices _firebaseservices=Firebaseservices();
  TextEditingController emailController=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordController=TextEditingController();

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
                    child: Text("Login your Account",style: TextStyle(fontSize: 50),),
                  )),
                  Expanded(flex: 1,child: SizedBox()),
                  Expanded(flex: 3,child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value){
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
                            if (value!.isEmpty||value.length<8) {
										return 'Enter a valid password with at least 8 character Length !';
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
                              final response=await _firebaseservices.signInWithEmail(email: emailController.text, password: passwordController.text);
                              if(response==''){
                                await SharedpreferancesHelper.setAccountAlreadyLogin(true);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login Successfully")));
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(), ));
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response)));
                              } 
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please give Correct format of Gmail and Password")));
                            }
                          },
                          style: ButtonStyle(backgroundColor: WidgetStateColor.resolveWith((states) => Colors.black54,)),
                           child: Text("Sign in",style: TextStyle(
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
                        UserCredential? user=await _firebaseservices.signInWithGoogle();
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
                        Text("Don't have an account? ", style: TextStyle(color: Colors.black26,fontSize: 15),),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateAccount(),)),
                          child: Text('sign up',style: TextStyle(color: Colors.black,fontSize: 20),),
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