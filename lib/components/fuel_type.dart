enum FuelType { diesel, gasoline, gas }

String fuelTypeToString(FuelType fuelType) {
  return fuelType.toString().split('.').last;
}

FuelType stringToFuelType(String fuelTypeString) {
  switch (fuelTypeString) {
    case 'diesel':
      return FuelType.diesel;
    case 'gasoline':
      return FuelType.gasoline;
    case 'gas':
      return FuelType.gas;
    // case 'electricity':
    //   return FuelType.electricity;
    default:
      throw Exception('Invalid FuelType');
  }
}
