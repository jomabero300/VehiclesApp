import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vehicles_app/components/loader_component.dart';

import 'package:vehicles_app/helpers/constans.dart';
import 'package:vehicles_app/models/Procedure.dart';
import 'package:vehicles_app/models/token.dart';

class ProceduresScreen extends StatefulWidget {
  final Token token;

  ProceduresScreen({required this.token});

  @override
  State<ProceduresScreen> createState() => _ProceduresScreenState();
}

class _ProceduresScreenState extends State<ProceduresScreen> {
  List<Procedure> _procedure = [];
  bool _showLoader = false;

  @override
  void initState() {
    super.initState();
    _getProcedures();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Procedimientos'),
      ),
      body: _showLoader
          ? LoaderComponent(text: 'por favor espere...')
          : const Center(child: Text('Procedimientos..')),
    );
  }

  void _getProcedures() async {
    setState(() {
      _showLoader = true;
    });

    var url = Uri.parse('${Constans.apiUrl}/api/Procedures');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${widget.token.token}',
      },
    );

    setState(() {
      _showLoader = false;
    });

    print(response.body);
  }
}
