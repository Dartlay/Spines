// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Spines';

  @override
  String get welcomeTitle => 'Добро пожаловать в Spines';

  @override
  String get welcomeSubtitle => 'Ваш персональный онлайн-читатель';

  @override
  String get selectLanguage => 'Выберите предпочитаемый язык';

  @override
  String get continueText => 'Продолжить';

  @override
  String get skip => 'Пропустить';

  @override
  String get english => 'Английский';

  @override
  String get russian => 'Русский';

  @override
  String get continueButton => 'Продолжить';

  @override
  String get selectedLanguage => 'Выбранный язык';

  @override
  String get goodMorning => 'Доброе утро';

  @override
  String get goodAfternoon => 'Добрый день';

  @override
  String get goodEvening => 'Добрый вечер';

  @override
  String get welcome => 'Добро пожаловать!';

  @override
  String get whatToRead => 'Что будем читать сегодня?';

  @override
  String get newBooks => 'Новинки';

  @override
  String get recommended => 'Рекомендуем';

  @override
  String get popular => 'Популярное';

  @override
  String get description => 'Описание';

  @override
  String get reviews => 'Отзывы';

  @override
  String get writeReview => 'Написать';

  @override
  String get noReviews => 'Пока нету отзывов';

  @override
  String get beFirstToReview => 'Будьте первым, кто оставит отзыв';

  @override
  String get leaveReview => 'Оставить отзыв';

  @override
  String get rating => 'Оценка';

  @override
  String get yourReview => 'Ваш отзыв';

  @override
  String get yourRating => 'Ваша оценка';

  @override
  String get cancel => 'Отмена';

  @override
  String get send => 'Отправить';

  @override
  String get reviewHint => 'Напишите что вы думаете о книге...';

  @override
  String get thanksForReview => 'Спасибо за отзыв';

  @override
  String get home => 'Главная';

  @override
  String get favorites => 'Избранное';

  @override
  String get removedFromFavorites => 'Удалено из избранного';

  @override
  String get addedToFavorites => 'Добавлено в избранное';

  @override
  String get myShelf => 'Моя полка';

  @override
  String get profile => 'Профиль';

  @override
  String get read => 'Читать';

  @override
  String get edit => 'Редактировать';

  @override
  String get details => 'Подробнее';

  @override
  String get remove => 'Убрать';

  @override
  String get editBook => 'Редактировать книгу';

  @override
  String get title => 'Название';

  @override
  String get author => 'Автор';

  @override
  String get publicationYear => 'Год издания';

  @override
  String get bookDescription => 'Описание';

  @override
  String get bookInfoUpdated => 'Информация о книге обновлена';

  @override
  String get enterTitle => 'Введите название';

  @override
  String get enterAuthor => 'Введите автора';

  @override
  String get enterYear => 'Введите год';

  @override
  String get enterDescription => 'Введите описание';

  @override
  String get save => 'Сохранить';

  @override
  String get removeFromShelf => 'Убрать с полки';

  @override
  String removeConfirm(Object title) {
    return 'Убрать \"$title\" с вашей полки?';
  }

  @override
  String removedFromShelf(Object title) {
    return '\"$title\" убрана с полки';
  }

  @override
  String get settings => 'Настройки';

  @override
  String get appLanguage => 'Язык приложения';

  @override
  String get account => 'Аккаунт';

  @override
  String get version => 'Версия 1.0.0';

  @override
  String get logout => 'Выйти из аккаунта';

  @override
  String get logoutDescription => 'Завершить текущую сессию';

  @override
  String get logoutTitle => 'Выход из аккаунта';

  @override
  String get logoutConfirm => 'Вы уверены, что хотите выйти?';

  @override
  String get loggedOut => 'Вы вышли из аккаунта';

  @override
  String get findBook => 'Здесь вы можете найти книгу себе по душе';

  @override
  String get login => 'Войти';

  @override
  String get login1 => 'Вход';

  @override
  String get loginSubtitle => 'Войдите чтобы продолжить';

  @override
  String get register => 'Зарегистрироваться';

  @override
  String get joinReaders => 'Присоединяйтесь к тысячам читателей';

  @override
  String get enterEmail => 'Введите email';

  @override
  String get validEmail => 'Введите корректный email';

  @override
  String get password => 'Пароль';

  @override
  String get enterPassword => 'Введите пароль';

  @override
  String get passwordMinLength => 'Пароль должен быть не менее 6 символов';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get or => 'или';

  @override
  String get noAccount => 'Нет аккаунта? Зарегистрироваться';

  @override
  String get registration => 'Регистрация';

  @override
  String get registering => 'Регистрация...';

  @override
  String get createAccount => 'Создайте аккаунт';

  @override
  String get confirmPassword => 'Подтвердите пароль';

  @override
  String get passwordsNotMatch => 'Пароли не совпадают';

  @override
  String get signUp => 'Зарегистрироваться';

  @override
  String get hasAccount => 'Уже есть аккаунт? Войти';

  @override
  String get readLater => 'Читать позже';

  @override
  String get alreadyOnShelf => 'Уже на полке';

  @override
  String get readNow => 'Читать';

  @override
  String get addToShelf => 'Добавьте на полку';

  @override
  String get addToShelfFirst =>
      'Чтобы начать читать, сначала добавьте книгу на свою полку';

  @override
  String get add => 'Добавить';

  @override
  String get addedToShelf => 'Книга добавлена на полку';

  @override
  String get genres => 'Жанры';

  @override
  String get addToShelf2 => 'Добавить на полку';

  @override
  String get loadingShelf => 'Загрузка полки...';

  @override
  String get ratingExcellent => 'Отлично!';

  @override
  String get ratingGood => 'Хорошо';

  @override
  String get ratingNormal => 'Нормально';

  @override
  String get ratingSoSo => 'Так себе';

  @override
  String get ratingBad => 'Плохо';

  @override
  String get emptyFavorites => 'Здесь пока пусто';

  @override
  String get addToFavoritesHint =>
      'Добавляйте книги в избранное, чтобы они появились здесь';

  @override
  String get findBooks => 'Найти книги';

  @override
  String get filters => 'Фильтры';

  @override
  String get reset => 'Сбросить';

  @override
  String get search => 'Поиск';

  @override
  String get searchHint => 'Название или автор...';

  @override
  String get minRating => 'Минимальный рейтинг';

  @override
  String get sort => 'Сортировка';

  @override
  String get show => 'Показать';

  @override
  String get loading => 'Загрузка...';
}
