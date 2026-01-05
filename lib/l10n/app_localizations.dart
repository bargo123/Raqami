import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'Raqami'**
  String get appName;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Welcome back message on login screen
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Log in button text
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// Subtitle on login screen
  ///
  /// In en, this message translates to:
  /// **'Log in to continue shopping'**
  String get logInToContinueShopping;

  /// Sign up button text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Email label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Email field hint text
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// Password label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Password field hint text
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// Confirm password label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Phone number label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Phone number field hint text
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhoneNumber;

  /// Full name label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Full name field hint text
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get johnDoe;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Edit button text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Profile label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Home label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Categories label
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// Wishlist label
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlist;

  /// Settings label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Sign out button text
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Edit profile label
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Error message
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Success message
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Text on login screen
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAnAccount;

  /// Create account button/link text
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Heading on create account screen
  ///
  /// In en, this message translates to:
  /// **'Create your Raqami account'**
  String get createYourRaqamiAccount;

  /// Subtitle on create account screen
  ///
  /// In en, this message translates to:
  /// **'Join Raqami and find your number'**
  String get joinRaqamiAndFindYourNumber;

  /// Terms agreement text part 1
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get iAgreeToThe;

  /// Terms agreement link text
  ///
  /// In en, this message translates to:
  /// **'Terms & Privacy Policy'**
  String get termsAndPrivacyPolicy;

  /// Text on create account screen
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAnAccount;

  /// Heading on email verification screen
  ///
  /// In en, this message translates to:
  /// **'Verify your email'**
  String get verifyYourEmail;

  /// Email verification message
  ///
  /// In en, this message translates to:
  /// **'We sent a verification email to {email}. Please check your email and click the verification link, then click Verify below.'**
  String weSentAVerificationEmailTo(String email);

  /// Verify button text
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// Success message after account creation
  ///
  /// In en, this message translates to:
  /// **'Account created successfully! Please log in.'**
  String get accountCreatedSuccessfullyPleaseLogIn;

  /// Success message after profile update
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// Account section header
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get account;

  /// Notifications menu item
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Language menu item
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Support section header
  ///
  /// In en, this message translates to:
  /// **'SUPPORT'**
  String get support;

  /// Contact Us menu item
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// About Us menu item
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// About Us screen description
  ///
  /// In en, this message translates to:
  /// **'Your trusted platform for buying and selling phone numbers and car plates in the UAE.'**
  String get aboutUsDescription;

  /// About Raqami section title
  ///
  /// In en, this message translates to:
  /// **'About Raqami'**
  String get aboutRaqami;

  /// About Raqami section content
  ///
  /// In en, this message translates to:
  /// **'Raqami is a dedicated marketplace platform designed to connect buyers and sellers of premium phone numbers and car license plates in the United Arab Emirates. We provide a secure, user-friendly environment for transactions while ensuring authenticity and quality.'**
  String get aboutRaqamiContent;

  /// Features section title
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get features;

  /// Features section content
  ///
  /// In en, this message translates to:
  /// **'• Browse premium phone numbers and car plates\n• Create and manage your listings\n• Save your favorite items to wishlist\n• Direct communication with sellers\n• Secure transactions'**
  String get featuresContent;

  /// Contact Us section title in About Us screen
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get aboutUsContactTitle;

  /// Contact Us section content in About Us screen
  ///
  /// In en, this message translates to:
  /// **'If you have any questions, suggestions, or need support, please feel free to reach out to us through the Contact Us section in your profile.'**
  String get aboutUsContactContent;

  /// Version text with version number
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// Copyright text
  ///
  /// In en, this message translates to:
  /// **'© 2026 Raqami. All rights reserved.'**
  String get copyright;

  /// Privacy Policy menu item
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Version text with version number
  ///
  /// In en, this message translates to:
  /// **'RAQAMI · Version {version}'**
  String raqamiVersion(String version);

  /// Following label
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// Full name validation error
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameIsRequired;

  /// Phone number validation error
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneNumberIsRequired;

  /// Name validation error
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameIsRequired;

  /// Email validation error
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailIsRequired;

  /// Email format validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseEnterAValidEmailAddress;

  /// Password validation error
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordIsRequired;

  /// Password length validation error
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMustBeAtLeast6Characters;

  /// Terms acceptance validation error
  ///
  /// In en, this message translates to:
  /// **'Please accept the Terms & Privacy Policy'**
  String get pleaseAcceptTheTermsAndPrivacyPolicy;

  /// Email already in use error
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists'**
  String get anAccountWithThisEmailAlreadyExists;

  /// Invalid email error
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmailAddress;

  /// Weak password error
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get passwordIsTooWeak;

  /// Network error message
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection'**
  String get networkErrorPleaseCheckYourConnection;

  /// Email not verified error
  ///
  /// In en, this message translates to:
  /// **'Email not verified. Please check your email and click the verification link.'**
  String get emailNotVerifiedPleaseCheckYourEmailAndClickTheVerificationLink;

  /// Account creation failed error
  ///
  /// In en, this message translates to:
  /// **'Account creation failed. Please try again'**
  String get accountCreationFailedPleaseTryAgain;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something unexpected happened. Please try again.'**
  String get somethingUnexpectedHappenedPleaseTryAgain;

  /// User not found error
  ///
  /// In en, this message translates to:
  /// **'No account found with this email'**
  String get noAccountFoundWithThisEmail;

  /// Wrong password error
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get incorrectPassword;

  /// Account disabled error
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled'**
  String get thisAccountHasBeenDisabled;

  /// Too many requests error
  ///
  /// In en, this message translates to:
  /// **'Too many failed attempts. Please try again later'**
  String get tooManyFailedAttemptsPleaseTryAgainLater;

  /// Login failed error
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again'**
  String get loginFailedPleaseTryAgain;

  /// Create post button and title
  ///
  /// In en, this message translates to:
  /// **'Create Post'**
  String get createPost;

  /// Post type label
  ///
  /// In en, this message translates to:
  /// **'Post Type'**
  String get postType;

  /// Car plate label
  ///
  /// In en, this message translates to:
  /// **'Car Plate'**
  String get carPlate;

  /// Plate number label
  ///
  /// In en, this message translates to:
  /// **'Plate Number'**
  String get plateNumber;

  /// Plate number hint
  ///
  /// In en, this message translates to:
  /// **'Enter plate number'**
  String get enterPlateNumber;

  /// Select emirate label
  ///
  /// In en, this message translates to:
  /// **'Select Emirate'**
  String get selectEmirate;

  /// Emirate label
  ///
  /// In en, this message translates to:
  /// **'Emirate'**
  String get emirate;

  /// Price label
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// Price hint
  ///
  /// In en, this message translates to:
  /// **'Enter price'**
  String get enterPrice;

  /// Description label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Description hint
  ///
  /// In en, this message translates to:
  /// **'Enter description (optional)'**
  String get enterDescription;

  /// Post creation success message
  ///
  /// In en, this message translates to:
  /// **'Post created successfully'**
  String get postCreatedSuccessfully;

  /// Success message after deleting a post
  ///
  /// In en, this message translates to:
  /// **'Post deleted successfully'**
  String get postDeletedSuccessfully;

  /// Plate number validation error
  ///
  /// In en, this message translates to:
  /// **'Plate number is required'**
  String get plateNumberIsRequired;

  /// Invalid plate format error
  ///
  /// In en, this message translates to:
  /// **'Invalid plate format. Please enter 1-5 digits'**
  String get invalidPlateFormat;

  /// Price validation error
  ///
  /// In en, this message translates to:
  /// **'Price is required'**
  String get priceIsRequired;

  /// Invalid price error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid price'**
  String get invalidPrice;

  /// Emirate selection error
  ///
  /// In en, this message translates to:
  /// **'Please select an emirate'**
  String get emirateIsRequired;

  /// Post information screen title
  ///
  /// In en, this message translates to:
  /// **'Post Information'**
  String get postInformation;

  /// Contact poster section title
  ///
  /// In en, this message translates to:
  /// **'Contact Poster'**
  String get contactPoster;

  /// WhatsApp button label
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsApp;

  /// Call button label
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// WhatsApp error message
  ///
  /// In en, this message translates to:
  /// **'Could not open WhatsApp'**
  String get couldNotOpenWhatsApp;

  /// Phone call error message
  ///
  /// In en, this message translates to:
  /// **'Could not make phone call'**
  String get couldNotMakePhoneCall;

  /// Price hidden text
  ///
  /// In en, this message translates to:
  /// **'Price hidden'**
  String get priceHidden;

  /// Posted label
  ///
  /// In en, this message translates to:
  /// **'Posted'**
  String get posted;

  /// Sold label
  ///
  /// In en, this message translates to:
  /// **'SOLD'**
  String get sold;

  /// Today label
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Yesterday label
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Days ago label
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(int count);

  /// Edit post screen title
  ///
  /// In en, this message translates to:
  /// **'Edit Post'**
  String get editPost;

  /// Plate code label
  ///
  /// In en, this message translates to:
  /// **'Plate Code'**
  String get plateCode;

  /// Mark as sold label
  ///
  /// In en, this message translates to:
  /// **'Mark as Sold'**
  String get markAsSold;

  /// Save changes button text
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Delete post dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Post'**
  String get deletePost;

  /// Delete post confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this post? This action cannot be undone.'**
  String get areYouSureYouWantToDeleteThisPost;

  /// Number label
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get number;

  /// Code hint text
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// Post not found error
  ///
  /// In en, this message translates to:
  /// **'Post not found'**
  String get postNotFound;

  /// Route not found error
  ///
  /// In en, this message translates to:
  /// **'No route defined for {route}'**
  String noRouteDefinedFor(String route);

  /// Image loading error
  ///
  /// In en, this message translates to:
  /// **'Image Error'**
  String get imageError;

  /// Wishlist sign in message
  ///
  /// In en, this message translates to:
  /// **'Please sign in to view your wishlist'**
  String get pleaseSignInToViewYourWishlist;

  /// Wishlist loading error
  ///
  /// In en, this message translates to:
  /// **'Error loading wishlist: {error}'**
  String errorLoadingWishlist(String error);

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Empty wishlist message
  ///
  /// In en, this message translates to:
  /// **'No liked posts yet'**
  String get noLikedPostsYet;

  /// My posts screen title
  ///
  /// In en, this message translates to:
  /// **'My Posts'**
  String get myPosts;

  /// My posts sign in message
  ///
  /// In en, this message translates to:
  /// **'Please log in to view your posts'**
  String get pleaseLogInToViewYourPosts;

  /// Posts loading error
  ///
  /// In en, this message translates to:
  /// **'Error loading posts: {error}'**
  String errorLoadingPosts(String error);

  /// Empty posts message
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get noPostsYet;

  /// Empty posts hint
  ///
  /// In en, this message translates to:
  /// **'Create your first post to see it here'**
  String get createYourFirstPostToSeeItHere;

  /// Error message when plate number is empty
  ///
  /// In en, this message translates to:
  /// **'Plate number is required'**
  String get plateNumberRequired;

  /// Error message when phone number is empty
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneNumberRequired;

  /// Error message when plate code is empty
  ///
  /// In en, this message translates to:
  /// **'Plate code is required'**
  String get plateCodeRequired;

  /// Error message when plate code is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid plate code'**
  String get invalidPlateCode;

  /// Line type label
  ///
  /// In en, this message translates to:
  /// **'Line Type'**
  String get lineType;

  /// Line type dropdown hint
  ///
  /// In en, this message translates to:
  /// **'Choose line type'**
  String get chooseLineType;

  /// Prepaid line type
  ///
  /// In en, this message translates to:
  /// **'Prepaid'**
  String get prepaid;

  /// Postpaid line type
  ///
  /// In en, this message translates to:
  /// **'Postpaid'**
  String get postpaid;

  /// Error message when phone code is empty
  ///
  /// In en, this message translates to:
  /// **'Phone code is required'**
  String get phoneCodeIsRequired;

  /// Error message when phone number is not 7 digits
  ///
  /// In en, this message translates to:
  /// **'Phone number must be exactly 7 digits'**
  String get phoneNumberMustBe7Digits;

  /// Title for report post dialog
  ///
  /// In en, this message translates to:
  /// **'Report Post'**
  String get reportPost;

  /// Description text in report post dialog
  ///
  /// In en, this message translates to:
  /// **'Please select a reason for reporting this post'**
  String get reportPostDescription;

  /// Placeholder for additional details text field
  ///
  /// In en, this message translates to:
  /// **'Additional details (optional)'**
  String get additionalDetails;

  /// Submit button text
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// Success message after submitting report
  ///
  /// In en, this message translates to:
  /// **'Report submitted successfully'**
  String get reportSubmitted;

  /// Description text in contact us screen
  ///
  /// In en, this message translates to:
  /// **'We\'d love to hear from you! Send us an email and we\'ll respond as soon as possible.'**
  String get contactUsDescription;

  /// Button text to send email
  ///
  /// In en, this message translates to:
  /// **'Send Email'**
  String get sendEmail;

  /// Information text about response time
  ///
  /// In en, this message translates to:
  /// **'We typically respond within 24-48 hours. For urgent matters, please include \'URGENT\' in your subject line.'**
  String get contactUsInfo;

  /// Error message when email app cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Could not open email app'**
  String get couldNotOpenEmail;

  /// Message when email is copied to clipboard
  ///
  /// In en, this message translates to:
  /// **'Email copied'**
  String get emailCopied;

  /// Copy button text
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// Search button text
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Reset button text
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Provider label in filter
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get provider;

  /// Digit count label in filter
  ///
  /// In en, this message translates to:
  /// **'Digit Count'**
  String get digitCount;

  /// Empty state message when there are no posts
  ///
  /// In en, this message translates to:
  /// **'No posts available'**
  String get noPostsAvailable;

  /// Empty state message when wishlist is empty
  ///
  /// In en, this message translates to:
  /// **'You did not add any posts to wishlist'**
  String get noWishlistPosts;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
