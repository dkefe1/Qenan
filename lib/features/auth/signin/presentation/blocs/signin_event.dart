import 'package:qenan/features/auth/signin/data/models/changePassword.dart';
import 'package:qenan/features/auth/signin/data/models/forgotPassword.dart';
import 'package:qenan/features/auth/signin/data/models/otp.dart';
import 'package:qenan/features/auth/signin/data/models/resetForgotPassword.dart';
import 'package:qenan/features/auth/signin/data/models/signin.dart';
import 'package:qenan/features/auth/signin/data/models/updateProfile.dart';

abstract class SigninEvent {}

class PostSigninEvent extends SigninEvent {
  final Signin signin;

  PostSigninEvent(this.signin);
}

class PostForgotPasswordEvent extends SigninEvent {
  final ForgotPassword forgotPassword;
  PostForgotPasswordEvent(this.forgotPassword);
}

class PostOTPEvent extends SigninEvent {
  final OTP otp;
  PostOTPEvent(this.otp);
}

class PostResetForgotPasswordEvent extends SigninEvent {
  final ResetForgotPassword resetForgotPassword;
  PostResetForgotPasswordEvent(this.resetForgotPassword);
}

abstract class LogoutEvent {}

class DelLogoutEvent extends LogoutEvent {}

abstract class ChangePasswordEvent {}

class PostChangePasswordEvent extends ChangePasswordEvent {
  final ChangePassword changePassword;
  PostChangePasswordEvent(this.changePassword);
}

abstract class UpdateProfileEvent {}

class GetUserProfileEvent extends UpdateProfileEvent {}

class PatchUpdateProfileEvent extends UpdateProfileEvent {
  final UpdateProfile updateProfile;
  PatchUpdateProfileEvent(this.updateProfile);
}
