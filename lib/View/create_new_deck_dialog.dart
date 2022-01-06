import 'package:flutter/material.dart';
import 'package:memboost/ClassModels/deck.dart';
import 'package:memboost/ViewModel/decks_view_model.dart';
import 'package:provider/provider.dart';

class CreateNewDeckDialog extends StatefulWidget {
  const CreateNewDeckDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateNewDeckDialog();
  }
}

class _CreateNewDeckDialog extends State<CreateNewDeckDialog> {
  final TextEditingController _controllerTitle = TextEditingController();
  final _titleKey = GlobalKey<FormState>();
  final TextEditingController _controllerWord = TextEditingController();
  final _wordKey = GlobalKey<FormState>();
  final TextEditingController _controllerExplanation = TextEditingController();
  final _explanationKey = GlobalKey<FormState>();
  List<Widget> addedCardWidgets = [];
  Deck createdDeck = Deck("", "username", []);

  void addCard() {
    if (_controllerWord.text.isEmpty) {
      return;
    }
    createdDeck.cards
        .add(Flashcard(_controllerWord.text, _controllerExplanation.text));
    addedCardWidgets.add(NewCard(
        key: UniqueKey(),
        word: _controllerWord.text,
        explanation: _controllerExplanation.text,
        onDelete: onCardDelete));

    _controllerWord.clear();
    _controllerExplanation.clear();

    setState(() {});
  }

  void saveDeck() {
    //check and show error if name is empty
    if (_controllerTitle.text.isEmpty) {
      Widget okButton = TextButton(
        child: const Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("Error"),
        content: const Text("Please enter the name of your deck."),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
      return;
    }

    //check and show error if there are no cards
    if (createdDeck.cards.isEmpty) {
      Widget okButton = TextButton(
        child: const Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("Error"),
        content: const Text("Please add at least 1 card to your deck."),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
      return;
    }

    //Create deck
    createdDeck.name = _controllerTitle.text;
    Provider.of<DecksViewModel>(context, listen: false)
        .createNewDeck(createdDeck);
    Navigator.pop(context);
  }

  void onCardDelete(NewCard card) {
    addedCardWidgets.remove(card);
    createdDeck.cards.removeWhere((element) {
      return element.explanation == card.explanation &&
          element.word == card.word;
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        key: UniqueKey(),
        alignment: Alignment.center,
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.85,
            child: Scaffold(
                appBar: AppBar(
                  title: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Deck Name',
                          ),
                          key: _titleKey,
                          controller: _controllerTitle,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            splashRadius: 20,
                            onPressed: () {
                              saveDeck();
                            },
                            icon: Icon(
                              Icons.save,
                              color: Theme.of(context).colorScheme.onSecondary,
                            )),
                      )
                    ],
                  ),
                ),
                extendBody: true,
                body: Column(
                  children: [
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...addedCardWidgets,
                        ],
                      ),
                    )),
                    const Divider(
                      thickness: 2,
                    ),
                    Container(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text("Word:  "),
                                      Expanded(
                                          child: TextField(
                                        key: _wordKey,
                                        controller: _controllerWord,
                                      ))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Explanation:  "),
                                      Expanded(
                                        child: TextField(
                                          key: _explanationKey,
                                          controller: _controllerExplanation,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: IconButton(
                                      onPressed: () {
                                        addCard();
                                      },
                                      splashRadius: 20,
                                      icon: const Icon(Icons.add)),
                                ))
                          ],
                        ))
                  ],
                ))));
  }
}

//ADDED WORDS
class NewCard extends StatefulWidget {
  NewCard(
      {Key? key,
      required this.word,
      required this.explanation,
      required this.onDelete})
      : super(key: key);
  String word;
  String explanation;
  Function onDelete;

  @override
  State<NewCard> createState() => _NewCardState();
}

class _NewCardState extends State<NewCard> {
  @override
  Widget build(BuildContext context) {
    return (Container(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
        child: Container(
            decoration: BoxDecoration(color: Colors.teal[200]),
            padding: const EdgeInsets.all(10),
            child: Row(children: [
              Expanded(
                child: Column(
                  children: [
                    Text(widget.word),
                    Text(widget.explanation),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
              IconButton(
                  onPressed: () {
                    widget.onDelete(widget);
                  },
                  color: Colors.white,
                  icon: const Icon(Icons.delete))
            ]))));
  }
}
