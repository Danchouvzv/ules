import 'package:intl/intl.dart';

final _money = NumberFormat.decimalPattern('ru');

String kzt(num value) => '₸${_money.format(value.round())}';

String percent(double value) => '${(value * 100).round()}%';
