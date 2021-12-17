class CurrencyList {
  final String name;
  final String detail;

  CurrencyList({
    required this.name,
    required this.detail,
  });

  factory CurrencyList.fromJson(Map<String, dynamic> json) {

    return CurrencyList(
      name: json['key'],
      detail: json['value'],
    );


  }

  getKey(Map<String, dynamic> json){
    for (final name in json.keys) {
      final value = json[name];
      return value;
    }
  }

  getName(Map<String, dynamic> json){
    for (final name in json.keys) {
      return name;
    }
  }
}