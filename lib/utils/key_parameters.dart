mixin DatabaseCardKeys {
  final String cardTableName = 'cards';
  final String idKey = 'id';
  final String relatedCarIdKey = 'carId';
  final String priceKey = 'price';
  final String litersKey = 'liters';
  final String dateKey = 'date';
  final String gasStatIdKey = 'gasStationId';  // foreign key
  final String euroPerLiterKey = 'euroPerLiter';
  final String kmKey = 'km';
  final String isCompleteRefuelKey = "isCompleteRefuel";
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
  final String carInitialKmKey = 'initialKm';
  final String carFuelType = 'fuelType';
}

mixin DatabaseGasStationKeys {
  final String gasStationTableName = 'gasStations';
  final String gasStationIdKey = 'id';
  final String gasStationLatitudeKey = 'latitude';
  final String gasStationLongitudeKey = 'longitude';
  final String gasStationNameKey = 'name';
  final String gasStationFormattedAddressKey = 'formattedAddress';
  final String gasStationShortFormattedAddressKey = 'shortFormattedAddress';
}
