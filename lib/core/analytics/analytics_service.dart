abstract class AnalyticsService {
  Future<void> logEvent(String name, {Map<String, dynamic>? parameters});
}