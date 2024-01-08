class CabecalhoRequisicao {
  int count;
  int pages;
  String? next;
  String? prev;

  CabecalhoRequisicao(
      {required this.count, required this.pages, this.next, this.prev});
}

class Personagem {
  int id;
  String name;
  String status;
  String species;
  String image;
  String gender;
  String origin;
  List<String> episodio;

  Personagem(
      {required this.id,
      required this.name,
      required this.status,
      required this.species,
      required this.image,
      required this.gender,
      required this.origin,
      required this.episodio});
}
