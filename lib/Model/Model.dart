import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DeckModel {
  String? name;
  String? creator;
  List<Flashcard> cards = [];

  // constructor
  DeckModel(String? name, String? creator, List<Flashcard> cards) {
    this.name = name;
    this.creator = creator;
    this.cards = cards;
  }

  // json read
  DeckModel.fromJson(Map<String, dynamic> json) {
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
    if (cards != null) {
      data['cards'] = cards.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Flashcard {
  String? word;
  String? explanation;
  int? ease;
  int? date;

  // constructor
  Flashcard(String? word, String? explanation, int? ease, int? date) {
    this.word = word;
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['word'] = this.word;
    data['explanation'] = this.explanation;
    data['ease'] = this.ease;
    data['date'] = this.date;
    return data;
  }
}

FirebaseFirestore firestore = FirebaseFirestore.instance;

void writeToFireStore() {
  firestore.collection("test").add({
    "name": "john",
    "age": 50,
    "email": "example@example.com",
    "address": {"street": "street 24", "city": "new york"}
  }).then((value) {
    print(value.id);
  });
}

FirebaseStorage storage = FirebaseStorage.instance;

Future<List<String>> listAllDecks() async {
  ListResult result = await FirebaseStorage.instance.ref('/decks').listAll();
  List<String> output = [];
  result.items.forEach((Reference ref) {
    output.add(ref.name.split(".").first);
  });
  return output;
}

Future<void> downloadDeck(String deckName) async {
  var fileName = deckName + ".json";
  Directory appDocDir = await getApplicationDocumentsDirectory();
  Directory decksDir = Directory("${appDocDir.path}/decks");
  if (!(await decksDir.exists())) {
    decksDir.create(recursive: false);
  }

  File downloadToFile = File('${decksDir.path}/${fileName}');
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  try {
    await FirebaseStorage.instance
        .ref('decks/${fileName}')
        .writeToFile(downloadToFile);
  } on FirebaseException catch (e) {
    // e.g, e.code == 'canceled'
  }
}

Future<void> readFromStorage(String deckName) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  Directory decks =
      await Directory("${appDocDir.path}/decks").create(recursive: true);
  File downloadToFile = File('${decks.path}/${deckName}');

  await for (var entity in decks.list(recursive: true, followLinks: false)) {
    print(entity.path);
  }
  final contents = await downloadToFile.readAsString();
  final Map<String, dynamic> data = json.decode(contents);
  // print(data);
  DeckModel test = DeckModel.fromJson(data);
  // print(test.cards[0].word);
  // print(test.cards[0].ease);
  // print(test.cards[0].explanation);
}

Future<List<DeckModel>> getAllDecksFromStorage() async {
  List<DeckModel> decks = [];
  Directory appDocDir = await getApplicationDocumentsDirectory();
  Directory decksDir = Directory("${appDocDir.path}/decks");
  if (!(await decksDir.exists())) {
    decksDir.create(recursive: false);
  }

  await for (var entity
      in decksDir.list(recursive: false, followLinks: false)) {
    String fileName = entity.path.split('/').last;
    File file = File('${decksDir.path}/${fileName}');
    final contents = await file.readAsString();
    final Map<String, dynamic> data = json.decode(contents);
    decks.add(DeckModel.fromJson(data));
  }
  return decks;
}
