import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/design/themes.dart';
import 'package:gas_io/design/styles.dart';
import 'package:gas_io/components/user_schema.dart';

class NameSurnamePage extends StatelessWidget {
  NameSurnamePage({super.key});
  final _formKeyInitUser = GlobalKey<FormBuilderState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> saveUserData() async {
    UserData? user = await _databaseHelper.getUser();
    if (user != null) {
      user.name = _nameController.text;
      user.surname = _surnameController.text;
      user.username = _usernameController.text;
      user.email = _emailController.text;
      await _databaseHelper.updateUser(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: FormBuilder(
            key: _formKeyInitUser,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'How should we call you?',
                  style: onbordingTitleStyle,
                ),
                const SizedBox(
                  height: 80,
                ),
                FormBuilderTextField(
                  controller: _nameController,
                  name: 'name',
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: UnderlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(),
                    ],
                  ),
                  onSaved: (_) => _nameController.text,
                ),
                FormBuilderTextField(
                  controller: _surnameController,
                  name: 'surname',
                  decoration: const InputDecoration(
                    labelText: 'Surname',
                    border: UnderlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose(
                    [
                      //FormBuilderValidators.required(),
                    ],
                  ),
                  onSaved: (_) => _surnameController.text,
                ),
                FormBuilderTextField(
                  controller: _usernameController,
                  name: 'username',
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: UnderlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose(
                    [
                      //FormBuilderValidators.required(),
                    ],
                  ),
                  onSaved: (_) => _usernameController.text,
                ),
                FormBuilderTextField(
                  controller: _emailController,
                  name: 'email',
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: UnderlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose(
                    [
                      //FormBuilderValidators.required(),
                    ],
                  ),
                  onSaved: (_) => _emailController.text,
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKeyInitUser.currentState!.saveAndValidate()) {
                      saveUserData();
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
