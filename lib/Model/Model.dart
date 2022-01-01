import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


class Deck{
  String? name;
  String? creator;
  List<Flashcard> cards = [];

  // constructor
  Deck(String? name, String? creator, List<Flashcard> cards){
    this.name  = name;
    this.creator = creator;
    this.cards = cards;
  }

  // json read
  Deck.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    creator = json['creator'];
    if (json['cards'] != null) {
      json['cards'].forEach((v) {
        cards.add(new Flashcard.fromJson(v));
      });
    }
  }

  // json write
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['creator'] = this.creator;
    if (this.cards != null) {
      data['cards'] = this.cards.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Flashcard{
  String? word;
  String? explanation;
  int? ease;
  int? date;

  // constructor
  Flashcard(String? word, String? explanation, int? ease, int? date){
    this.word  = word;
    this.explanation = explanation;
    this.ease = ease;
    this.date = date;
  }

  // json read
  Flashcard.fromJson(Map<String, dynamic> json) {
    word = json['word'];
    explanation = json['explanation'];
    ease = json['ease'];
    date = json['date'];
  }

  // json write
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['word'] = this.word;
    data['explanation'] = this.explanation;
    data['ease'] = this.ease;
    data['date'] = this.date;
    return data;
  }

}

FirebaseFirestore firestore = FirebaseFirestore.instance;

void writeToFireStore() {
  firestore.collection("test").add(
      {
        "name" : "john",
        "age" : 50,
        "email" : "example@example.com",
        "address" : {
          "street" : "street 24",
          "city" : "new york"
        }
      }).then((value){
    print(value.id);
  });
}

FirebaseStorage storage = FirebaseStorage.instance;

Future<List<String>> listAllDecks() async {
  ListResult result = await FirebaseStorage.instance.ref('/decks').listAll();
  List<String> output = [];
  result.items.forEach((Reference ref) {
    output.add(ref.name);
  });
  return output;
}


Future<void> downloadDeck(String deckName) async{

  Directory appDocDir = await getApplicationDocumentsDirectory();
  File downloadToFile = File('${appDocDir.path}/${deckName}');
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
    try {
      await FirebaseStorage.instance
          .ref('decks/${deckName}')
          .writeToFile(downloadToFile);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }

}

Future<void> readFromStorage(String deckName) async {

  Directory appDocDir = await getApplicationDocumentsDirectory();
  File downloadToFile = File('${appDocDir.path}/${deckName}');

  final contents = await downloadToFile.readAsString();
  final Map<String, dynamic> data = json.decode(contents);
  print(data);
  Deck test = Deck.fromJson(data);
  print(test.cards[0].word);
  print(test.cards[0].ease);
  print(test.cards[0].explanation);
}

