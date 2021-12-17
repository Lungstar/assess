import 'dart:convert';

import 'package:assess/core/model/currencyList.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CurrencyDetailsPage extends StatefulWidget {
  const CurrencyDetailsPage({Key? key,}) : super(key: key);

  @override
  State<CurrencyDetailsPage> createState() => _CurrencyDetailsPageState();
}

class _CurrencyDetailsPageState extends State<CurrencyDetailsPage> {
  List<dynamic> currencies = <dynamic>[];

  @override
  void initState() {
    loadLatestCurrencies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: const Text(
          "Currency Details Against 1 USD",
          style: TextStyle(color: Colors.blueGrey),
        ),
        backgroundColor: Colors.white70,
      ),
      body: currencies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: currencies.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ObjectKey(currencies[index].name),
                  child: Card(
                      child: ListTile(
                    title: Text('${currencies[index].name}'),
                    trailing: Text('${currencies[index].detail}'),
                  )),
                );
              },
            ),
    );
  }

  Future<void> loadLatestCurrencies() async {
    String uri =
        "https://openexchangerates.org/api/latest.json?app_id=6cf604936c894ce3a91bc334e938ef8f&prettyprint=false&show_alternative=false";
    var response = await http.get(Uri.parse(uri));
    var decodeBody = json.decode(response.body);
    Map<String, dynamic> listCurrency = decodeBody['rates'];
    for (var e in listCurrency.entries) {
      currencies.add(CurrencyList(
          name: e.key, detail: e.value.toStringAsFixed(2).toString()));
    }
    setState(() {});
  }
}
