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
  String? word; // front of the card
  String? explanation; // back of the car
  String status =
      "first"; // can be "first", "second", "third", "learning", "relearning1", "relearning2" or "matured"
  num ease = 2.5; // cards start with the ease of 250%
  // DateTime? date; // the date that the card will be shown to the user
  int?
      afterXMinutes; // this value is needed for the cards that are in the "first", "second", "third", "learning" and "relearning" phase, after this much minutes the user will see the card again
  int? scheduledDay;
  int? scheduledMonth;
  int? scheduledYear;
  int currentIntervalDays = 1;

  // constructor
  Flashcard(this.word, this.explanation);

  // json read
  Flashcard.fromJson(Map<String, dynamic> json) {
    word = json['word'];
    explanation = json['explanation'];
    status = json['status'];
    ease = json['ease'];
    // date = json['date'];
    afterXMinutes = json['afterXMinutes'];
    scheduledDay = json['scheduledDay'];
    scheduledMonth = json['scheduledMonth'];
    scheduledYear = json['scheduledYear'];
    currentIntervalDays = json['currentIntervalDays'];
  }

  // json write
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['word'] = word;
    data['explanation'] = explanation;
    data['status'] = status;
    data['ease'] = ease;
    // data['date'] = date;
    data['afterXMinutes'] = afterXMinutes;
    data['scheduledDay'] = scheduledDay;
    data['scheduledMonth'] = scheduledMonth;
    data['scheduledYear'] = scheduledYear;
    data['currentIntervalDays'] = currentIntervalDays;
    return data;
  }

  // this method will be called when the user presses the good button or swipes the card to the positive side
  void onButtonGood() {
    // if the card is in the first learning phase
    if (status == "first") {
      status = "second";
      afterXMinutes = 1;
    }
    // if the card is in the second learning phase
    else if (status == "second") {
      status = "third";
      afterXMinutes = 5;
    }
    // if the card is in the third learning phase
    else if (status == "third") {
      status = "young";
      afterXMinutes = 60;
    }
    // if the card is in the young phase
    else if (status == "young") {
      status = "matured";
      var today = DateTime.now();
      var newDate = today.add(const Duration(days: 1));
      scheduledDay = newDate.day;
      scheduledMonth = newDate.month;
      scheduledYear = newDate.year;
    }
    // if the card is in the matured phase
    else if (status == "matured") {
      var today = DateTime.now();
      var newDate =
          today.add(Duration(days: (ease * 1.15 * currentIntervalDays).ceil()));
      scheduledDay = newDate.day;
      scheduledMonth = newDate.month;
      scheduledYear = newDate.year;
    }
    // if the card is in the relearning1 phase
    else if (status == "relearning1") {
      status = "relearning2";
      afterXMinutes = 60;
    }
    // if the card is in the relearning2 phase
    else if (status == "relearning2") {
      status = "matured";
      var today = DateTime.now();
      var newDate =
          today.add(Duration(days: (currentIntervalDays * 0.2).ceil()));
      scheduledDay = newDate.day;
      scheduledMonth = newDate.month;
      scheduledYear = newDate.year;
    }
  }

  // this method will be called when the user presses the again button or swipes to the negative side
  void onButtonAgain() {
    if (status == "first") {
      afterXMinutes = 1;
    } else if (status == "second") {
      status = "first";
      afterXMinutes = 1;
    } else if (status == "third") {
      status = "first";
      afterXMinutes = 1;
    } else if (status == "young") {
      status = "first";
      afterXMinutes = 1;
    } else if (status == "matured") {
      status = "relearning1";
      afterXMinutes = 1;
    } else if (status == "relearning1") {
      afterXMinutes = 1;
    } else if (status == "relearning2") {
      status = "relearning1";
      afterXMinutes = 1;
    }
  }
}
