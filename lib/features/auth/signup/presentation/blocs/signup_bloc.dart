import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qenan/features/auth/signup/data/repositories/signupRepository.dart';
import 'package:qenan/features/auth/signup/presentation/blocs/signup_event.dart';
import 'package:qenan/features/auth/signup/presentation/blocs/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupRepository signupRepository;
  SignupBloc(this.signupRepository) : super(SignupInitialState()) {
    on<PostSignupEvent>(_onPostSignupEvent);
    on<PostRegistrationOTPEvent>(_onPostRegistrationOTPEvent);
    on<PostProfileInfoEvent>(_onPostProfileInfoEvent);
    on<PostPersonalization>(_onPostPersonalization);
  }

  void _onPostSignupEvent(PostSignupEvent event, Emitter emit) async {
    emit(SignupLoadingState());
    try {
      await signupRepository.signupUser(event.signup);
      emit(SignupSuccessfulState());
    } catch (e) {
      emit(SignupFailureState(e.toString()));
    }
  }

  void _onPostRegistrationOTPEvent(
      PostRegistrationOTPEvent event, Emitter emit) async {
    emit(OtpLoadingState());
    try {
      await signupRepository.registrationOtpVerification(event.otp);
      emit(OtpSuccessfulState());
    } catch (e) {
      emit(OtpFailureState(e.toString()));
    }
  }

  void _onPostProfileInfoEvent(PostProfileInfoEvent event, Emitter emit) async {
    emit(ProfileInfoLoadingState());
    try {
      await signupRepository.profileInfo(event.profileInfo);
      emit(ProfileInfoSuccessfulState());
    } catch (e) {
      emit(ProfileInfoFailureState(e.toString()));
    }
  }

  void _onPostPersonalization(PostPersonalization event, Emitter emit) async {
    emit(PersonalizationLoadingState());
    try {
      await signupRepository.personalization(event.personalization);
      emit(PersonalizationSuccessfulState());
    } catch (e) {
      emit(PersonalizationFailureState(e.toString()));
    }
  }
}
