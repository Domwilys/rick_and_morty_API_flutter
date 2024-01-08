import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rick_and_morty_api/screens/telapersonagens.dart';
import 'package:rick_and_morty_api/screens/telaepisodios.dart';
import 'package:rick_and_morty_api/screens/telalocais.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RickAndMorty(),
  ));
}

class RickAndMorty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Rick and Morty API"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Personagens
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Personagens();
                  }));
                },
                child: Column(
                  children: [
                    Image.asset(
                      "images/characters.png",
                      width: 120,
                      height: 120,
                    ),
                    const Text(
                      "Personagens",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              //Episódios
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Episodios();
                  }));
                },
                child: Column(
                  children: [
                    Image.asset(
                      "images/episodes.png",
                      width: 120,
                      height: 120,
                    ),
                    const Text(
                      "Episódios",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              //Localizações
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Locais();
                  }));
                },
                child: Column(
                  children: [
                    Image.asset(
                      "images/locations.png",
                      width: 120,
                      height: 120,
                    ),
                    const Text(
                      "Localizações",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
