import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app/Screens/HomePage/home_page.dart';
import 'package:flutter_e_commerce_app/auth/models/userModel.dart';
import 'package:flutter_e_commerce_app/auth/services/firebaseServices.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ProfilePage extends StatefulWidget{
  final String uid;
  final String email;
  final String password;
  const ProfilePage({required this.uid,required this.password,required this.email,super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Firebaseservices _firebaseservices=Firebaseservices();
  File? _image;
  final dateofBirth=TextEditingController();
  DateTime? selectedDate;
  String selectedGender="gender";
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(), 
      firstDate: DateTime(2000),                   
      lastDate: DateTime(2101),                    
    ); 
    if (picked != null && picked != selectedDate) {
      setState(() {
        dateofBirth.text= picked.toString();
      });
    }
  }
  Future<void> getImagefromGallery()async{
    final imagePick=await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 100,);
    if(context.mounted){
      if(imagePick!=null){
        setState(() {
      _image=File(imagePick.path);
    });
      }else{
        Fluttertoast.showToast(msg: "Image not selected !",
                                toastLength: Toast.LENGTH_SHORT,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                gravity: ToastGravity.BOTTOM,
                                fontSize: 16
                                );
      }
    }
  }
  final _formKey=GlobalKey<FormState>();
  final full_name=TextEditingController();
  final nick_name=TextEditingController();
  final phone=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fill Your Profile"),),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height,
            maxWidth: MediaQuery.sizeOf(context).width
          ),
          child: IntrinsicHeight(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          getImagefromGallery();
                        },
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage: _image==null?AssetImage("assets/profile.png"):FileImage(_image!)
                        ),
                      ),
                    ) 
                    ),
                    Expanded(
                      flex: 7,
                      child: Form(
                        key: _formKey ,
                        child: Column(
                      children: [
                        TextFormField(
                          validator: (value){
                            if(value!.isEmpty){
                              return "This field cannot be empty";
                            }
                            return null;
                          },
                           controller: full_name,
                           decoration: InputDecoration(
                            labelText: "Name",
                            hintText: "Full Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40)
                            )
                           ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          validator: (value){
                            if(value!.isEmpty){
                              return "This field cannot be empty";
                            }
                            return null ;
                          },
                           controller: nick_name,
                           decoration: InputDecoration(
                            labelText: "Nick Name",
                            hintText: "Nick Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40)
                            )
                           ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          validator: (value){
                            if(value!.isEmpty){
                              return "This field cannot be empty";
                            }
                            return null;
                          },
                          readOnly: true,
                           controller: dateofBirth,
                           decoration: InputDecoration(
                            labelText: "Date Of Birth",
                            suffixIcon: GestureDetector(onTap: () => _selectDate(context),child: Icon(Icons.calendar_month_outlined)),
                            hintText: "Date",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40)
                            )
                           ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          
                          readOnly: true,
                           decoration: InputDecoration
                           (
                            labelText: "Email",
                            hintText: widget.email,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40)
                            )
                           ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        IntlPhoneField(
                          controller: phone,
                           decoration: InputDecoration(
                            labelText: "Phone Number",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40)
                            )
                           ),
                        ),
                        DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: "Gender",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                              ),
                              items: ['Male', 'Female'].map((gender) {
                              return DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                              );
                              }).toList(),
                              onChanged: (value) {
                             },
                            ),
                            SizedBox(
                              height: 25,
                            ),SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(style: ButtonStyle(backgroundColor: WidgetStateColor.resolveWith((states) => Colors.black54,)),onPressed: ()async{
                        if(_formKey.currentState!.validate()){
                          final user=UserModel(id: widget.uid, name: full_name.text, nickName: nick_name.text, dateofBirth: dateofBirth.text, email: widget.email, password: widget.password, phoneNumber: phone.text, gender: selectedGender, profilePicture: _image==null?"no Image":_image!.path);
                          _firebaseservices.createUserProfile(user:user);
                          showDialog(context: context, builder: (context) => Dialog(elevation: 30,
                            child: Container(
                              width: 300,
                              height: 400,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)
                              ),
                              child: Column(
                                children: [
                                  Expanded(flex:3,child: Center(child: Image(fit: BoxFit.cover, image: AssetImage("assets/readyAccount.png")))),
                                  Expanded(flex: 3,child: Text("Congratulations!",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)),
                                  Expanded(flex: 3,child: SizedBox(width: 200,child: Text('Your account is ready to use. You will be redirected to Home Page in few seconds.')))
                                ],
                              ),
                            ),
                          ),);
                          await Future.delayed(const Duration(seconds: 2));
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(),));
                        }
                      }, 
                      child: Text("Continue",style: TextStyle(color: Colors.white,fontSize: 18),)),
                    )
                      ],
                    )
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