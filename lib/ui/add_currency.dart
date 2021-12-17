import 'dart:convert';

import 'package:assess/core/model/currency.dart' as curr;
import 'package:assess/core/services/database.dart';
import 'package:assess/core/services/endpoint.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddCurrencyPage extends StatefulWidget {
  const AddCurrencyPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddCurrencyPage> createState() => _CurrencyConvertPageState();
}

class _CurrencyConvertPageState extends State<AddCurrencyPage> {
  Currency cur = Currency();
  List<dynamic> currencies = <dynamic>[];
  String currency = 'EUR';
  var db = new DataBaseHelper();

  @override
  void initState() {
    _loadCurrencies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: const Text(
          "Add Currency",
          style: TextStyle(color: Colors.blueGrey),
        ),
        backgroundColor: Colors.white70,
      ),
      body: addBody(),
    );
  }

  Widget addBody() {
    return Center(
      child: SizedBox(
        height: 400,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 3.0,
            shadowColor: Colors.white70,
            color: Colors.white70,
            child: currencies.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildDropDownButton(currency),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      //   child:
                      // ),
                      ElevatedButton(
                        onPressed: () {
                          addCurrency();
                        },
                        child: const Text('Add new currency'),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  addCurrency() async {
    await db.saveUser(curr.Currency(currency));
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

  _onChanged(String value) {
    setState(() {
      currency = value;
    });
  }

  Widget _buildDropDownButton(String currencyCategory) {
    return DropdownButton(
      value: currencyCategory,
      items: currencies
          .map((dynamic value) => DropdownMenuItem(
                value: value,
                child: Row(
                  children: <Widget>[
                    Text(value.toString()),
                  ],
                ),
              ))
          .toList(),
      onChanged: (value) {
        print(value);
        _onChanged(value.toString());
      },
    );
  }
}
