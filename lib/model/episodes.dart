class CabecalhoRequisicao {
  int count;
  int pages;
  String? next;
  String? prev;

  CabecalhoRequisicao(
      {required this.count, required this.pages, this.next, this.prev});
}

class Episodio {
  int id;
  String name;
  String airDate;
  String episode;
  List<String> characters;

  Episodio(
      {required this.id,
      required this.name,
      required this.airDate,
      required this.episode,
      required this.characters});
}
