import 'package:intl/intl.dart';

final _money = NumberFormat.decimalPattern('ru');

String kzt(num value) => '₸${_money.format(value.round())}';

String compactKzt(num value) {
  final amount = value.round();
  if (amount >= 1000000) {
    final millions = amount / 1000000;
    final label = millions >= 10
        ? millions.round().toString()
        : millions.toStringAsFixed(1).replaceAll('.', ',');
    return '₸$label млн';
  }
  if (amount >= 1000) {
    return '₸${(amount / 1000).round()} тыс';
  }
  return kzt(amount);
}

String percent(double value) => '${(value * 100).round()}%';
