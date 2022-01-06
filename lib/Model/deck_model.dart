import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:memboost/ClassModels/deck.dart';

class DeckModel {
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<List<String>> listAllDecks() async {
    ListResult result = await FirebaseStorage.instance.ref('/decks').listAll();
    List<String> output = [];
    for (var ref in result.items) {
      output.add(ref.name);
    }
    return output;
  }

  Future<void> downloadDeck(String deckName) async {
    var fileName = deckName;
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

  Future<List<Deck>> getAllDecksFromStorage() async {
    List<Deck> decks = [];
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
      decks.add(Deck.fromJson(data));
    }
    return decks;
  }

  Future<void> deleteDeckFromStorage(String deckName) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory decksDir = Directory("${appDocDir.path}/decks");
    File deck = File(decksDir.path + "/" + deckName);
    deck.delete(recursive: false);
  }

  Future<void> writeDeckToStorage(Deck deck) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory decksDir = Directory("${appDocDir.path}/decks");
    File deckFile = File(decksDir.path + "/" + deck.name! + ".json");
    deckFile.writeAsString(json.encode(deck));
  }

  Future<void> uploadDeck(Deck deck) async {
    print(deck.name);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory decksDir = Directory("${appDocDir.path}/decks");
    File deckFile = File(decksDir.path + "/" + deck.name! + ".json");
    await storage.ref("decks/${deck.name}.json").putFile(deckFile);
  }
}
