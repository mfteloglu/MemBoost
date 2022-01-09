import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

//import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:memboost/tinder_card.dart';
import 'package:memboost/ClassModels/deck.dart';
import 'package:memboost/ViewModel/decks_view_model.dart';
import 'package:provider/provider.dart';

class ReviewDeckScreen extends StatefulWidget {
  const ReviewDeckScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ReviewDeckScreenState();
  }
}

class _ReviewDeckScreenState extends State<ReviewDeckScreen>
    with AutomaticKeepAliveClientMixin {
  var numOfCards = 0;
  var counter = 0;
  var nameOfDeck = "";
  Deck? deck;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Provider.of<DecksViewModel>(context, listen: false).getDownloadedDecks();

    CardController controller; //Use this to trigger swap.
    return Consumer<DecksViewModel>(
      builder: (context, viewModel, child) {
        var oldDeckName = deck?.name;
        deck = viewModel.currentSelectedDeck;
        ///////////////////////////////////
        // deck!.enqueueNewCards();
        // deck!.enqueueReviewCards();
        // deck!.addTwoQueues();
        // deck!.reQueue();
        //////////////////////////////////7
        if (deck == null) {
          if (viewModel.downloadedDecks.isNotEmpty) {
            deck = viewModel.downloadedDecks.first;
            deck!.giveNewCardsDate();
            deck!.enqueueNewCards();
            deck!.enqueueReviewCards();
            deck!.addTwoQueues();
            //deck!.printTodaysQueue();
          } else {
            deck = Deck("", "", []);
          }
        }
        if (deck?.name != oldDeckName) {
          counter = 0;
        }
        return Scaffold(
          backgroundColor: Colors.teal[100],
          body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Align(alignment: Alignment.topCenter, child: Text((deck?.name)!)),
            const SizedBox(height: 15),
            const Icon(Icons.credit_card),
            const SizedBox(height: 15),
            Text(
              "$counter" "/" "${deck?.cards.length}",
              //"$counter",
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: TinderSwapCard(
                swipeUp: true,
                swipeDown: true,
                swipeEdgeVertical: 10.0,
                orientation: AmassOrientation.BOTTOM,
                totalNum: (deck?.cards.length)!,
                //totalNum: 100,
                deck: deck,
                //stackNum: deck?.cards.length,
                swipeEdge: 4.0,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
                maxHeight: MediaQuery.of(context).size.width * 0.9,
                minWidth: MediaQuery.of(context).size.width * 0.8,
                minHeight: MediaQuery.of(context).size.width * 0.8,
                cardBuilder: (context, index) => FlipCard(
                    key: Key('flip$index'),
                    direction: FlipDirection.VERTICAL,
                    front: Card(
                      color: Colors.white,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                          child: Text(
                        //(deck?.cards[index].word)!,
                        (deck?.todaysQueue[0].word)!,
                        textScaleFactor: 2,
                      )),
                    ),
                    back: Card(
                      color: Colors.white,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 20,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    //(deck?.cards[index].explanation)!,
                                    (deck?.todaysQueue[0].explanation)!,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              /*
                              Expanded(
                                flex: 40,
                                child: Image.asset('lib/assets/masa.jpg',
                                    height: 120,
                                    width: 120,
                                    alignment: Alignment.topCenter),
                              ),
                              */
                              const Expanded(
                                  flex: 10,
                                  child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Icon(Icons.volume_up_rounded)))
                            ],
                          )),
                    )),
                cardController: controller = CardController(),
                swipeUpdateCallback:
                    (DragUpdateDetails details, Alignment align) {
                  /// Get swiping card's alignment
                  if (align.x < 0) {
                    //Card is LEFT swiping
                    debugPrint("swiped left");
                  } else if (align.x > 0) {
                    debugPrint("swiped right");
                    //Card is RIGHT swiping
                  }
                },
                swipeCompleteCallback:
                    (CardSwipeOrientation orientation, int index) {
                  if (orientation != CardSwipeOrientation.RECOVER) {
                    setState(() {
                      counter = index + 1;
                    });
                  }
                },
              ),
            ),
            Wrap(
              children: [
                ElevatedButton(
                    onPressed: () {
                      controller.triggerLeft();
                      // deck?.cards[counter].onButtonAgain();
                      deck?.todaysQueue[0].onButtonAgain();
                      deck!.enqueueNewCards();
                      deck!.enqueueReviewCards();
                      deck!.addTwoQueues();
                      deck?.reQueue();
                      Provider.of<DecksViewModel>(context, listen: false)
                          .updateCurrentDeck(deck!);
                    },
                    child: const Text('AGAIN'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                    )),
                const SizedBox(width: 50),
                ElevatedButton(
                    onPressed: () {
                      controller.triggerRight();
                      // deck?.cards[counter].onButtonGood();
                      deck?.todaysQueue[0].onButtonGood();
                      deck!.enqueueNewCards();
                      deck!.enqueueReviewCards();
                      deck!.addTwoQueues();
                      deck?.reQueue();
                      deck?.printTodaysQueue();
                      deck?.printCards();
                      Provider.of<DecksViewModel>(context, listen: false)
                          .updateCurrentDeck(deck!);
                    },
                    child: const Text('GOOD'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                    ))
              ],
            )
          ]),
        );
      },
    );
  }
}
