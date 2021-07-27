import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn);

  final void Function(
    String email,
    String password,
    String userName,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = "";

  String _userPassword = "";

  String _userName = "";

  var _isLogin = true;

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(_userEmail.trim(), _userPassword.trim(), _userName.trim(), _isLogin, context);

      // Use those values to send our auth request ...
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    key: Key("email"),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains("@")) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: "Email"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: Key("username"),
                      validator: (value) {
                        if (value!.length < 4) {
                          return "Please enter at least 4 characters";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value!;
                      },
                      decoration: InputDecoration(labelText: "User name"),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    key: Key("password"),
                    validator: (value) {
                      if (value!.length < 6) {
                        return "Please enter at least 6 characters";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: " Password",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    child: Text(_isLogin ? "Login" : "signUp"),
                    onPressed: _trySubmit,
                  ),
                  MaterialButton(
                      child: Text(_isLogin
                          ? "Create an account"
                          : "I already have an account"),
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
