mixin DatabaseCardKeys {
  final String cardTableName = 'cards';
  final String idKey = 'id';
  final String relatedCarIdKey = 'carId';
  final String priceKey = 'price';
  final String litersKey = 'liters';
  final String dateKey = 'date';
  final String locationKey = 'location';
  final String euroPerLiterKey = 'euroPerLiter';
}

mixin DatabaseUserKeys {
  final String userTableName = 'users';
  final String userIdKey = 'id';
  final String userNameKey = 'name';
  final String userSurnameKey = 'surname';
  final String userUsernameKey = 'username';
}

mixin DatabaseCarKeys {
  final String carTableName = 'cars';
  final String carIdKey = 'id';
  final String carUserIdKey = 'userId'; // foreign key
  final String carBrandKey = 'brand';
  final String carModelKey = 'model';
  final String carYearKey = 'year';
  final String carConsumptionKey = 'fuelConsumption';
}
