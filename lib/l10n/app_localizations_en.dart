// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get chatbot_welcome => '🌾 Welcome to Farmitra AI!\nHow can I assist you with soil, crops, fertilizers, or irrigation today?';

  @override
  String get chatbot_placeholder => 'Ask about farming...';

  @override
  String get send_button => 'Send';

  @override
  String get delete_history => 'Delete Chat History';
}
