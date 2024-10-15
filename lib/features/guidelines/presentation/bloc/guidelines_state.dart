import 'package:qenan/features/guidelines/data/models/feedbackTypes.dart';
import 'package:qenan/features/guidelines/data/models/guidelines.dart';

abstract class GuidelinesState {}

class GuidelinesInitialState extends GuidelinesState {}

class GuidelinesLoadingState extends GuidelinesState {}

class GuidelinesSuccessfulState extends GuidelinesState {
  final List<Guidelines> guidelines;
  GuidelinesSuccessfulState(this.guidelines);
}

class GuidelinesFailureState extends GuidelinesState {
  final String error;
  GuidelinesFailureState(this.error);
}

abstract class FeedbackState {}

class FeedbackInitialState extends FeedbackState {}

class FeedbackTypeLoadingState extends FeedbackState {}

class FeedbackTypeSuccessfulState extends FeedbackState {
  final List<FeedbackTypes> feedbackTypes;
  FeedbackTypeSuccessfulState(this.feedbackTypes);
}

class FeedbackTypeFailureState extends FeedbackState {
  final String error;
  FeedbackTypeFailureState(this.error);
}

class FeedbackLoadingState extends FeedbackState {}

class FeedbackSuccessfulState extends FeedbackState {}

class FeedbackFailureState extends FeedbackState {
  final String error;
  FeedbackFailureState(this.error);
}
