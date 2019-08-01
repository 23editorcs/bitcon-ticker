import 'package:http/http.dart' as http;
import 'dart:convert';

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
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const bitcoinAverageAPI =
    'https://apiv2.bitcoinaverage.com/indices/global/ticker/';

class CoinData {
  Future getCoinData(String fiatName) async {
    Map<String, String> coinPrices = {};
    for (String coin in cryptoList) {
      String requestedURL = '$bitcoinAverageAPI$coin$fiatName';
      http.Response response = await http.get(requestedURL);

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double lastPrice = decodedData['last'];
        coinPrices[coin] = lastPrice.toStringAsFixed(2);
      } else {
        print(response.statusCode);
      }
    }
    return coinPrices;
  }
}
