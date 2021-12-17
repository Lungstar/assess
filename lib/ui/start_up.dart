import 'package:assess/core/services/endpoint.dart';
import 'package:assess/ui/currency_converter.dart';
import 'package:assess/ui/currency_details.dart';
import 'package:flutter/material.dart';

import 'add_currency.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> currencies = <dynamic>[];
  Currency cur = Currency();

  @override
  void initState() {
    getCurrency();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isColor = false;
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 100,
              child: DrawerHeader(
                child: Text('Currencies & Rates'),
              ),
            ),
            ListTile(
              title: const Text('Currency Converter'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CurrencyConvertPage()));
              },
            ),
            ListTile(
              title: const Text('Add Currency'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>  const AddCurrencyPage()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Currency List",
            style: TextStyle(color: Colors.blueGrey)),
        backgroundColor: Colors.white70,
      ),
      body: currencies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              itemCount: currencies.length,
              itemBuilder: (context, index) {
                Color color = Colors.black26;
                if ((index % 2) == 0) {
                  color = Colors.deepPurpleAccent;
                }
                return Card(
                    child: ListTile(
                  leading: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black26,
                      )),
                  title: Text('${currencies[index].name}'),
                  trailing: Text('${currencies[index].detail}'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CurrencyDetailsPage(),
                    ),
                  ),
                ));
              },
            ),
    );
  }

  getCurrency() {
    cur.loadCurrencies().then((value) {
      setState(() {
        currencies = value;
      });
    });
  }
}
