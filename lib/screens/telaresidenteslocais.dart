import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Residente {
  int id;
  String name;
  String status;
  String species;
  String image;
  String gender;

  Residente(
      {required this.id,
      required this.name,
      required this.status,
      required this.species,
      required this.image,
      required this.gender});
}

class ResidentesLocal extends StatefulWidget {
  final dynamic local;
  ResidentesLocal(this.local);

  @override
  State<ResidentesLocal> createState() => _ResidentesLocal();
}

class _ResidentesLocal extends State<ResidentesLocal> {
  List<Residente> listaResidentes = [];

  Future<void> carregarResidentes() async {
    for (var residenteUrl in widget.local.residents) {
      final response = await http.Client().get(Uri.parse(residenteUrl));
      if (response.statusCode == 200) {
        var dadosResidentes = json.decode(response.body);
        Residente r = Residente(
            id: dadosResidentes['id'],
            name: dadosResidentes['name'],
            status: dadosResidentes['status'],
            species: dadosResidentes['species'],
            image: dadosResidentes['image'],
            gender: dadosResidentes['gender']);
        setState(() {
          listaResidentes.add(r);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    carregarResidentes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Residentes de ${widget.local.name}"),
      ),
      body: FutureBuilder(
        future:
            Future.wait(listaResidentes.map((r) => Future.value(r)).toList()),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: listaResidentes.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(listaResidentes[index].image),
                ),
                title:
                    Text("Nome do residente: ${listaResidentes[index].name}"),
                subtitle: Text(
                    "Status do residente: ${listaResidentes[index].status}\nEspécie do residente: ${listaResidentes[index].species}\nGênero do residente: ${listaResidentes[index].gender}"),
              );
            },
          );
        },
      ),
    );
  }
}
