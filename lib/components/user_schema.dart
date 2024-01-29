import 'package:gas_io/utils/key_parameters.dart';

class UserData with DatabaseUserKeys {
  int id;
  String name;
  String surname;
  String username;

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
