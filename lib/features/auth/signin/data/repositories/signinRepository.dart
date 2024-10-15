import 'package:qenan/features/auth/signin/data/dataSources/signinDataSource.dart';
import 'package:qenan/features/auth/signin/data/models/changePassword.dart';
import 'package:qenan/features/auth/signin/data/models/forgotPassword.dart';
import 'package:qenan/features/auth/signin/data/models/otp.dart';
import 'package:qenan/features/auth/signin/data/models/resetForgotPassword.dart';
import 'package:qenan/features/auth/signin/data/models/signin.dart';
import 'package:qenan/features/auth/signin/data/models/updateProfile.dart';
import 'package:qenan/features/auth/signin/data/models/userProfile.dart';

class SigninRepository {
  SigninRemoteDataSource signinRemoteDatasource;
  SigninRepository(this.signinRemoteDatasource);

  Future signinUser(Signin signin) async {
    try {
      await signinRemoteDatasource.signinUser(signin);
    } catch (e) {
      throw e;
    }
  }

  Future logout() async {
    try {
      await signinRemoteDatasource.logout();
    } catch (e) {
      throw e;
    }
  }

  Future forgotPassword(ForgotPassword forgotPassword) async {
    try {
      await signinRemoteDatasource.forgotPassword(forgotPassword);
    } catch (e) {
      throw e;
    }
  }

  Future otpVerification(OTP otp) async {
    try {
      await signinRemoteDatasource.otpVerification(otp);
    } catch (e) {
      throw e;
    }
  }

  Future resetForgotPassword(ResetForgotPassword resetForgotPassword) async {
    try {
      await signinRemoteDatasource.resetForgotPassword(resetForgotPassword);
    } catch (e) {
      throw e;
    }
  }

  Future changePassword(ChangePassword changePassword) async {
    try {
      await signinRemoteDatasource.changePassword(changePassword);
    } catch (e) {
      throw e;
    }
  }

  Future updateProfile(UpdateProfile updateProfile) async {
    try {
      await signinRemoteDatasource.updateProfile(updateProfile);
    } catch (e) {
      throw e;
    }
  }

  Future<UserProfile> getUserProfile() async {
    try {
      final categoryDetail = await signinRemoteDatasource.getProfile();
      return categoryDetail;
    } catch (e) {
      throw e;
    }
  }
}
