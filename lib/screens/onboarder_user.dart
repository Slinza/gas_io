import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/design/themes.dart';
import 'package:gas_io/design/styles.dart';
import 'package:gas_io/components/user_schema.dart';

class NameSurnamePage extends StatefulWidget {
  final Function(bool) onUserDataValid;

  const NameSurnamePage({super.key, required this.onUserDataValid});

  @override
  _NameSurnamePageState createState() => _NameSurnamePageState();
}

class _NameSurnamePageState extends State<NameSurnamePage> {
  final _formKeyInitUser = GlobalKey<FormBuilderState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  bool _isSaving = false;

  Future<void> saveUserData() async {
    setState(() {
      _isSaving = true;
    });

    UserData user = UserData(
      id: 0,
      name: _nameController.text,
      surname: _surnameController.text,
      username: _usernameController.text,
      email: _emailController.text,
    );
    await _databaseHelper.insertUser(user);

    setState(() {
      _isSaving = false;
    });

    widget.onUserDataValid(true);
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
                  enabled: !_isSaving,
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
                      FormBuilderValidators.required(),
                    ],
                  ),
                  enabled: !_isSaving,
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
                      FormBuilderValidators.required(),
                    ],
                  ),
                  enabled: !_isSaving,
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
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                    ],
                  ),
                  enabled: !_isSaving,
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: _isSaving
                      ? null
                      : () {
                    if (_formKeyInitUser.currentState!.saveAndValidate()) {
                      saveUserData();
                    } else {
                      widget.onUserDataValid(false);
                    }
                  },
                  child: _isSaving
                      ? const CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
