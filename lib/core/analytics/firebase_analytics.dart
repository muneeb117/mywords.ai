import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:mywords/core/analytics/analytics_service.dart';

class FirebaseAnalyticsService extends AnalyticsService {
  final FirebaseAnalytics _firebaseAnalytics;

  FirebaseAnalyticsService({required FirebaseAnalytics firebaseAnalytics}) : _firebaseAnalytics = firebaseAnalytics;

  @override
  void logEvent({required String name, Map<String, Object>? parameters}) {
    _firebaseAnalytics.logEvent(name: name, parameters: parameters);
  }
}