import 'package:qenan/features/auth/signup/data/models/personalization.dart';
import 'package:qenan/features/auth/signup/data/models/profileInfo.dart';
import 'package:qenan/features/auth/signup/data/models/signup.dart';
import 'package:qenan/features/auth/signup/data/models/verifyOtp.dart';

abstract class SignupEvent {}

class PostSignupEvent extends SignupEvent {
  final Signup signup;

  PostSignupEvent(this.signup);
}

class PostRegistrationOTPEvent extends SignupEvent {
  final RegistrationOtp otp;
  PostRegistrationOTPEvent(this.otp);
}

class PostProfileInfoEvent extends SignupEvent {
  final ProfileInfo profileInfo;
  PostProfileInfoEvent(this.profileInfo);
}

class PostPersonalization extends SignupEvent {
  final Personalization personalization;
  PostPersonalization(this.personalization);
}
