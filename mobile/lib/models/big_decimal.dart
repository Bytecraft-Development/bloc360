class BigDecimal {
  final String value;

  BigDecimal(this.value);

  factory BigDecimal.fromJson(dynamic json) {
    return BigDecimal(json.toString());
  }

  @override
  String toString() {
    return value;
  }
}