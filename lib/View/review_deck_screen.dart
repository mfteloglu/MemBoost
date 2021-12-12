import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';

class ReviewDeckScreen extends StatefulWidget {
  const ReviewDeckScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ReviewDeckScreenState();
  }
}


class _ReviewDeckScreenState extends State<ReviewDeckScreen> {
  var numOfCards = 5;
  var counter = 1;
  var nameOfDeck = "GERMAN 101 DECK";

  @override
  Widget build(BuildContext context) {
    CardController controller; //Use this to trigger swap.
    return new Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
              alignment: Alignment.topCenter,
              child: Text(nameOfDeck)
          ),
          SizedBox(height: 15),
          Icon(Icons.credit_card),
          SizedBox(height: 15),
          Text("$counter" + "/" + "$numOfCards",),
          SizedBox(height: 15),
          Container(
          height: MediaQuery.of(context).size.height * 0.4,
          child: TinderSwapCard(
            swipeUp: true,
            swipeDown: true,
            swipeEdgeVertical: 10.0,
            orientation: AmassOrientation.BOTTOM,
            totalNum: numOfCards,
            stackNum: numOfCards,
            swipeEdge: 4.0,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.width * 0.9,
            minWidth: MediaQuery.of(context).size.width * 0.8,
            minHeight: MediaQuery.of(context).size.width * 0.8,
            cardBuilder: (context, index) => FlipCard(
                direction: FlipDirection.VERTICAL,
                front: Card(
                  color: Colors.white,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Center(
                      child: Text("der Tisch")
                  ),
                ),
                back: Card(
                  color: Colors.white,
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          child: Text("Table : a flat surface, usually supported by four legs, used for putting things on", textAlign: TextAlign.center,),
                        ),
                        Image.asset('lib/assets/masa.jpg',height: 120, width: 120, alignment: Alignment.bottomCenter),
                        Icon(Icons.volume_up_rounded)],

                  ),
                )
            ),
            cardController: controller = CardController(),
            swipeUpdateCallback:
                (DragUpdateDetails details, Alignment align) {
              /// Get swiping card's alignment
              if (align.x < 0) {
                //Card is LEFT swiping
              } else if (align.x > 0) {
                //Card is RIGHT swiping
              }
            },
            swipeCompleteCallback:
                (CardSwipeOrientation orientation, int index) {
                    if(orientation != CardSwipeOrientation.RECOVER){
                      setState(() {
                        counter++;
                      });
                    }
                    print(orientation);



              /// Get orientation & index of swiped card!
            },
          ),
        ),]
      ),
    );
  }
}
