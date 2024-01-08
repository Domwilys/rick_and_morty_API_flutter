import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Aparicao {
  int id;
  String name;
  String status;
  String species;
  String image;
  String gender;

  Aparicao(
      {required this.id,
      required this.name,
      required this.status,
      required this.species,
      required this.image,
      required this.gender});
}

class PersonagensAparicao extends StatefulWidget {
  final dynamic episodio;
  PersonagensAparicao(this.episodio);

  @override
  State<PersonagensAparicao> createState() => _PersonagensAparicao();
}

class _PersonagensAparicao extends State<PersonagensAparicao> {
  List<Aparicao> listaAparicoes = [];

  Future<void> carregarAparicoes() async {
    for (var aparicaoUrl in widget.episodio.characters) {
      final response = await http.Client().get(Uri.parse(aparicaoUrl));
      if (response.statusCode == 200) {
        var dadosAparicao = json.decode(response.body);
        Aparicao a = Aparicao(
            id: dadosAparicao['id'],
            name: dadosAparicao['name'],
            status: dadosAparicao['status'],
            species: dadosAparicao['species'],
            image: dadosAparicao['image'],
            gender: dadosAparicao['gender']);
        setState(() {
          listaAparicoes.add(a);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    carregarAparicoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Personagens que aparecem no episódio ${widget.episodio.name}"),
      ),
      body: FutureBuilder(
        future:
            Future.wait(listaAparicoes.map((a) => Future.value(a)).toList()),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: listaAparicoes.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(listaAparicoes[index].image),
                ),
                title:
                    Text("Nome do personagem: ${listaAparicoes[index].name}"),
                subtitle: Text(
                    "Status do personagem: ${listaAparicoes[index].status}\nEspécie do personagem: ${listaAparicoes[index].species}\nGênero do personagem: ${listaAparicoes[index].gender}"),
              );
            },
          );
        },
      ),
    );
  }
}
