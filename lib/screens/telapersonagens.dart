// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/personagem.dart';
import './telaepisodiopersonagem.dart';

class Personagens extends StatefulWidget {
  @override
  State<Personagens> createState() => _PersonagensState();
}

class _PersonagensState extends State<Personagens> {
  ScrollController controllerScroll = ScrollController();
  int pagAtual = 1;
  List<Personagem> listaPersonagem = [];

  Future<List> pageData() async {
    final response = await http.Client().get(
        Uri.parse("https://rickandmortyapi.com/api/character?page=$pagAtual"));
    if (response.statusCode == 200) {
      var dadosPersonagens = json.decode(response.body);
      List personagens = dadosPersonagens['results'];
      Map info = dadosPersonagens['info'] as Map;
      if (info['next'] != null) {
        personagens.forEach((personagem) {
          Map origem = personagem['origin'] as Map;
          final List<dynamic> episodios = personagem['episode'];
          Personagem p = Personagem(
              id: personagem['id'],
              name: personagem['name'],
              status: personagem['status'],
              species: personagem['species'],
              image: personagem['image'],
              gender: personagem['gender'],
              origin: origem['name'],
              episodio: List<String>.from(
                  episodios.map((episode) => episode.toString())));
          listaPersonagem.add(p);
        });
        pagAtual++;
      }
      return listaPersonagem;
    } else {
      throw Exception("Falha ao carregar os dados dos personagens");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool updated = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de personagens"),
      ),
      body: FutureBuilder(
        initialData: [],
        future: pageData(),
        builder: (context, snapshot) {
          List personagens = snapshot.data as List;
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
            itemCount: personagens.length,
            itemBuilder: (context, index) {
              return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(personagens[index].image),
                  ),
                  title: Text("Nome: ${personagens[index].name}"),
                  subtitle: Text(
                      "Status: ${personagens[index].status}\nEspécie: ${personagens[index].species}\nGênero: ${personagens[index].gender}\nOrigem: ${personagens[index].origin}"),
                  trailing: IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return PersonagensDetalhes(personagens[index]);
                        }));
                      },
                      icon: const Icon(Icons.remove_red_eye)));
            },
          );
        },
      ),
    );
  }
}
