import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Urls {
  Urls._();

  static const _termsOfService = 'https://google.com/';
  static const _privacyPolicy = 'https://google.com/';

  static void showTermsOfService() => _show(_termsOfService);

  static void showPrivacyPolicy() => _show(_privacyPolicy);

  static void _show(String url) {
    launchUrl(Uri.parse(url));
  }

  static String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  static void sendFeedbackEmail(BuildContext context, String feedback) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'mywordsaimehdi@gmail.com',
      query: encodeQueryParameters(<String, String>{'subject': 'Feedback', 'body': feedback}),
    );

    launchUrl(emailUri);
  }

  static navigateToStoreForReview() {
    final appId = Platform.isAndroid ? 'com.ai.mywords' : 'com.ai.mywords';
    final uri = Uri.parse(
      Platform.isAndroid ? "market://details?id=$appId" : "https://apps.apple.com/app/id$appId",
    );
    launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
