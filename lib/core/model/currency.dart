class Currency {
  String? _currency;

  Currency(this._currency);

  Currency.map(dynamic obj) {
    _currency = obj['currency'];
  }

  String? get currency => _currency;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["currency"] = _currency;
    return map;
  }

  Currency.fromMap(Map<String, dynamic> map) {
    _currency = map["currency"];
  }
}