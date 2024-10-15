abstract class SignupState {}

class SignupInitialState extends SignupState {}

class SignupLoadingState extends SignupState {}

class SignupSuccessfulState extends SignupState {}

class SignupFailureState extends SignupState {
  final String error;
  SignupFailureState(this.error);
}

class OtpLoadingState extends SignupState {}

class OtpSuccessfulState extends SignupState {}

class OtpFailureState extends SignupState {
  final String error;
  OtpFailureState(this.error);
}

class ProfileInfoLoadingState extends SignupState {}

class ProfileInfoSuccessfulState extends SignupState {}

class ProfileInfoFailureState extends SignupState {
  final String error;
  ProfileInfoFailureState(this.error);
}

class PersonalizationLoadingState extends SignupState {}

class PersonalizationSuccessfulState extends SignupState {}

class PersonalizationFailureState extends SignupState {
  final String error;
  PersonalizationFailureState(this.error);
}
