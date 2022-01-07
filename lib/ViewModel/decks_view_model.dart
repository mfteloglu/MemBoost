import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:memboost/Model/deck_model.dart';
import 'package:memboost/ClassModels/deck.dart';

class DecksViewModel extends ChangeNotifier {
  late List<Deck> downloadedDecks = [];
  late List<String> decksOnServer = [];
  Deck? currentSelectedDeck;

  DeckModel model = DeckModel();

  void selectDeckToBeReviewed(Deck deck) {
    currentSelectedDeck = deck;
    notifyListeners();
  }

  void getDownloadedDecks() async {
    downloadedDecks = await model.getAllDecksFromStorage();
    notifyListeners();
  }

  void downloadDeck(String deckName) async {
    await model.downloadDeck(deckName + ".json");
    getDownloadedDecks();
  }

  void getListOfDecksOnServer() async {
    decksOnServer = await model.listAllDecks();
    var i = 0;
    while (i < decksOnServer.length) {
      decksOnServer[i] = decksOnServer[i].split('.').first;
      i++;
    }
    notifyListeners();
  }

  // This function updates the deck on the phones storage
  void updateCurrentDeck(Deck deckToUpdate) async {
    await model.updateCurrentDeck(deckToUpdate);
    notifyListeners();
  }

  void deleteDeck(String name) async {
    await model.deleteDeckFromStorage(name + ".json");
    //change the current selected deck if it was the one deleted
    downloadedDecks.removeWhere((element) => element.name == name);
    if (name == currentSelectedDeck?.name) {
      if (downloadedDecks.isNotEmpty) {
        currentSelectedDeck = downloadedDecks.first;
      } else {
        currentSelectedDeck = null;
      }
    }
    getDownloadedDecks();
  }

  void createNewDeck(Deck deck) async {
    await model.writeDeckToStorage(deck);
    await model.uploadDeck(deck);
    getDownloadedDecks();
  }
}
