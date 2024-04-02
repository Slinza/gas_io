import 'package:gas_io/utils/key_parameters.dart';

class GasStationData with DatabaseGasStationKeys {
  String id;
  double latitude;
  double longitude;
  String name;
  String formattedAddress;
  String shortFormattedAddress;

  GasStationData({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.formattedAddress,
    required this.shortFormattedAddress,
  });

  Map<String, dynamic> toMap() {
    return {
      gasStationIdKey: id,
      gasStationLatitudeKey: latitude,
      gasStationLongitudeKey: longitude,
      gasStationNameKey: name,
      gasStationFormattedAddressKey: formattedAddress,
      gasStationShortFormattedAddressKey: shortFormattedAddress,
    };
  }

  factory GasStationData.fromMap(Map<String, dynamic> map) {
    return GasStationData(
      id: map["id"],
      latitude: map["latitude"],
      longitude: map["longitude"],
      name: map["name"],
      formattedAddress: map["formattedAddress"],
      shortFormattedAddress: map["shortFormattedAddress"],
    );
  }
}
