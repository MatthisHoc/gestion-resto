import 'package:intl/intl.dart';

class PriceFormat {
  static final NumberFormat _priceFormat = NumberFormat("##0.00", 'fr');
  static String format(dynamic number) {
    return _priceFormat.format(number);
  }
}
