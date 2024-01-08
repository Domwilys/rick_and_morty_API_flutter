import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rick_and_morty_api/model/locais.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_api/screens/telaresidenteslocais.dart';
import 'telaepisodiopersonagem.dart';

class Locais extends StatefulWidget {
  @override
  State<Locais> createState() => _LocaisState();
}

class _LocaisState extends State<Locais> {
  ScrollController controllerScroll = ScrollController();
  int pagAtual = 1;
  List<Local> listaLocais = [];

  Future<List> pageData() async {
    final response = await http.Client().get(
        Uri.parse("https://rickandmortyapi.com/api/location?page=$pagAtual"));
    if (response.statusCode == 200) {
      var dadosLocais = json.decode(response.body);
      List locais = dadosLocais['results'];
      Map info = dadosLocais['info'] as Map;
      if (info['next'] != null) {
        locais.forEach((local) {
          final List<dynamic> residentes = local['residents'];
          Local l = Local(
              id: local['id'],
              name: local['name'],
              type: local['type'],
              dimension: local["dimension"],
              residents: List<String>.from(
                  residentes.map((resident) => resident.toString())));
          listaLocais.add(l);
        });
        pagAtual++;
      }
      return listaLocais;
    } else {
      throw Exception("Não foi possível carregar os dados das Localizações");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool updated = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Locais"),
      ),
      body: FutureBuilder(
        initialData: [],
        future: pageData(),
        builder: (context, snapshot) {
          List locais = snapshot.data as List;
          return ListView.builder(
            controller: controllerScroll
              ..addListener(() {
                if (controllerScroll.position.pixels ==
                        controllerScroll.position.maxScrollExtent &&
                    updated == false) {
                  updated == true;
                  setState(() {});
                }
              }),
            itemCount: locais.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("Nome: ${locais[index].name}"),
                subtitle: Text(
                    "Tipo: ${locais[index].type} \n Dimenção: ${locais[index].dimension}"),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ResidentesLocal(locais[index]);
                      },
                    ));
                  },
                  icon: const Icon(Icons.remove_red_eye),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
