class Deck {
  String? name;
  String? creator;
  List<Flashcard> cards = [];
  List<Flashcard> newCardsQueue = [];
  List<Flashcard> todaysQueue = [];
  int newCardsPerDay = 4;

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

  void giveNewCardsDate() {
    int j = 15;
    for (int i = 0; i < cards.length; i++) {
      if (cards[i].status == "new") {
        var today = DateTime.now();
        var newDate = today.add(Duration(seconds: j));
        cards[i].scheduledDay = newDate.day;
        cards[i].scheduledMonth = newDate.month;
        cards[i].scheduledYear = newDate.year;
        cards[i].scheduledMinutes = newDate.minute;
        cards[i].scheduledDate = newDate.toString();
        j += 15;
      }
    }
  }

  // this method searches all the cards on the deck and finds first newCardsPerDay new cards and enqueues them
  void enqueueNewCards() {
    newCardsQueue = [];
    for (int i = 0; i < cards.length; i++) {
      if (i == newCardsPerDay) break;
      if (cards[i].status == "new") {
        newCardsQueue.add(cards[i]);
      }
    }
  }

  // this method searches all the cards on the deck and finds those that are sheculed to today and enqueues them
  void enqueueReviewCards() {
    todaysQueue = [];
    for (int i = 0; i < cards.length; i++) {
      var today = DateTime.now();
      if (cards[i].status == "new") {
        continue;
      }
      if (cards[i].scheduledYear == today.year &&
          cards[i].scheduledMonth == today.month &&
          cards[i].scheduledDay == today.day) {
        // add the card to the todaysQueue array
        todaysQueue.add(cards[i]);
      }
    }
  }

  // this method adds two queues
  void addTwoQueues() {
    todaysQueue.addAll(newCardsQueue);
  }

  // this method iterates todaysQeueue and requeues it according to the cards scheduled date
  void reQueue() {
    todaysQueue.sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
  }

  void printTodaysQueue() {
    print("TodaysQueue ####################");
    for (int i = 0; i < todaysQueue.length; i++) {
      print(
          "Card ${i} cardWord: ${todaysQueue[i].word} cardBack: ${todaysQueue[i].explanation} cardScheduleDate: ${todaysQueue[i].scheduledDate} cardStatus: ${todaysQueue[i].status}");
    }
    print("####################");
  }

  void printCards() {
    print("Cards ####################");
    for (int i = 0; i < cards.length; i++) {
      print(
          "Card ${i} cardWord: ${cards[i].word} cardBack: ${cards[i].explanation} cardScheduleDate: ${cards[i].scheduledDate} cardStatus: ${cards[i].status}");
    }
    print("####################");
  }
}

class Flashcard {
  String? word; // front of the card
  String? explanation; // back of the card
  String status =
      "new"; // can be "new", "first", "second", "third", "learning", "relearning1", "relearning2" or "matured"
  num ease = 2.5; // cards start with the ease of 250%
  // DateTime? date; // the date that the card will be shown to the user
  int?
      afterXMinutes; // this value is needed for the cards that are in the "first", "second", "third", "learning" and "relearning" phase, after this much minutes the user will see the card again
  int? scheduledDay;
  int? scheduledMonth;
  int? scheduledYear;
  int? scheduledMinutes;
  int currentIntervalDays = 1;
  String scheduledDate = "2100-10-10 00:00:00.000Z";

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
    scheduledMinutes = json['scheduledMinutes'];
    currentIntervalDays = json['currentIntervalDays'];
    scheduledDate = json['scheduledDate'];
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
    data['scheduledMinutes'] = scheduledMinutes;
    data['currentIntervalDays'] = currentIntervalDays;
    data['scheduledDate'] = scheduledDate;
    return data;
  }

  // this method will be called when the user presses the good button or swipes the card to the positive side
  void onButtonGood() {
    if (status == "new") {
      status = "first";
      afterXMinutes = 1;
      var today = DateTime.now();
      var newDate = today.add(const Duration(minutes: 1));
      scheduledDay = newDate.day;
      scheduledMonth = newDate.month;
      scheduledYear = newDate.year;
      scheduledMinutes = newDate.minute;
      scheduledDate = newDate.toString();
    }
    // if the card is in the first learning phase
    else if (status == "first") {
      status = "second";
      afterXMinutes = 1;
      var today = DateTime.now();
      var newDate = today.add(const Duration(minutes: 1));
      scheduledDay = newDate.day;
      scheduledMonth = newDate.month;
      scheduledYear = newDate.year;
      scheduledMinutes = newDate.minute;
      scheduledDate = newDate.toString();
    }
    // if the card is in the second learning phase
    else if (status == "second") {
      status = "third";
      afterXMinutes = 5;
      var today = DateTime.now();
      var newDate = today.add(const Duration(minutes: 5));
      scheduledDay = newDate.day;
      scheduledMonth = newDate.month;
      scheduledYear = newDate.year;
      scheduledMinutes = newDate.minute;
      scheduledDate = newDate.toString();
    }
    // if the card is in the third learning phase
    else if (status == "third") {
      status = "young";
      afterXMinutes = 60;
      var today = DateTime.now();
      var newDate = today.add(const Duration(hours: 1));
      scheduledDay = newDate.day;
      scheduledMonth = newDate.month;
      scheduledYear = newDate.year;
      scheduledMinutes = newDate.minute;
      scheduledDate = newDate.toString();
    }
    // if the card is in the young phase
    else if (status == "young") {
      status = "matured";
      var today = DateTime.now();
      var newDate = today.add(const Duration(days: 1));
      scheduledDay = newDate.day;
      scheduledMonth = newDate.month;
      scheduledYear = newDate.year;
      scheduledMinutes = newDate.minute;
      scheduledDate = newDate.toString();
    }
    // if the card is in the matured phase
    else if (status == "matured") {
      var today = DateTime.now();
      var newDate =
          today.add(Duration(days: (ease * 1.15 * currentIntervalDays).ceil()));
      scheduledDay = newDate.day;
      scheduledMonth = newDate.month;
      scheduledYear = newDate.year;
      scheduledMinutes = newDate.minute;
      scheduledDate = newDate.toString();
    }
    // if the card is in the relearning1 phase
    else if (status == "relearning1") {
      status = "relearning2";
      afterXMinutes = 60;
      var today = DateTime.now();
      var newDate = today.add(const Duration(hours: 1));
      scheduledDay = newDate.day;
      scheduledMonth = newDate.month;
      scheduledYear = newDate.year;
      scheduledMinutes = newDate.minute;
      scheduledDate = newDate.toString();
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
      scheduledMinutes = newDate.minute;
      scheduledDate = newDate.toString();
    }
  }

  // this method will be called when the user presses the again button or swipes to the negative side
  void onButtonAgain() {
    if (status == "new") {
      status = "first";
      afterXMinutes = 1;
      var today = DateTime.now();
      var newDate = today.add(const Duration(minutes: 1));
      scheduledDay = newDate.day;
      scheduledMonth = newDate.month;
      scheduledYear = newDate.year;
      scheduledMinutes = newDate.minute;
      scheduledDate = newDate.toString();
    } else if (status == "first") {
      afterXMinutes = 1;
      var today = DateTime.now();
      var newDate = today.add(const Duration(minutes: 1));
      scheduledDay = newDate.day;
      scheduledMonth = newDate.month;
      scheduledYear = newDate.year;
      scheduledMinutes = newDate.minute;
      scheduledDate = newDate.toString();
    } else if (status == "second") {
      status = "first";
      afterXMinutes = 1;
      var today = DateTime.now();
      var newDate = today.add(const Duration(minutes: 1));
      scheduledDay = newDate.day;
      scheduledMonth = newDate.month;
      scheduledYear = newDate.year;
      scheduledMinutes = newDate.minute;
      scheduledDate = newDate.toString();
    } else if (status == "third") {
      status = "first";
      afterXMinutes = 1;
      var today = DateTime.now();
      var newDate = today.add(const Duration(minutes: 1));
      scheduledDay = newDate.day;
      scheduledMonth = newDate.month;
      scheduledYear = newDate.year;
      scheduledMinutes = newDate.minute;
      scheduledDate = newDate.toString();
    } else if (status == "young") {
      status = "first";
      afterXMinutes = 1;
      var today = DateTime.now();
      var newDate = today.add(const Duration(minutes: 1));
      scheduledDay = newDate.day;
      scheduledMonth = newDate.month;
      scheduledYear = newDate.year;
      scheduledMinutes = newDate.minute;
      scheduledDate = newDate.toString();
    } else if (status == "matured") {
      status = "relearning1";
      afterXMinutes = 1;
      var today = DateTime.now();
      var newDate = today.add(const Duration(minutes: 1));
      scheduledDay = newDate.day;
      scheduledMonth = newDate.month;
      scheduledYear = newDate.year;
      scheduledMinutes = newDate.minute;
      scheduledDate = newDate.toString();
    } else if (status == "relearning1") {
      afterXMinutes = 1;
      var today = DateTime.now();
      var newDate = today.add(const Duration(minutes: 1));
      scheduledDay = newDate.day;
      scheduledMonth = newDate.month;
      scheduledYear = newDate.year;
      scheduledMinutes = newDate.minute;
      scheduledDate = newDate.toString();
    } else if (status == "relearning2") {
      status = "relearning1";
      afterXMinutes = 1;
      var today = DateTime.now();
      var newDate = today.add(const Duration(minutes: 1));
      scheduledDay = newDate.day;
      scheduledMonth = newDate.month;
      scheduledYear = newDate.year;
      scheduledMinutes = newDate.minute;
      scheduledDate = newDate.toString();
    }
  }
}
