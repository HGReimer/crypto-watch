import 'package:flutter_test/flutter_test.dart';

import 'package:easy_crypto_watch/main.dart';

void main() {
  testWidgets('EasyCryptoWatch startet korrekt', (tester) async {
    await tester.pumpWidget(const EasyCryptoWatchApp());

    expect(find.text('EasyCryptoWatch'), findsOneWidget);
    expect(find.text('BTC / USD'), findsOneWidget);
    expect(find.text('— \$'), findsOneWidget);
  });
}
