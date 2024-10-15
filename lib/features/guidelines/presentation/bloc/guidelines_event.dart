import 'package:qenan/features/guidelines/data/models/feedback.dart';

abstract class GuidelinesEvent {}

class GetGuidelinesEvent extends GuidelinesEvent {}

abstract class FeedbackEvent {}

class GetFeedbackTypeEvent extends FeedbackEvent {}

class PostFeedbackEvent extends FeedbackEvent {
  final FeedbackModel feedback;
  PostFeedbackEvent(this.feedback);
}
