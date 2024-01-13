import 'package:gas_io/utils/key_parameters.dart';

class UserData with DatabaseUserKeys {
  final int id;
  final String name;
  final String surname;
  final String username;

  UserData({
    required this.id,
    required this.name,
    required this.surname,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return {
      userIdKey: id,
      userNameKey: name,
      userSurnameKey: surname,
      userUsernameKey: username
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'],
      name: map['name'],
      surname: map['surname'],
      username: map['username'],
    );
  }
}
