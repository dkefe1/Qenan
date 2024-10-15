import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qenan/features/auth/signin/data/models/userProfile.dart';
import 'package:qenan/features/auth/signin/data/repositories/signinRepository.dart';
import 'package:qenan/features/auth/signin/presentation/blocs/signin_event.dart';
import 'package:qenan/features/auth/signin/presentation/blocs/signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  SigninRepository signinRepository;
  SigninBloc(this.signinRepository) : super(SigninInitialState()) {
    on<PostSigninEvent>(_onPostSigninEvent);
    on<PostForgotPasswordEvent>(_onPostForgotPasswordEvent);
    on<PostOTPEvent>(_onPostOtpEvent);
    on<PostResetForgotPasswordEvent>(_onPostResetForgotPasswordEvent);
  }

  void _onPostSigninEvent(PostSigninEvent event, Emitter emit) async {
    emit(SigninLoadingState());
    try {
      await signinRepository.signinUser(event.signin);
      emit(SigninSuccessfulState());
    } catch (e) {
      emit(SigninFailureState(e.toString()));
    }
  }

  void _onPostForgotPasswordEvent(
      PostForgotPasswordEvent event, Emitter emit) async {
    emit(ForgotPasswordLoadingState());
    try {
      await signinRepository.forgotPassword(event.forgotPassword);
      emit(ForgotPasswordSuccessfulState());
    } catch (e) {
      emit(ForgotPasswordFailureState(e.toString()));
    }
  }

  void _onPostOtpEvent(PostOTPEvent event, Emitter emit) async {
    emit(OtpLoadingState());
    try {
      await signinRepository.otpVerification(event.otp);
      emit(OtpSuccessfulState());
    } catch (e) {
      emit(OtpFailureState(e.toString()));
    }
  }

  void _onPostResetForgotPasswordEvent(
      PostResetForgotPasswordEvent event, Emitter emit) async {
    emit(ResetForgotPasswordLoadingState());
    try {
      await signinRepository.resetForgotPassword(event.resetForgotPassword);
      emit(ResetForgotPasswordSuccessfulState());
    } catch (e) {
      emit(ResetForgotPasswordFailureState(e.toString()));
    }
  }
}

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  SigninRepository signinRepository;
  LogoutBloc(this.signinRepository) : super(LogoutInitialState()) {
    on<DelLogoutEvent>(_onDelLogoutEvent);
  }

  void _onDelLogoutEvent(DelLogoutEvent event, Emitter emit) async {
    emit(LogoutLoadingState());
    try {
      await signinRepository.logout();
      emit(LogoutSuccessfulState());
    } catch (e) {
      emit(LogoutFailureState(e.toString()));
    }
  }
}

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  SigninRepository signinRepository;
  ChangePasswordBloc(this.signinRepository)
      : super(ChangePasswordInitialState()) {
    on<PostChangePasswordEvent>(_onPostChangePasswordEvent);
  }

  void _onPostChangePasswordEvent(
      PostChangePasswordEvent event, Emitter emit) async {
    emit(ChangePasswordLoadingState());
    try {
      await signinRepository.changePassword(event.changePassword);
      emit(ChangePasswordSuccessfulState());
    } catch (e) {
      emit(ChangePasswordFailureState(e.toString()));
    }
  }
}

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  SigninRepository signinRepository;
  UpdateProfileBloc(this.signinRepository)
      : super(UpdateProfileInitialState()) {
    on<PatchUpdateProfileEvent>(_onPatchUpdateProfileEvent);
    on<GetUserProfileEvent>(_onGetUserProfileEvent);
  }

  void _onPatchUpdateProfileEvent(
      PatchUpdateProfileEvent event, Emitter emit) async {
    emit(UpdateProfileLoadingState());
    try {
      await signinRepository.updateProfile(event.updateProfile);
      emit(UpdateProfileSuccessfulState());
    } catch (e) {
      emit(UpdateProfileFailureState(e.toString()));
    }
  }

  void _onGetUserProfileEvent(GetUserProfileEvent event, Emitter emit) async {
    emit(UserProfileLoadingState());
    try {
      UserProfile userProfile = await signinRepository.getUserProfile();
      emit(UserProfileSuccessfulState(userProfile));
    } catch (e) {
      emit(UserProfileFailureState(e.toString()));
    }
  }
}
