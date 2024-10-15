import 'package:qenan/features/guidelines/data/dataSources/guidelinesDataSource.dart';
import 'package:qenan/features/guidelines/data/models/feedback.dart';
import 'package:qenan/features/guidelines/data/models/feedbackTypes.dart';
import 'package:qenan/features/guidelines/data/models/guidelines.dart';

class GuidelinesRepository {
  GuidelinesRemoteDataSource guidelinesRemoteDataSource;
  GuidelinesRepository(this.guidelinesRemoteDataSource);
  Future<List<Guidelines>> getAppInfo() async {
    try {
      final appInfo = await guidelinesRemoteDataSource.getGuidelines();
      return appInfo;
    } catch (e) {
      throw e;
    }
  }

  Future<List<FeedbackTypes>> getFeedbackTypes() async {
    try {
      final feedbackTypes = await guidelinesRemoteDataSource.getFeedbackTypes();
      return feedbackTypes;
    } catch (e) {
      throw e;
    }
  }

  Future giveFeedback(FeedbackModel feedback) async {
    try {
      await guidelinesRemoteDataSource.giveFeedback(feedback);
    } catch (e) {
      throw e;
    }
  }
}
