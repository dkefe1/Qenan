import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qenan/features/guidelines/data/models/feedbackTypes.dart';
import 'package:qenan/features/guidelines/data/models/guidelines.dart';
import 'package:qenan/features/guidelines/data/repositories/guidelinesRepository.dart';
import 'package:qenan/features/guidelines/presentation/bloc/guidelines_event.dart';
import 'package:qenan/features/guidelines/presentation/bloc/guidelines_state.dart';

class GuidelinesBloc extends Bloc<GuidelinesEvent, GuidelinesState> {
  GuidelinesRepository guidelinesRepository;
  GuidelinesBloc(this.guidelinesRepository) : super(GuidelinesInitialState()) {
    on<GetGuidelinesEvent>(_onGetGuidelinesEvent);
  }

  void _onGetGuidelinesEvent(GetGuidelinesEvent event, Emitter emit) async {
    emit(GuidelinesLoadingState());
    try {
      List<Guidelines> appInfo = await guidelinesRepository.getAppInfo();
      emit(GuidelinesSuccessfulState(appInfo));
    } catch (e) {
      emit(GuidelinesFailureState(e.toString()));
    }
  }
}

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  GuidelinesRepository guidelinesRepository;
  FeedbackBloc(this.guidelinesRepository) : super(FeedbackInitialState()) {
    on<GetFeedbackTypeEvent>(_onGetFeedbackTypeEvent);
    on<PostFeedbackEvent>(_onPostFeedbackEvent);
  }

  void _onGetFeedbackTypeEvent(GetFeedbackTypeEvent event, Emitter emit) async {
    emit(FeedbackTypeLoadingState());
    try {
      List<FeedbackTypes> feedbackTypes =
          await guidelinesRepository.getFeedbackTypes();
      emit(FeedbackTypeSuccessfulState(feedbackTypes));
    } catch (e) {
      emit(FeedbackTypeFailureState(e.toString()));
    }
  }

  void _onPostFeedbackEvent(PostFeedbackEvent event, Emitter emit) async {
    emit(FeedbackLoadingState());
    try {
      await guidelinesRepository.giveFeedback(event.feedback);
      emit(FeedbackSuccessfulState());
    } catch (e) {
      emit(FeedbackFailureState(e.toString()));
    }
  }
}
