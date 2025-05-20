import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('uz'),
    Locale.fromSubtags(languageCode: 'uz', scriptCode: 'Cyrl'),
    Locale.fromSubtags(languageCode: 'uz', scriptCode: 'Latn')
  ];

  /// No description provided for @getStarted.
  ///
  /// In uz, this message translates to:
  /// **'Boshlaymiz'**
  String get getStarted;

  /// Bosh sahifadagi salomlashish xabari.
  ///
  /// In uz, this message translates to:
  /// **'Katlavan.uz ga xush kelibsiz'**
  String get welcomeMessage;

  /// Ilovada taqdim etilayotgan tajribani tavsiflovchi qoshiq xabari.
  ///
  /// In uz, this message translates to:
  /// **'Qurilish ehtiyojlaringiz uchun mukammal ulgurji materiallarni topish uchun chuqur va boy tajribali sayohatni boshlang.'**
  String get startJourney;

  /// Foydalanuvchilarni qurilish materiallarini qidirishni boshlashga undovchi matn.
  ///
  /// In uz, this message translates to:
  /// **'Ommaviy materiallarni topishni boshlang'**
  String get startFinding;

  /// Ommaviy materiallarni topish va sotib olishning osonligini ta'kidlovchi matn.
  ///
  /// In uz, this message translates to:
  /// **'Qurilish loyihalaringiz uchun to\'g\'ri ommaviy materiallarni osonlik bilan toping va sotib oling'**
  String get discoverSource;

  /// Foydalanuvchi ro'yxatdan o'tishi uchun tugma matni.
  ///
  /// In uz, this message translates to:
  /// **'Ro\'yxatdan o\'tish'**
  String get signUp;

  /// Foydalanuvchining tizimga kirishi uchun tugma matni.
  ///
  /// In uz, this message translates to:
  /// **'Kirish'**
  String get login;

  /// Telefon raqami kiritish maydoni uchun yozuv.
  ///
  /// In uz, this message translates to:
  /// **'Telefon raqami'**
  String get phoneNumber;

  /// Foydalanuvchidan profil mavjudligini so'raydigan savol.
  ///
  /// In uz, this message translates to:
  /// **'Allaqachon profilingiz bormi?'**
  String get haveAccount;

  /// Foydalanuvchi ismini kiritishi uchun maydon.
  ///
  /// In uz, this message translates to:
  /// **'Ismingiz'**
  String get fullName;

  /// Foydalanuvchiga yuborilgan tasdiqlash kodini kiritish bo'yicha ko'rsatma.
  ///
  /// In uz, this message translates to:
  /// **'Telefon raqamingizga yuborilgan kodni kiriting'**
  String get enterCode;

  /// Foydalanuvchi 6 xonali tasdiqlash kodini kiritishi kerakligini bildiruvchi matn.
  ///
  /// In uz, this message translates to:
  /// **'Telefon raqamingizga yuborilgan 6 xonali kodni kiriting'**
  String get enterSixDigitCode;

  /// No description provided for @buyMaterials.
  ///
  /// In uz, this message translates to:
  /// **'Material sotib olish'**
  String get buyMaterials;

  /// No description provided for @findTruck.
  ///
  /// In uz, this message translates to:
  /// **'Yuk mashinasi'**
  String get findTruck;

  /// No description provided for @orders.
  ///
  /// In uz, this message translates to:
  /// **'Buyurtmalar'**
  String get orders;

  /// No description provided for @noOrders.
  ///
  /// In uz, this message translates to:
  /// **'Buyurtmalar yo\'q'**
  String get noOrders;

  /// No description provided for @all.
  ///
  /// In uz, this message translates to:
  /// **'Barchasi'**
  String get all;

  /// No description provided for @active.
  ///
  /// In uz, this message translates to:
  /// **'Faol'**
  String get active;

  /// No description provided for @remainingTime.
  ///
  /// In uz, this message translates to:
  /// **'Qolgan vaqt'**
  String get remainingTime;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'uz': {
  switch (locale.scriptCode) {
    case 'Cyrl': return AppLocalizationsUzCyrl();
case 'Latn': return AppLocalizationsUzLatn();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'uz': return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
