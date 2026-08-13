import 'dart:convert';

import 'package:http/http.dart' as http;

class CryptoService {
  Future<double> fetchBitcoinUsdPrice() async {
    final uri = Uri.parse('https://api.kraken.com/0/public/Ticker?pair=XBTUSD');

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Kursdaten konnten nicht geladen werden.');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final result = data['result'] as Map<String, dynamic>;

    final ticker = result.values.first as Map<String, dynamic>;
    final close = ticker['c'] as List<dynamic>;

    return double.parse(close.first as String);
  }
}
