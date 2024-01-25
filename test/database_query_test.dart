import 'package:gas_io/components/refuel_card.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_io/utils/database_helper.dart';

void main() {
  test('Fetch monthly data from DB', () {
    final DatabaseHelper db = DatabaseHelper();

    Future<List<CardData>> cardList = db.getMonthCard(1);
    expect(cardList, cardList);
  });
}
