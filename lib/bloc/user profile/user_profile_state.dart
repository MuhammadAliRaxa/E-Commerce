part of 'user_profile_bloc.dart';

@immutable
sealed class UserProfileState {}
@immutable
final class UserProfileInitial extends UserProfileState {
   
}
@immutable
final class UserProfileLoaded extends UserProfileState{
  UserModel userModel;
  UserProfileLoaded({required this.userModel});
}
