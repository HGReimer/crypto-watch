import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const EasyCryptoWatchApp());
}

class EasyCryptoWatchApp extends StatelessWidget {
  const EasyCryptoWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EasyCryptoWatch',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF39FF6A),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF07090A),
      ),
      home: const CryptoHomeScreen(),
    );
  }
}

class CryptoHomeScreen extends StatefulWidget {
  const CryptoHomeScreen({super.key});

  @override
  State<CryptoHomeScreen> createState() => _CryptoHomeScreenState();
}

class _CryptoHomeScreenState extends State<CryptoHomeScreen> {
  double? bitcoinPrice;
  String statusText = 'Warte auf Kursdaten …';

  @override
  void initState() {
    super.initState();
    loadBitcoinPrice();
  }

  Future<void> loadBitcoinPrice() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          bitcoinPrice = (data['bitcoin']['usd'] as num).toDouble();
          statusText = 'BTC-Kurs erfolgreich geladen';
        });
      } else {
        setState(() {
          statusText = 'Fehler beim Laden: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        statusText = 'Keine Kursdaten verfügbar';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EasyCryptoWatch'),
        backgroundColor: const Color(0xFF0D1512),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'BTC / USD',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  bitcoinPrice == null
                      ? '— \$'
                      : '\$${bitcoinPrice!.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF39FF6A),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  statusText,
                  style: TextStyle(color: Colors.grey.shade400),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
