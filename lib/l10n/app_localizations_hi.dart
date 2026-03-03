// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get chatbot_welcome => '🌾 फार्मित्रा एआई में आपका स्वागत है!\nमैं मिट्टी, फसल, उर्वरक या सिंचाई में आपकी कैसे मदद कर सकता हूँ?';

  @override
  String get chatbot_placeholder => 'कृषि के बारे में पूछें...';

  @override
  String get send_button => 'भेजें';

  @override
  String get delete_history => 'चैट इतिहास हटाएं';
}
