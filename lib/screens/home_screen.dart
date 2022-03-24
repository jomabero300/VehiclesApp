import 'package:flutter/material.dart';
import 'package:vehicles_app/models/token.dart';
import 'package:vehicles_app/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  final Token token;

  HomeScreen({required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle'),
      ),
      body: _getBody(),
      drawer: _gtMechanicMenu(),
    );
  }

  Widget _getBody() {
    return Container(
      margin: const EdgeInsets.all(30),
      child: Center(
        child: Text(
          'Bienvenid@ ${widget.token.user.fullName}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _gtMechanicMenu() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              child: const Image(
            image: AssetImage('assets/vehicles_logo.png'),
          )),
          ListTile(
            leading: const Icon(Icons.two_wheeler),
            title: const Text('Marcas'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.precision_manufacturing),
            title: const Text('Procedimientos'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.badge),
            title: const Text('Tipos de documentos'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.toys),
            title: const Text('Tipos de vehiculos'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Usuarios'),
            onTap: () {},
          ),
          const Divider(
            color: Colors.black,
            height: 2,
          ),
          ListTile(
            leading: const Icon(Icons.face),
            title: const Text('Editar perfil'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}
