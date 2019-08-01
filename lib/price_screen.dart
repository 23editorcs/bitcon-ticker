import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  bool isWaiting;
  Map<String, String> coinPrices = {};

  double priceBTC;
  double priceETH;
  double priceLTC;

  // Create a Drop Down Button for Android
  DropdownButton getAndroidDropDownButton() {
    List<DropdownMenuItem<String>> currencyList = [];

    for (String currency in currenciesList) {
      currencyList.add(
        DropdownMenuItem(child: Text(currency), value: currency),
      );
    }
    return DropdownButton<String>(
              value: selectedCurrency,
              items: currencyList,
              onChanged: (value) async {
                setState(
                  () {
                    selectedCurrency = value;
                    getData();
                  },
                );
              },
            );
  }

  // Create a Cupertino Picker for iOS 
  CupertinoPicker getIOSCupertinoPicker() {
    List<Widget> currencyList = [];

    for (String currency in currenciesList) {
      currencyList.add(Text(currency),);
    }
    return CupertinoPicker(
      children: currencyList, onSelectedItemChanged: (int value) {
        selectedCurrency = currencyList[value].toString();
        getData();
      }, 
      itemExtent: 10.0,
    );
  }



  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(
        () {
          coinPrices = data;
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Column makeCards() {
    List<CryptoCard> cryptoCard = [];

    for (String coin in cryptoList) {
      cryptoCard.add(
        CryptoCard(
          cryptoCoin: coin,
          coinPrice: isWaiting ? '?' : coinPrices[coin],
          selectedCurrency: selectedCurrency,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCard,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getIOSCupertinoPicker() : getAndroidDropDownButton()
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({this.cryptoCoin, this.coinPrice, this.selectedCurrency});

  final String cryptoCoin;
  final String coinPrice;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCoin = $coinPrice $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
