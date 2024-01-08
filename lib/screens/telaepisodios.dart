import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_api/model/episodes.dart';
import './telapersonagensep.dart';

class Episodios extends StatefulWidget {
  @override
  State<Episodios> createState() => _EpisodiosState();
}

class _EpisodiosState extends State<Episodios> {
  ScrollController controllerScroll = ScrollController();
  int pagAtual = 1;
  List<Episodio> listaEpisodios = [];

  Future<List> pageData() async {
    final response = await http.Client().get(
        Uri.parse("https://rickandmortyapi.com/api/episode?page=$pagAtual"));
    if (response.statusCode == 200) {
      var dadosEpisodios = json.decode(response.body);
      List episodios = dadosEpisodios['results'];
      Map info = dadosEpisodios['info'] as Map;
      if (info['next'] != null) {
        episodios.forEach((episodio) {
          final List<dynamic> characters = episodio['characters'];
          Episodio e = Episodio(
              id: episodio['id'],
              name: episodio['name'],
              airDate: episodio['air_date'],
              episode: episodio['episode'],
              characters:
                  List<String>.from(characters.map((c) => c.toString())));
          listaEpisodios.add(e);
        });
        pagAtual++;
      }
      return listaEpisodios;
    } else {
      throw Exception("Não foi possível carregar os dados dos episódios");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool updated = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Episódios"),
      ),
      body: FutureBuilder(
        initialData: [],
        future: pageData(),
        builder: (context, snapshot) {
          List episodios = snapshot.data as List;
          return ListView.builder(
            controller: controllerScroll
              ..addListener(() {
                if (controllerScroll.position.pixels ==
                        controllerScroll.position.maxScrollExtent &&
                    updated == false) {
                  updated = true;
                  setState(() {});
                }
              }),
            itemCount: episodios.length,
            itemBuilder: (context, index) {
              return ListTile(
                trailing: IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return PersonagensAparicao(episodios[index]);
                      },
                    ));
                  },
                  icon: const Icon(Icons.remove_red_eye),
                ),
                title: Text("Nome: ${episodios[index].name}"),
                subtitle: Text(
                    "Episódio: ${episodios[index].episode} \n Data de lançamento: ${episodios[index].airDate}"),
              );
            },
          );
        },
      ),
    );
  }
}
