import 'package:flutter/widgets.dart';

class UlesLocalizations {
  UlesLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('ru'), Locale('kk')];

  static const LocalizationsDelegate<UlesLocalizations> delegate =
      _UlesLocalizationsDelegate();

  static UlesLocalizations of(BuildContext context) {
    return Localizations.of<UlesLocalizations>(context, UlesLocalizations)!;
  }

  static const _values = {
    'ru': {
      'buyTogether': 'Покупай дешевле вместе',
      'buyTogetherBody': 'Группы покупателей открывают оптовые цены на любимых маркетплейсах.',
      'honestFeed': 'Лента без магии',
      'honestFeedBody': 'Каждая рекомендация показывает, почему товар подходит именно тебе.',
      'esimShield': 'Защита через eSIM',
      'esimShieldBody': 'Одно устройство занимает одно честное место в группе.',
      'start': 'Начать',
      'next': 'Далее',
      'phoneEmail': 'Телефон или email',
      'continueText': 'Продолжить',
      'verifyDevice': 'Верифицировать устройство',
      'scanDevice': 'Сканируем профиль устройства',
      'verifiedDevice': 'Verified Device',
      'deviceBound': 'Это место в группе закреплено за этим устройством — никто не сможет его подделать',
      'aboutYou': 'Расскажите о себе',
      'name': 'Имя',
      'age': 'Возраст',
      'gender': 'Пол',
      'city': 'Город',
      'budget': 'Бюджет',
      'chooseInterests': 'Выберите интересы',
      'save': 'Сохранить',
      'feedTitle': 'Выгодные группы рядом',
      'hello': 'Салам, Айдана',
      'group': 'группа',
      'collected': 'собрано',
      'retail': 'Розница',
      'groupPrice': 'Цена группы',
      'youSave': 'Ты экономишь',
      'joinGroup': 'Присоединиться',
      'whyRecommended': 'Почему рекомендовано',
      'score': 'Скоринг',
      'interests': 'Интересы',
      'budgetFit': 'Бюджет',
      'cityPopularity': 'Популярность в городе',
      'groupCloseness': 'Близость к закрытию',
      'peopleCheaper': 'Чем больше людей — тем дешевле',
      'seller': 'Продавец',
      'kaspiHold': 'Kaspi Pay холдирование',
      'kaspiHoldBody': 'Сумма заблокирована на карте. Списание произойдёт только при закрытии группы. Если группа не соберётся за 48 часов — автоматический возврат.',
      'confirmJoin': 'Подтвердить участие',
      'groupComplete': 'Группа собрана!',
      'finalPriceFixed': 'Финальная цена зафиксирована',
      'orderStatus': 'Статус заказа',
      'profile': 'Профиль',
      'settings': 'Настройки',
      'theme': 'Тёмная тема',
      'language': 'Язык',
      'purchaseHistory': 'История покупок',
      'manageInterests': 'Управлять интересами',
    },
    'kk': {
      'buyTogether': 'Бірге арзанырақ сатып ал',
      'buyTogetherBody': 'Сатып алушылар тобы сүйікті маркетплейстерде көтерме бағаны ашады.',
      'honestFeed': 'Сиқырсыз лента',
      'honestFeedBody': 'Әр ұсыныс тауардың неге сай екенін ашық көрсетеді.',
      'esimShield': 'eSIM арқылы қорғаныс',
      'esimShieldBody': 'Бір құрылғы топта бір әділ орын алады.',
      'start': 'Бастау',
      'next': 'Келесі',
      'phoneEmail': 'Телефон немесе email',
      'continueText': 'Жалғастыру',
      'verifyDevice': 'Құрылғыны растау',
      'scanDevice': 'Құрылғы профилін тексеріп жатырмыз',
      'verifiedDevice': 'Verified Device',
      'deviceBound': 'Бұл топтағы орын осы құрылғыға бекітілген — оны ешкім қолдан жасай алмайды',
      'aboutYou': 'Өзіңіз туралы',
      'name': 'Аты',
      'age': 'Жасы',
      'gender': 'Жынысы',
      'city': 'Қала',
      'budget': 'Бюджет',
      'chooseInterests': 'Қызығушылықтарды таңдаңыз',
      'save': 'Сақтау',
      'feedTitle': 'Жақындағы тиімді топтар',
      'hello': 'Сәлем, Айдана',
      'group': 'топ',
      'collected': 'жиналды',
      'retail': 'Бөлшек',
      'groupPrice': 'Топ бағасы',
      'youSave': 'Үнем',
      'joinGroup': 'Қосылу',
      'whyRecommended': 'Неге ұсынылды',
      'score': 'Скоринг',
      'interests': 'Қызығушылық',
      'budgetFit': 'Бюджет',
      'cityPopularity': 'Қаладағы танымалдық',
      'groupCloseness': 'Жабылуға жақын',
      'peopleCheaper': 'Адам көп болса — баға төмен',
      'seller': 'Сатушы',
      'kaspiHold': 'Kaspi Pay холд',
      'kaspiHoldBody': 'Сома картада бұғатталады. Топ жабылғанда ғана шешіледі. 48 сағатта топ жиналмаса — автоматты қайтарым.',
      'confirmJoin': 'Қатысуды растау',
      'groupComplete': 'Топ жиналды!',
      'finalPriceFixed': 'Соңғы баға бекітілді',
      'orderStatus': 'Тапсырыс статусы',
      'profile': 'Профиль',
      'settings': 'Баптаулар',
      'theme': 'Қараңғы тема',
      'language': 'Тіл',
      'purchaseHistory': 'Сатып алу тарихы',
      'manageInterests': 'Қызығушылықтарды басқару',
    },
  };

  String t(String key) => _values[locale.languageCode]![key] ?? _values['ru']![key] ?? key;
}

class _UlesLocalizationsDelegate extends LocalizationsDelegate<UlesLocalizations> {
  const _UlesLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ru', 'kk'].contains(locale.languageCode);

  @override
  Future<UlesLocalizations> load(Locale locale) async => UlesLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<UlesLocalizations> old) => false;
}
