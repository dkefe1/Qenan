import 'package:qenan/features/auth/signup/data/dataSources/signupDatasource.dart';
import 'package:qenan/features/auth/signup/data/models/personalization.dart';
import 'package:qenan/features/auth/signup/data/models/profileInfo.dart';
import 'package:qenan/features/auth/signup/data/models/signup.dart';
import 'package:qenan/features/auth/signup/data/models/verifyOtp.dart';

class SignupRepository {
  SignupRemoteDatasource signupRemoteDatasource;
  SignupRepository(this.signupRemoteDatasource);

  Future signupUser(Signup signup) async {
    try {
      await signupRemoteDatasource.signupUser(signup);
    } catch (e) {
      throw e;
    }
  }

  Future registrationOtpVerification(RegistrationOtp otp) async {
    try {
      await signupRemoteDatasource.otpVerification(otp);
    } catch (e) {
      throw e;
    }
  }

  Future profileInfo(ProfileInfo profile) async {
    try {
      await signupRemoteDatasource.profileInfo(profile);
    } catch (e) {
      throw e;
    }
  }

  Future personalization(Personalization personalization) async {
    try {
      await signupRemoteDatasource.personalization(personalization);
    } catch (e) {
      throw e;
    }
  }
}
