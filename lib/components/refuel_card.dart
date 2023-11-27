class CardData {
  final double price;
  final double liters;
  final String date;
  final String location;
  final double euroPerLiter;

  CardData({
    required this.price,
    required this.liters,
    required this.date,
    required this.location,
    required this.euroPerLiter,
  });

  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'liters': liters,
      'date': date,
      'location': location,
      'euroPerLiter': euroPerLiter,
    };
  }

  factory CardData.fromMap(Map<String, dynamic> map) {
    return CardData(
      price: map['price'],
      liters: map['liters'],
      date: map['date'],
      location: map['location'],
      euroPerLiter: map['euroPerLiter'],
    );
  }
}
