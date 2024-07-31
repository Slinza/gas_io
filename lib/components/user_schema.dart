import 'package:gas_io/utils/key_parameters.dart';

class UserData with DatabaseUserKeys {
  int id;
  String name;
  String surname;
  String username;
  String email;

  UserData({
    required this.id,
    required this.name,
    required this.surname,
    required this.username,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      userIdKey: id,
      userNameKey: name,
      userSurnameKey: surname,
      userUsernameKey: username,
      userEmailKey: email,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'],
      name: map['name'],
      surname: map['surname'],
      username: map['username'],
      email: map['email'],
    );
  }
}
