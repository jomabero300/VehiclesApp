import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:vehicles_app/components/loader_component.dart';
import 'package:vehicles_app/helpers/api_helper.dart';
import 'package:vehicles_app/models/Procedure.dart';
import 'package:vehicles_app/models/response.dart';
import 'package:vehicles_app/models/token.dart';

class ProcedureScreen extends StatefulWidget {
  final Token token;
  final Procedure procedure;

  ProcedureScreen({required this.token, required this.procedure});

  @override
  State<ProcedureScreen> createState() => _ProcedureScreenState();
}

class _ProcedureScreenState extends State<ProcedureScreen> {
  bool _showLoader = false;

  String _description = '';
  String _descriptionError = '';
  bool _descriptionShowError = false;
  TextEditingController _descriptionController = TextEditingController();

  String _price = '';
  String _priceError = '';
  bool _priceShowError = false;
  TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _description = widget.procedure.description;
    _descriptionController.text = _description;
    _price = widget.procedure.price.toString();
    _priceController.text = _price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.procedure.id == 0
            ? 'Nuevo procedimiento'
            : widget.procedure.description),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[_showDesription(), _showPrice(), _showButtons()],
          ),
          _showLoader
              ? LoaderComponent(
                  text: 'Por favor espere..',
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _showDesription() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        autofocus: true,
        controller: _descriptionController,
        decoration: InputDecoration(
          hintText: 'Ingresa una descripción..',
          labelText: 'Descripción',
          errorText: _descriptionShowError ? _descriptionError : null,
          prefixIcon: const Icon(Icons.description),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
        onChanged: (value) {
          _description = value;
        },
      ),
    );
  }

  Widget _showPrice() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true, signed: false),
        controller: _priceController,
        decoration: InputDecoration(
          hintText: 'Ingresa un precio..',
          labelText: 'Precio',
          errorText: _priceShowError ? _priceError : null,
          prefixIcon: const Icon(Icons.attach_money),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
        onChanged: (value) {
          _price = value;
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
              child: const Text('Guardar'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    return const Color(
                        0xFF120E43); // Use the component's default.
                  },
                ),
              ),
              onPressed: () => _save(),
            ),
          ),
          widget.procedure.id == 0
              ? Container()
              : const SizedBox(
                  width: 20,
                ),
          widget.procedure.id == 0
              ? Container()
              : Expanded(
                  child: ElevatedButton(
                    child: const Text('Borrar'),
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xFFB4161B)),
                    onPressed: () => _confirmDelete(),
                  ),
                ),
        ],
      ),
    );
  }

  void _save() {
    if (!_validatefields()) {
      return;
    }

    widget.procedure.id == 0 ? _addRecord() : _updateRecord();
  }

  bool _validatefields() {
    bool _isValid = true;

    if (_description.isEmpty) {
      _isValid = false;
      _descriptionShowError = true;
      _descriptionError = 'Debes ingresar una descripción';
    } else {
      _descriptionShowError = false;
    }

    if (_price.isEmpty) {
      _isValid = false;
      _priceShowError = true;
      _priceError = "Debes ingresar una precio";
    } else {
      double price = double.parse(_price);
      if (price <= 0) {
        _isValid = false;
        _priceShowError = true;
        _priceError = "Debes ingresar un precio mayor a cero.";
      } else {
        _priceShowError = false;
      }
    }

    setState(() {});
    return _isValid;
  }

  _addRecord() async {
    setState(() {
      _showLoader = true;
    });

    Map<String, dynamic> request = {
      'description': _description,
      'price': double.parse(_price),
    };

    Response response =
        await ApiHelper.post('/api/Procedures/', request, widget.token.token);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Navigator.pop(context, 'yes');
  }

  _updateRecord() async {
    setState(() {
      _showLoader = true;
    });

    Map<String, dynamic> request = {
      'id': widget.procedure.id,
      'description': _description,
      'price': double.parse(_price),
    };

    Response response = await ApiHelper.put('/api/Procedures/',
        widget.procedure.id.toString(), request, widget.token.token);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Navigator.pop(context, 'yes');
  }

  void _confirmDelete() async {
    var response = await showAlertDialog(
        context: context,
        title: 'Confirmación',
        message: '¿Estas seguro de querer borrar el registro?',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: 'no', label: 'No'),
          const AlertDialogAction(key: 'yes', label: 'Sí'),
        ]);

    if (response == 'yes') {
      _deleteRecord();
    }
  }

  void _deleteRecord() async {
    setState(() {
      _showLoader = true;
    });

    Response response = await ApiHelper.delete(
        '/api/Procedures/', widget.procedure.id.toString(), widget.token.token);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Navigator.pop(context, 'yes');
  }
}
