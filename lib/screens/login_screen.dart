import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '';
  String _emailError = '';
  bool _emailShowError = false;

  String _password = '';
  String _passwordError = '';
  bool _passwordShowError = false;

  bool _rememberme = true;
  bool _passwordShow = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _showLogo(),
            const SizedBox(
              height: 20,
            ),
            _showEmail(),
            _showPassword(),
            _showRememberme(),
            _showButtons(),
          ],
        ),
      ),
    );
  }

  Widget _showLogo() {
    return const Image(
      image: AssetImage('assets/vehicles_logo.png'),
      width: 300,
    );
  }

  Widget _showEmail() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: TextField(
        autofocus: true,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Ingresa tu email..',
          labelText: 'Email',
          errorText: _emailShowError ? _emailError : null,
          prefixIcon: const Icon(Icons.email),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
        onChanged: (value) {
          _email = value;
        },
      ),
    );
  }

  Widget _showPassword() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: TextField(
        obscureText: !_passwordShow,
        decoration: InputDecoration(
          hintText: 'Ingresa tu contraseña..',
          labelText: 'Contraseña',
          errorText: _passwordShowError ? _passwordError : null,
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
              icon: _passwordShow
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _passwordShow = !_passwordShow;
                });
              }),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
        onChanged: (value) {
          _password = value;
        },
      ),
    );
  }

  Widget _showRememberme() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: CheckboxListTile(
        title: const Text('Recordarme?'),
        value: _rememberme,
        onChanged: (bool? value) {
          setState(() {
            _rememberme = value!;
          });
        },
      ),
    );
  }

  Widget _showButtons() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceAround, //Distribuye los espacios entre los dos botone
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: const Text('Iniciar sesión'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    return const Color(
                        0xFF120E43); // Use the component's default.
                  },
                ),
              ),
              onPressed: () => _login(),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: ElevatedButton(
              child: const Text('Crear nuevo usuario'),
              style: ElevatedButton.styleFrom(primary: const Color(0xFFE03B8B)),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  void _login() async {
    setState(() {
      _passwordShow = false;
    });

    if (!_validatefields()) {
      return;
    }

    Map<String, dynamic> request = {
      'userName': _email,
      'password': _password,
    };

    var url = Uri.parse('${Constans.apiUrl}/api/Account/CreateToken');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );

    print('Rspueesta : ${response.body}');
  }

  bool _validatefields() {
    bool _hasErrors = true;
    if (_emailError.isEmpty) {
      _hasErrors = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar un email';
    } else if (!EmailValidator.validate(_email)) {
      _hasErrors = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar un email valido';
    } else {
      _emailShowError = false;
    }

    if (_password.isEmpty) {
      _hasErrors = false;
      _passwordShowError = true;
      _passwordError = "Debes ingresar una contraseña";
    } else if (_password.length < 6) {
      _hasErrors = false;
      _passwordShowError = true;
      _passwordError = "Debes ingresar una contraseña de al menos 6 carácteres";
    } else {
      _passwordShowError = false;
    }

    setState(() {});
    return _hasErrors;
  }
}
