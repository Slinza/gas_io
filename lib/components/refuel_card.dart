class DatabaseKeys {
  final String idKey = 'id';
  final String priceKey = 'price';
  final String litersKey = 'liters';
  final String dateKey = 'date';
  final String locationKey = 'location';
  final String euroPerLiterKey = 'euroPerLiter';
}

class CardData extends DatabaseKeys {
  final int id;
  final double price;
  final double liters;
  final String date;
  final String location;
  final double euroPerLiter;

  CardData({
    required this.id,
    required this.price,
    required this.liters,
    required this.date,
    required this.location,
    required this.euroPerLiter,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'price': price,
      'liters': liters,
      'date': date,
      'location': location,
      'euroPerLiter': euroPerLiter,
    };
  }

  factory CardData.fromMap(Map<String, dynamic> map) {
    return CardData(
      id: map['id'],
      price: map['price'],
      liters: map['liters'],
      date: map['date'],
      location: map['location'],
      euroPerLiter: map['euroPerLiter'],
    );
  }
}
