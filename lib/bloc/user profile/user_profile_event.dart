part of 'user_profile_bloc.dart';

@immutable
sealed class UserProfileEvent {}
@immutable
class FetchUserprofileEvent extends UserProfileEvent{}
class UpdateUserprofileEvent extends UserProfileEvent{
  UserModel user;
  UpdateUserprofileEvent({required this.user});
}
class SignOutUserProfileEvent extends UserProfileEvent{
  
}
