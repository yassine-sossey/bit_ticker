import 'networking.dart';
import 'package:flutter/material.dart';

String kApiKey = '6CD127B5-0D09-4B78-A6DA-A393BBC3143E';

// class that gather all the logic in fetching currencies rates and storing
class CoinData {
  Map<String, double> btcRatesforgivenCurrencies = {};

  List btcRates = [];

  Future<void> getcurrentRate(BuildContext context,
      {required String crypto}) async {
    //fetch this data
    String url =
        'https://rest.coinapi.io/v1/exchangerate/$crypto?apikey=$kApiKey';
    NetworkingSolider networkingSolider = NetworkingSolider(url);
    await networkingSolider.fetchfromwebsite().then((value) {
      btcRates = value['rates'];
      // After fetching data, let's transform it to a Map of {'USD': rate, 'EUR': rate, ....}
      for (int i = 0; i < btcRates.length; i++) {
        String assetIdBTC = btcRates[i]["asset_id_quote"];
        if (currenciesList.contains(assetIdBTC)) {
          btcRatesforgivenCurrencies[assetIdBTC] = btcRates[i]["rate"];
        }
      }
    }).catchError((error) {
      //show error as a sanckbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
      ));
    });
  }
}

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
