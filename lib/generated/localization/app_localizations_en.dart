// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Spines';

  @override
  String get welcomeTitle => 'Welcome to Spines';

  @override
  String get welcomeSubtitle => 'Your personal online reader';

  @override
  String get selectLanguage => 'Choose your preferred language';

  @override
  String get continueText => 'Continue';

  @override
  String get skip => 'Skip';

  @override
  String get english => 'English';

  @override
  String get russian => 'Russian';

  @override
  String get continueButton => 'Continue';

  @override
  String get selectedLanguage => 'Selected language';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get welcome => 'Welcome!';

  @override
  String get whatToRead => 'What will we read today?';

  @override
  String get newBooks => 'New Books';

  @override
  String get recommended => 'Recommended';

  @override
  String get popular => 'Popular';

  @override
  String get description => 'Description';

  @override
  String get reviews => 'Reviews';

  @override
  String get writeReview => 'Write a review';

  @override
  String get noReviews => 'No reviews yet';

  @override
  String get beFirstToReview => 'Be the first to leave a review';

  @override
  String get leaveReview => 'Leave a review';

  @override
  String get rating => 'Rating';

  @override
  String get yourReview => 'Your review';

  @override
  String get yourRating => 'Your rating';

  @override
  String get cancel => 'Cancel';

  @override
  String get send => 'Send';

  @override
  String get reviewHint => 'Write what you think about the book...';

  @override
  String get thanksForReview => 'Thank you for your review';

  @override
  String get home => 'Home';

  @override
  String get favorites => 'Favorites';

  @override
  String get removedFromFavorites => 'Removed from favorites';

  @override
  String get addedToFavorites => 'Added to favorites';

  @override
  String get myShelf => 'My Shelf';

  @override
  String get profile => 'Profile';

  @override
  String get read => 'Read';

  @override
  String get edit => 'Edit';

  @override
  String get details => 'Details';

  @override
  String get remove => 'Remove';

  @override
  String get editBook => 'Edit book';

  @override
  String get title => 'Title';

  @override
  String get author => 'Author';

  @override
  String get publicationYear => 'Publication year';

  @override
  String get bookDescription => 'Description';

  @override
  String get bookInfoUpdated => 'Book information updated';

  @override
  String get enterTitle => 'Введите название';

  @override
  String get enterAuthor => 'Введите автора';

  @override
  String get enterYear => 'Введите год';

  @override
  String get enterDescription => 'Введите описание';

  @override
  String get save => 'Save';

  @override
  String get removeFromShelf => 'Remove from shelf';

  @override
  String removeConfirm(Object title) {
    return 'Remove \"$title\" from your shelf?';
  }

  @override
  String removedFromShelf(Object title) {
    return '\"$title\" removed from shelf';
  }

  @override
  String get settings => 'Settings';

  @override
  String get appLanguage => 'App language';

  @override
  String get account => 'Account';

  @override
  String get version => 'Version 1.0.0';

  @override
  String get logout => 'Log out';

  @override
  String get logoutDescription => 'End current session';

  @override
  String get logoutTitle => 'Log out';

  @override
  String get logoutConfirm => 'Are you sure you want to log out?';

  @override
  String get loggedOut => 'You have been logged out';

  @override
  String get findBook => 'Here you can find a book to your liking';

  @override
  String get login => 'Log in';

  @override
  String get login1 => 'Login';

  @override
  String get loginSubtitle => 'Login to continue';

  @override
  String get register => 'Sign up';

  @override
  String get joinReaders => 'Join thousands of readers';

  @override
  String get enterEmail => 'Enter email';

  @override
  String get validEmail => 'Enter a valid email';

  @override
  String get password => 'Password';

  @override
  String get enterPassword => 'Enter password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get or => 'or';

  @override
  String get noAccount => 'Don\'t have an account? Sign up';

  @override
  String get registration => 'Registration';

  @override
  String get registering => 'Registering...';

  @override
  String get createAccount => 'Create an account';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get passwordsNotMatch => 'Passwords do not match';

  @override
  String get signUp => 'Sign up';

  @override
  String get hasAccount => 'Already have an account? Log in';

  @override
  String get readLater => 'Read later';

  @override
  String get alreadyOnShelf => 'Already on shelf';

  @override
  String get readNow => 'Read now';

  @override
  String get addToShelf => 'Add to shelf';

  @override
  String get addToShelfFirst =>
      'To start reading, first add the book to your shelf';

  @override
  String get add => 'Add';

  @override
  String get addedToShelf => 'Book added to shelf';

  @override
  String get genres => 'Genres';

  @override
  String get addToShelf2 => 'Add to shelf';

  @override
  String get loadingShelf => 'Loading shelf...';

  @override
  String get ratingExcellent => 'Excellent!';

  @override
  String get ratingGood => 'Good';

  @override
  String get ratingNormal => 'Normal';

  @override
  String get ratingSoSo => 'So so';

  @override
  String get ratingBad => 'Bad';

  @override
  String get emptyFavorites => 'It\'s empty here';

  @override
  String get addToFavoritesHint => 'Add books to favorites to see them here';

  @override
  String get findBooks => 'Find books';

  @override
  String get filters => 'Filters';

  @override
  String get reset => 'Reset';

  @override
  String get search => 'Search';

  @override
  String get searchHint => 'Title or author...';

  @override
  String get minRating => 'Minimum rating';

  @override
  String get sort => 'Sort';

  @override
  String get show => 'Show';
}
