import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app/auth/models/userModel.dart';
import 'package:flutter_e_commerce_app/auth/services/firebaseServices.dart';
part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  Firebaseservices _firebaseservices=Firebaseservices();
  UserProfileBloc() : super(UserProfileInitial()) {
    on<UserProfileEvent>((event, emit) async{
      UserModel user=await _firebaseservices.getInfo();
      emit(UserProfileLoaded(userModel: user));
    });
    on<UpdateUserprofileEvent>((event, emit)async{
      await _firebaseservices.updateUser(event.user);
    } ,);
    on<SignOutUserProfileEvent>((event, emit) async{
      print("asxvjhasvx asnbx asx asx hasbxmas xnbasx as  xjkasbxm a");
      await _firebaseservices.signOut();
      
    },);
  }
}
