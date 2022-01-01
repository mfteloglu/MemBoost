class Deck {
  String? name;
  String? creator;
  List<Flashcard> cards = [];

  // constructor
  Deck(this.name, this.creator, this.cards);

  // json read
  Deck.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    creator = json['creator'];
    if (json['cards'] != null) {
      json['cards'].forEach((v) {
        cards.add(Flashcard.fromJson(v));
      });
    }
  }

  // json write
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['creator'] = creator;
    data['cards'] = cards.map((v) => v.toJson()).toList();
    return data;
  }
}

class Flashcard {
  String? word;
  String? explanation;
  int? ease;
  int? date;

  // constructor
  Flashcard(this.word, this.explanation, this.ease, this.date);

  // json read
  Flashcard.fromJson(Map<String, dynamic> json) {
    word = json['word'];
    explanation = json['explanation'];
    ease = json['ease'];
    date = json['date'];
  }

  // json write
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['word'] = word;
    data['explanation'] = explanation;
    data['ease'] = ease;
    data['date'] = date;
    return data;
  }
}
