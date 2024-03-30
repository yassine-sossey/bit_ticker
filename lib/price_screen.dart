import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  //current curency choosed in dropDown button by user
  String dropDownvalue = currenciesList.first;

  CoinData coinData = CoinData(); // Create instance of CoinData
  //rates of each crypto format {'EUR': rate, "USD" : rate}
  Map<String, double> btcAllRates = {};
  Map<String, double> ethAllRates = {};
  Map<String, double> ltcAllRates = {};

  @override
  void initState() {
    super.initState();
    //fetch data for once
    getMetadata();
  }

  Future<void> getMetadata() async {
    // Call methods to fetch data
    coinData.getcurrentRate(context, crypto: 'BTC').then((value) {
      setState(() {
        btcAllRates = coinData.btcRatesforgivenCurrencies;
        debugPrint(' rates after handling $btcAllRates');
        getETH(btcAllRates);
        //getLTC(btcAllRates);
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
      ));
    });

    // Update state after data is fetched
  }

  @override
  Widget build(BuildContext context) {
    double? rateBTC = btcAllRates[dropDownvalue];
    rateBTC =
        (rateBTC == null) ? null : double.parse(rateBTC.toStringAsFixed(1));
    double? rateETH = ethAllRates[dropDownvalue];
    rateETH =
        (rateETH == null) ? null : double.parse(rateETH.toStringAsFixed(1));

    return Scaffold(
      appBar: AppBar(
        title: const Text(' Coin Ticker'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $rateBTC $dropDownvalue', // Replace 'rate' with actual rate value
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 ETH = $rateETH $dropDownvalue', // Replace 'rate' with actual rate value
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 ETH = $rateETH $dropDownvalue', // Replace 'rate' with actual rate value
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child:
                Platform.isIOS ? iosCupertinoPicker() : androidDropDownButton(),
          ),
        ],
      ),
    );
  }

  CupertinoPicker iosCupertinoPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 34,
      onSelectedItemChanged: (value) {
        setState(() {
          dropDownvalue = currenciesList[value];
        });
      },
      children: currenciesList.map((e) => Text(e)).toList(),
    );
  }

  void getETH(Map btcrates) {
    for (String element in currenciesList) {
      if (btcrates[element] != null && btcrates['ETH'] != null) {
        ethAllRates[element] = btcrates[element] / btcrates['ETH'];
      }
    }
  }

  void getLTC(Map btcrates) {
    for (String element in currenciesList) {
      if (btcrates[element] != null && btcrates['LTC'] != null) {
        ltcAllRates[element] = btcrates[element] / btcrates['LTC'];
      }
    }
  }

  DropdownButton androidDropDownButton() {
    return DropdownButton(
      value: dropDownvalue,
      items: currenciesList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Center(
            child: Text(
              value,
            ),
          ),
        );
      }).toList(),
      onChanged: (newvalue) {
        setState(() {
          dropDownvalue = newvalue!;
          debugPrint(dropDownvalue);
        });
      },
      isExpanded: true,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      iconSize: 30,
      iconEnabledColor: Colors.white,
    );
  }
}
