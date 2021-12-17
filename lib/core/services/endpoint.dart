import 'dart:convert';

import 'package:assess/core/model/currencyList.dart';
import 'package:http/http.dart' as http;

class Currency {
  Future<List<dynamic>> loadCurrencies() async {
    List<dynamic> currencies = <dynamic>[];
    String uri =
        "https://openexchangerates.org/api/currencies.json?prettyprint=false&show_alternative=false&show_inactive=false&app_id=6cf604936c894ce3a91bc334e938ef8f";
    var response = await http.get(Uri.parse(uri));
    var decodeBody = json.decode(response.body);
    Map<String, dynamic> listCurrency = decodeBody;
    for (var e in listCurrency.entries) {
      currencies.add(CurrencyList(
          name: e.key, detail: e.value));
    }
    return currencies;
  }

  Future<String> doConversion(String toCurrency, double amount) async {
    String uri =
        "https://openexchangerates.org/api/latest.json?app_id=6cf604936c894ce3a91bc334e938ef8f&symbols=$toCurrency&prettyprint=false&show_alternative=false";
    var response =
        await http.get(Uri.parse(uri), headers: {"Accept": "application/json"});
    var responseBody = json.decode(response.body);
    double result = 0;
    if (amount > 200) {
      result = amount * (responseBody["rates"][toCurrency]) +
          (amount * (responseBody["rates"][toCurrency])) * 0.04;
    } else {
      result = amount * (responseBody["rates"][toCurrency]) +
          (amount * (responseBody["rates"][toCurrency])) * 0.07;
    }
    print(result.toString());
    return result.toString();
  }

  Future<List<dynamic>> loadLatestCurrencies() async {
    List<dynamic> currencies = <dynamic>[];
    String uri =
        "https://openexchangerates.org/api/latest.json?app_id=6cf604936c894ce3a91bc334e938ef8f&prettyprint=false&show_alternative=false";
    var response = await http.get(Uri.parse(uri));
    var decodeBody = json.decode(response.body);
    Map<String, dynamic> listCurrency = decodeBody['rates'];
    for (var e in listCurrency.entries) {
      currencies.add(CurrencyList(
          name: e.key, detail: e.value.toStringAsFixed(2).toString()));
    }
    return currencies;
  }
}
