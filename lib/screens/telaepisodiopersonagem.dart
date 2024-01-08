// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Episodio {
  final int id;
  final String name;
  final String airDate;
  final String episode;

  Episodio(
      {required this.id,
      required this.name,
      required this.airDate,
      required this.episode});
}

class PersonagensDetalhes extends StatefulWidget {
  final dynamic personagem;
  PersonagensDetalhes(this.personagem);

  @override
  State<PersonagensDetalhes> createState() => _PersonagensDetalhesState();
}

class _PersonagensDetalhesState extends State<PersonagensDetalhes> {
  List<Episodio> listaEpisodios = [];

  Future<void> carregarEpisodios() async {
    for (var episodioUrl in widget.personagem.episodio) {
      final response = await http.Client().get(Uri.parse(episodioUrl));
      if (response.statusCode == 200) {
        var dadosEpisodio = json.decode(response.body);
        Episodio episodio = Episodio(
            id: dadosEpisodio['id'],
            name: dadosEpisodio['name'],
            airDate: dadosEpisodio['air_date'],
            episode: dadosEpisodio['episode']);
        setState(() {
          listaEpisodios.add(episodio);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    carregarEpisodios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Episódios em que ${widget.personagem.name} aparece"),
      ),
      body: FutureBuilder(
        future: Future.wait(
            listaEpisodios.map((episodio) => Future.value(episodio)).toList()),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: listaEpisodios.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("Nome do episódio: ${listaEpisodios[index].name}"),
                subtitle: Text(
                    "Data de lançamento: ${listaEpisodios[index].airDate}\nEpisódio: ${listaEpisodios[index].episode}"),
              );
            },
          );
        },
      ),
    );
  }
}
