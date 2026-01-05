import 'package:raqami/l10n/app_localizations.dart';

class ErrorLocalizationHelper {
  static String? getLocalizedError(String? errorKey, AppLocalizations localizations) {
    if (errorKey == null) return null;

    switch (errorKey) {
      // Validation errors
      case 'emailIsRequired':
        return localizations.emailIsRequired;
      case 'pleaseEnterAValidEmailAddress':
        return localizations.pleaseEnterAValidEmailAddress;
      case 'passwordIsRequired':
        return localizations.passwordIsRequired;
      case 'passwordMustBeAtLeast6Characters':
        return localizations.passwordMustBeAtLeast6Characters;
      case 'fullNameIsRequired':
        return localizations.fullNameIsRequired;
      case 'phoneNumberIsRequired':
        return localizations.phoneNumberIsRequired;
      case 'phoneNumberMustBe7Digits':
        return localizations.phoneNumberMustBe7Digits;
      case 'phoneCodeIsRequired':
        return localizations.phoneCodeIsRequired;
      case 'nameIsRequired':
        return localizations.nameIsRequired;
      case 'pleaseAcceptTheTermsAndPrivacyPolicy':
        return localizations.pleaseAcceptTheTermsAndPrivacyPolicy;
      
      // Firebase Auth errors
      case 'noAccountFoundWithThisEmail':
        return localizations.noAccountFoundWithThisEmail;
      case 'incorrectPassword':
        return localizations.incorrectPassword;
      case 'invalidEmailAddress':
        return localizations.invalidEmailAddress;
      case 'thisAccountHasBeenDisabled':
        return localizations.thisAccountHasBeenDisabled;
      case 'tooManyFailedAttemptsPleaseTryAgainLater':
        return localizations.tooManyFailedAttemptsPleaseTryAgainLater;
      case 'networkErrorPleaseCheckYourConnection':
        return localizations.networkErrorPleaseCheckYourConnection;
      case 'loginFailedPleaseTryAgain':
        return localizations.loginFailedPleaseTryAgain;
      case 'anAccountWithThisEmailAlreadyExists':
        return localizations.anAccountWithThisEmailAlreadyExists;
      case 'passwordIsTooWeak':
        return localizations.passwordIsTooWeak;
      case 'emailNotVerifiedPleaseCheckYourEmailAndClickTheVerificationLink':
        return localizations.emailNotVerifiedPleaseCheckYourEmailAndClickTheVerificationLink;
      case 'accountCreationFailedPleaseTryAgain':
        return localizations.accountCreationFailedPleaseTryAgain;
      case 'somethingUnexpectedHappenedPleaseTryAgain':
        return localizations.somethingUnexpectedHappenedPleaseTryAgain;
      case 'plateNumberIsRequired':
        return localizations.plateNumberIsRequired;
      case 'invalidPlateFormat':
        return localizations.invalidPlateFormat;
      case 'priceIsRequired':
        return localizations.priceIsRequired;
      case 'invalidPrice':
        return localizations.invalidPrice;
      case 'emirateIsRequired':
        return localizations.emirateIsRequired;
      case 'plateCodeIsRequired':
        return localizations.plateCodeRequired;
      case 'invalidPlateCode':
        return localizations.invalidPlateCode;
      
      default:
        // If it's not a key, return as-is (for backward compatibility or non-localized errors)
        return errorKey;
    }
  }
}

