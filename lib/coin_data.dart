import 'package:bit_ticker/constants.dart';

import 'networking.dart';
import 'package:flutter/material.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR',
  'ETH',
  'LTC'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Map<String, dynamic> btcRatesforgivenCurrencies = {};

  List btcRates = [];

  Future<void> getcurrentRate(BuildContext context,
      {required String crypto}) async {
    String url =
        'https://rest.coinapi.io/v1/exchangerate/$crypto?apikey=$kApiKey';
    NetworkingSolider networkingSolider = NetworkingSolider(url);
    await networkingSolider.fetchfromwebsite().then((value) {
      btcRates = value['rates'];
      for (int i = 0; i < btcRates.length; i++) {
        String assetIdBTC = btcRates[i]["asset_id_quote"];
        if (currenciesList.contains(assetIdBTC)) {
          btcRatesforgivenCurrencies[assetIdBTC] = btcRates[i]["rate"];
        }
      }
      debugPrint('Fetching is successful');
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
      ));
    });
  }

  // After fetching data, let's transform it to a Map of {'USD': rate, 'EUR': rate, ....}
  void getRates() {}
}
