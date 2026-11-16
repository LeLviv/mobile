enum AdviceCategory { sunny, cloudy, snow, rain }

class AdviceEntry {
  final AdviceCategory category;
  final int? min;
  final int? max;
  final String text;

  const AdviceEntry({
    required this.category,
    this.min,
    this.max,
    required this.text,
  });

  bool matches(AdviceCategory c, int temperature) {
    if (c != category) return false;
    if (min != null && temperature < min!) return false;
    if (max != null && temperature >= max!) return false;
    return true;
  }
}

abstract final class WeatherAdviceTable {
  static const List<AdviceEntry> entries = [
    AdviceEntry(
      category: AdviceCategory.sunny,
      max: -15,
      text:
      'сонце світить, але мороз щипає за щоки - закутуйтеся в найтепліший пуховик і біжіть грітися горнятком гарячої кави',
    ),
    AdviceEntry(
      category: AdviceCategory.sunny,
      min: -15,
      max: -5,
      text:
      'хрусткий зимовий день, ідеальний час на швидкий шпацер і свіжий сирник',
    ),
    AdviceEntry(
      category: AdviceCategory.sunny,
      min: -5,
      max: 0,
      text:
      'сонце вже файно пригріває, але на бруківці може бути слизько - взувайтеся зручно і накидайте теплу куртку',
    ),
    AdviceEntry(
      category: AdviceCategory.sunny,
      min: 0,
      max: 5,
      text:
      'батярський вітерець - затишний светр і легка куртка будуть якраз доречні',
    ),
    AdviceEntry(
      category: AdviceCategory.sunny,
      min: 5,
      max: 15,
      text:
      'файна погода для улюбленого тренча, сонячних окулярів та неспішних теревенів на лавці в парку Франка',
    ),
    AdviceEntry(
      category: AdviceCategory.sunny,
      min: 15,
      max: 20,
      text: 'одягайтеся легко, чудовий час для пальта та шпацеру з коліжанками',
    ),
    AdviceEntry(
      category: AdviceCategory.sunny,
      min: 20,
      max: 25,
      text:
      'золотий час для легкої сорочки, літнього майданчика на Ринку та філіжанки кави з фіґлями',
    ),
    AdviceEntry(
      category: AdviceCategory.sunny,
      min: 25,
      max: 30,
      text:
      'справжнє галицьке літо - діставайте легкі речі, окуляри від сонця і ховайтеся в затінку вузьких вуличок',
    ),
    AdviceEntry(
      category: AdviceCategory.sunny,
      min: 30,
      text:
      'спека така, що аж бруківка пашить - одягайтеся максимально легко, тримайтеся тіні й пийте побільше води',
    ),

    AdviceEntry(
      category: AdviceCategory.cloudy,
      max: -15,
      text:
      'небо сіре й лютий мороз - ховайтеся в найтепліший пуховик і рятуйтеся гарячою кавою з кардамоном у затишній кнайпі',
    ),
    AdviceEntry(
      category: AdviceCategory.cloudy,
      min: -15,
      max: -5,
      text:
      'класична похмура зима, без теплої шапки та рукавиць нікуди - найкращий час на запашну каву й свіжий андрут',
    ),
    AdviceEntry(
      category: AdviceCategory.cloudy,
      min: -5,
      max: 0,
      text:
      'небо затягнуло хмарами, а мороз відчувається сиріше - вбирайте теплу куртку та взуття, що не ковзає на бруківці',
    ),
    AdviceEntry(
      category: AdviceCategory.cloudy,
      min: 0,
      max: 5,
      text:
      'типова львівська сірість, коли хочеться затишку - накидайте пальто чи куртку й забігайте на горнятко гарячого какао',
    ),
    AdviceEntry(
      category: AdviceCategory.cloudy,
      min: 5,
      max: 15,
      text:
      'хмари трохи прикрили сонце, але для шпацеру погода файна - улюблений тренч та теплий светр будуть ідеальними',
    ),
    AdviceEntry(
      category: AdviceCategory.cloudy,
      min: 15,
      max: 20,
      text:
      'м’яка, трохи задумлива погода без спеки - накидайте легку сорочку чи піджак і гайда блукати старими двориками',
    ),
    AdviceEntry(
      category: AdviceCategory.cloudy,
      min: 20,
      max: 25,
      text:
      'сонце сховалося, та на вулиці дуже комфортно - ідеальний час для футболки й довгих теревенів в парку',
    ),
    AdviceEntry(
      category: AdviceCategory.cloudy,
      min: 25,
      max: 30,
      text:
      'хмари не рятують від тепла, у повітрі трохи парко - обирайте легкий одяг із льону чи бавовни та освіжаючий лимонад',
    ),
    AdviceEntry(
      category: AdviceCategory.cloudy,
      min: 30,
      text:
      'душна передгрозова спека, коли місто завмерло в очікуванні свіжості — одягайтеся максимально легко й пийте більше води',
    ),

    AdviceEntry(
      category: AdviceCategory.snow,
      max: -15,
      text:
      'сніг рипить під ногами, а мороз тріщить - закутуйтеся в найтепліший пуховик і біжіть грітися гарячим глінтвейном на Ринку',
    ),
    AdviceEntry(
      category: AdviceCategory.snow,
      min: -15,
      max: -5,
      text:
      'справжня різдвяна казка над львівськими дахами - вбирайте теплу шапку, рукавиці та гайда на шпацер із горнятком пряного глінтвейну',
    ),
    AdviceEntry(
      category: AdviceCategory.snow,
      min: -5,
      max: 0,
      text:
      'лапатий сніг повільно вкриває бруківку - ідеальна пора для затишної куртки, вечірніх вогників і келиха теплого глінтвейну',
    ),
    AdviceEntry(
      category: AdviceCategory.snow,
      min: 0,
      max: 5,
      text:
      'мокрий сніг із дощем та сльота під ногами - взувайтеся так, щоб не промокнути, а настрій рятуйте теплим глінтвейном у затишній кнайпі',
    ),
    
    AdviceEntry(
      category: AdviceCategory.rain,
      min: 0,
      max: 5,
      text:
      'крижаний львівський дощ і мокра бруківка - тепло закутайтеся, беріть парасольку й біжіть грітися гарячим чаєм із прянощами',
    ),
    AdviceEntry(
      category: AdviceCategory.rain,
      min: 5,
      max: 15,
      text:
      'місто затягнуло романтичною мрякою - улюблений плащ, парасолька та велике горнятко чаю з цитриною зроблять цей день затишним',
    ),
    AdviceEntry(
      category: AdviceCategory.rain,
      min: 15,
      max: 20,
      text:
      'теплий дощ вистукує по підвіконнях - накидайте легкий тренч, ховайтеся під дашок кав’ярні й замовляйте запашний чай із прянощами',
    ),
    AdviceEntry(
      category: AdviceCategory.rain,
      min: 20,
      max: 25,
      text:
      'літній дощик освіжив розігріту бруківку - вдягайте легку сорочку та беріть парасольку на випадок зливи',
    ),
    AdviceEntry(
      category: AdviceCategory.rain,
      min: 25,
      max: 30,
      text:
      'тропічна львівська злива посеред спеки - одягайтеся максимально легко, не забудьте парасольку, а після дощу можна й на айс-лате',
    ),
    AdviceEntry(
      category: AdviceCategory.rain,
      min: 30,
      text:
      'рятівний літній дощ прибив спеку, та в повітрі ще парко - легкий одяг, парасолька під рукою й затишна тераса з улюбленою кавою',
    ),
  ];
}