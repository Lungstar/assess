import 'dart:convert';

import 'package:assess/core/services/endpoint.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CurrencyConvertPage extends StatefulWidget {
  const CurrencyConvertPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CurrencyConvertPage> createState() => _CurrencyConvertPageState();
}

class _CurrencyConvertPageState extends State<CurrencyConvertPage> {
  final fromTextController = TextEditingController();
  List<String> currencies = <String>[];
  String fromCurrency = "USD";
  String toCurrency = 'EUR';
  var result;
  Currency cr = Currency();

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: const Text(
          "Currency Converter",
          style: TextStyle(color: Colors.blueGrey),
        ),
        backgroundColor: Colors.white70,
      ),
      body: currencies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SizedBox(
                height: 400,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 3.0,
                    shadowColor: Colors.white70,
                    color: Colors.white70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ListTile(
                          title: TextField(
                            controller: fromTextController,
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black),
                            keyboardType:
                                const TextInputType.numberWithOptions(),
                          ),
                          trailing: _buildDropDownButton(fromCurrency),
                        ),
                        ElevatedButton(
                            onPressed: convertAmount,
                            child: const Text("Convert")),
                        ListTile(
                          title: Text(
                            result ?? "Converted Amount",
                          ),
                          trailing: _buildDropDownButton(toCurrency),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> _loadCurrencies() async {
    String uri =
        "https://openexchangerates.org/api/latest.json?app_id=6cf604936c894ce3a91bc334e938ef8f&prettyprint=false&show_alternative=false";
    var response = await http.get(Uri.parse(uri));
    var decodeBody = json.decode(response.body);
    Map<String, dynamic> listCurrency = decodeBody['rates'];
    currencies = listCurrency.keys.toList();
    setState(() {});
  }

  Future<void> convertAmount() async {
    String uri =
        "https://openexchangerates.org/api/latest.json?app_id=6cf604936c894ce3a91bc334e938ef8f&symbols=$toCurrency&prettyprint=false&show_alternative=false";
    var response = await http.get(Uri.parse(uri));
    var responseBody = json.decode(response.body);
    double amount = 0;
    setState(() {
      if (double.parse(fromTextController.text) > 200) {
        amount = double.parse(fromTextController.text) *
                (responseBody["rates"][toCurrency]) +
            double.parse(fromTextController.text) *
                (responseBody["rates"][toCurrency]) *
                0.04;
      } else {
        amount = double.parse(fromTextController.text) *
                (responseBody["rates"][toCurrency]) +
            double.parse(fromTextController.text) *
                (responseBody["rates"][toCurrency]) *
                0.07;
      }
      result = (amount.toString());
    });
  }

  _onToChanged(String value) {
    setState(() {
      toCurrency = value;
    });
  }

  _onFromChanged(String value) {
    setState(() {
      fromCurrency = value;
    });
  }

  Widget _buildDropDownButton(String currencyCategory) {
    return DropdownButton(
      value: currencyCategory,
      items: currencies
          .map((String value) => DropdownMenuItem(
                value: value,
                child: Row(
                  children: <Widget>[
                    Text(value),
                  ],
                ),
              ))
          .toList(),
      onChanged: (value) {
        if (currencyCategory == fromCurrency) {
          _onFromChanged(value.toString());
        } else {
          _onToChanged(value.toString());
        }
      },
    );
  }
}
