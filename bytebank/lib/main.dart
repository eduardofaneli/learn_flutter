// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(ByteBankApp());

class ByteBankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListaTransferencia(),
      ),
    );
  }
}

class FormularioTransferencia extends StatelessWidget {
  final TextEditingController _controladorCampoNumeroConta =
      TextEditingController();
  final TextEditingController _controladorCampoValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Criando Transferência")),
      body: Column(
        children: <Widget>[
          Editor(
              controller: _controladorCampoNumeroConta,
              rotulo: "Número da Conta",
              dica: "000"),
          Editor(
              controller: _controladorCampoValor,
              rotulo: "Valor",
              dica: "000.00",
              icone: Icons.monetization_on),
          RaisedButton(
            child: Text("Confirmar"),
            onPressed: () => _criaTransferencia(context),
          ),
        ],
      ),
    );
  }

  void _criaTransferencia(BuildContext context) {
    if (double.tryParse(_controladorCampoValor.text) != null &&
        int.tryParse(_controladorCampoNumeroConta.text) != null) {
      final novaTransferencia = Transferencia(
          double.tryParse(_controladorCampoValor.text),
          int.tryParse(_controladorCampoNumeroConta.text));

      Navigator.pop(context, novaTransferencia);
    }
  }
}

class Editor extends StatelessWidget {
  final TextEditingController controller;
  final String rotulo;
  final String dica;
  final IconData icone;

  const Editor({this.controller, this.rotulo, this.dica, this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: TextStyle(
          fontSize: 24.0,
        ),
        decoration: InputDecoration(
          icon: icone != null ? Icon(icone) : null,
          labelText: rotulo,
          hintText: dica,
        ),
      ),
    );
  }
}

class ListaTransferencia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transferências"),
      ),
      body: Column(
        children: <Widget>[
          ItemTransferencia(
            Transferencia(52.5, 2000),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          final Future<Transferencia> future = Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      FormularioTransferencia()));
          future.then((transferenciaRecebida) {            
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('$transferenciaRecebida'),
            ));
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
        ),
      ),
    );
  }
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;

  const ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text(_transferencia.valor.toString()),
        subtitle: Text(_transferencia.numeroConta.toString()),
      ),
    );
  }
}

class Transferencia {
  final double valor;
  final int numeroConta;

  Transferencia(this.valor, this.numeroConta);

  @override
  String toString() {
    return 'Transferencia{valor: $valor, numeroConta: $numeroConta';
  }
}
