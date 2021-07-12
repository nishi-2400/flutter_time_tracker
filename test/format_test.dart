import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_time_tracker/app/home/job_entries/format.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  group('hours', () {
    test('positive', () {
      expect(Format.hours(10), '10h');
    });

    test('zero', () {
      expect(Format.hours(0), '0h');
    });

    test('negative', () {
      expect(Format.hours(-5), '0h');
    });

    test('decimal', () {
      expect(Format.hours(2.5), '2.5h');
    });
  });

  group('date with GB locale', () {
    setUp(() async {
      Intl.defaultLocale = 'en_GB';
      await initializeDateFormatting(Intl.defaultLocale);
    });

    test('2019-08-12', () {
      expect(Format.date(DateTime(2019, 8, 12)), '12 Aug 2019');
    });

    test('2019/08/12', () {
      expect(Format.date(DateTime(2019, 8, 12)), '12 Aug 2019');
    });
  });
}