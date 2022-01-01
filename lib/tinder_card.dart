import 'package:flutter/material.dart';
import 'dart:math';
import 'package:memboost/ClassModels/deck.dart';

List<Size> _cardSizes = [];
List<Alignment> _cardAligns = [];

enum TriggerDirection { none, right, left, up, down }

/// A Tinder-Like Widget.
class TinderSwapCard extends StatefulWidget {
  final CardBuilder _cardBuilder;
  final int _totalNum;
  final int _stackNum;
  final int _animDuration;
  final double _swipeEdge;
  final double _swipeEdgeVertical;
  final bool _swipeUp;
  final bool _swipeDown;
  final bool _allowVerticalMovement;
  CardSwipeCompleteCallback swipeCompleteCallback;
  CardDragUpdateCallback swipeUpdateCallback;
  CardController cardController;
  final Deck? _deck;

  @override
  _TinderSwapCardState createState() => _TinderSwapCardState();

  /// Constructor requires Card Widget Builder [cardBuilder] & your card count [totalNum]
  /// , option includes: stack orientation [orientation], number of card display in same time [stackNum]
  /// , [swipeEdge] is the edge to determine action(recover or swipe) when you release your swiping card
  /// it is the value of alignment, 0.0 means middle, so it need bigger than zero.
  /// , and size control params;
  TinderSwapCard(
      {Key? key,
      required CardBuilder cardBuilder,
      required int totalNum,
      AmassOrientation orientation = AmassOrientation.BOTTOM,
      int stackNum = 3,
      int animDuration = 800,
      double swipeEdge = 3.0,
      double swipeEdgeVertical = 8.0,
      bool swipeUp = false,
      bool swipeDown = false,
      required double maxWidth,
      required double maxHeight,
      required double minWidth,
      required double minHeight,
      bool allowVerticalMovement = true,
      Deck? deck,
      required this.cardController,
      required this.swipeCompleteCallback,
      required this.swipeUpdateCallback})
      : _cardBuilder = cardBuilder,
        _totalNum = totalNum,
        assert(stackNum > 1),
        _stackNum = stackNum,
        _animDuration = animDuration,
        assert(swipeEdge > 0),
        _swipeEdge = swipeEdge,
        assert(swipeEdgeVertical > 0),
        _swipeEdgeVertical = swipeEdgeVertical,
        _swipeUp = swipeUp,
        _swipeDown = swipeDown,
        assert(maxWidth > minWidth && maxHeight > minHeight),
        _allowVerticalMovement = allowVerticalMovement,
        _deck = deck,
        super(key: key) {
    double widthGap = maxWidth - minWidth;
    double heightGap = maxHeight - minHeight;

    _cardAligns = [];
    _cardSizes = [];

    for (int i = 0; i < _stackNum; i++) {
      _cardSizes.add(Size(minWidth + (widthGap / _stackNum) * i,
          minHeight + (heightGap / _stackNum) * i));

      switch (orientation) {
        case AmassOrientation.BOTTOM:
          _cardAligns
              .add(Alignment(0.0, (0.5 / (_stackNum - 1)) * (stackNum - i)));
          break;
        case AmassOrientation.TOP:
          _cardAligns
              .add(Alignment(0.0, (-0.5 / (_stackNum - 1)) * (stackNum - i)));
          break;
        case AmassOrientation.LEFT:
          _cardAligns
              .add(Alignment((-0.5 / (_stackNum - 1)) * (stackNum - i), 0.0));
          break;
        case AmassOrientation.RIGHT:
          _cardAligns
              .add(Alignment((0.5 / (_stackNum - 1)) * (stackNum - i), 0.0));
          break;
      }
    }
  }
}

class _TinderSwapCardState extends State<TinderSwapCard>
    with TickerProviderStateMixin {
  late Alignment frontCardAlign;
  late AnimationController _animationController;
  late int _currentFront;
  static late TriggerDirection _trigger;

  Widget _buildCard(BuildContext context, int realIndex) {
    if (realIndex < 0) {
      return Container();
    }
    int index = realIndex - _currentFront;

    if (index == widget._stackNum - 1) {
      return Align(
        alignment: _animationController.status == AnimationStatus.forward
            ? frontCardAlign = CardAnimation.frontCardAlign(
                    _animationController,
                    frontCardAlign,
                    _cardAligns[widget._stackNum - 1],
                    widget._swipeEdge,
                    widget._swipeUp,
                    widget._swipeDown)
                .value
            : frontCardAlign,
        child: Transform.rotate(
            angle: (pi / 180.0) *
                (_animationController.status == AnimationStatus.forward
                    ? CardAnimation.frontCardRota(
                            _animationController, frontCardAlign.x)
                        .value
                    : frontCardAlign.x),
            child: SizedBox.fromSize(
              size: _cardSizes[index],
              child: widget._cardBuilder(
                  context, widget._totalNum - realIndex - 1),
            )),
      );
    }

    return Align(
      alignment: _animationController.status == AnimationStatus.forward &&
              (frontCardAlign.x > 3.0 ||
                  frontCardAlign.x < -3.0 ||
                  frontCardAlign.y > 3 ||
                  frontCardAlign.y < -3)
          ? CardAnimation.backCardAlign(_animationController,
                  _cardAligns[index], _cardAligns[index + 1])
              .value
          : _cardAligns[index],
      child: SizedBox.fromSize(
        size: _animationController.status == AnimationStatus.forward &&
                (frontCardAlign.x > 3.0 ||
                    frontCardAlign.x < -3.0 ||
                    frontCardAlign.y > 3 ||
                    frontCardAlign.y < -3)
            ? CardAnimation.backCardSize(_animationController,
                    _cardSizes[index], _cardSizes[index + 1])
                .value
            : _cardSizes[index],
        child: widget._cardBuilder(context, widget._totalNum - realIndex - 1),
      ),
    );
  }

  List<Widget> _buildCards(BuildContext context) {
    List<Widget> cards = [];
    for (int i = _currentFront; i < _currentFront + widget._stackNum; i++) {
      cards.add(_buildCard(context, i));
    }

    cards.add(SizedBox.expand(
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          setState(() {
            if (widget._allowVerticalMovement == true) {
              frontCardAlign = Alignment(
                  frontCardAlign.x +
                      details.delta.dx * 20 / MediaQuery.of(context).size.width,
                  frontCardAlign.y +
                      details.delta.dy *
                          30 /
                          MediaQuery.of(context).size.height);
            } else {
              frontCardAlign = Alignment(
                  frontCardAlign.x +
                      details.delta.dx * 20 / MediaQuery.of(context).size.width,
                  0);

              widget.swipeUpdateCallback(details, frontCardAlign);
            }

            widget.swipeUpdateCallback(details, frontCardAlign);
          });
        },
        onPanEnd: (DragEndDetails details) {
          animateCards(TriggerDirection.none);
        },
      ),
    ));
    return cards;
  }

  animateCards(TriggerDirection trigger) {
    if (_animationController.isAnimating ||
        _currentFront + widget._stackNum == 0) {
      return;
    }
    _trigger = trigger;
    _animationController.stop();
    _animationController.value = 0.0;
    _animationController.forward();
  }

  void triggerSwap(TriggerDirection trigger) {
    animateCards(trigger);
  }

  // support for asynchronous data events
  @override
  void didUpdateWidget(covariant TinderSwapCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._deck?.name != oldWidget._deck?.name) {
      _initState();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initState();
  }

  void _initState() {
    _currentFront = widget._totalNum - widget._stackNum;

    frontCardAlign = _cardAligns[_cardAligns.length - 1];
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget._animDuration));
    _animationController.addListener(() => setState(() {}));
    _animationController.addStatusListener((AnimationStatus status) {
      int index = widget._totalNum - widget._stackNum - _currentFront;
      if (status == AnimationStatus.completed) {
        CardSwipeOrientation orientation;
        if (frontCardAlign.x < -widget._swipeEdge) {
          orientation = CardSwipeOrientation.LEFT;
        } else if (frontCardAlign.x > widget._swipeEdge) {
          orientation = CardSwipeOrientation.RIGHT;
        } else if (frontCardAlign.y < -widget._swipeEdgeVertical) {
          orientation = CardSwipeOrientation.UP;
        } else if (frontCardAlign.y > widget._swipeEdgeVertical) {
          orientation = CardSwipeOrientation.DOWN;
        } else {
          frontCardAlign = _cardAligns[widget._stackNum - 1];
          orientation = CardSwipeOrientation.RECOVER;
        }
        widget.swipeCompleteCallback(orientation, index);
        if (orientation != CardSwipeOrientation.RECOVER) changeCardOrder();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.cardController.addListener((trigger) => triggerSwap(trigger));

    return Stack(children: _buildCards(context));
  }

  changeCardOrder() {
    setState(() {
      _currentFront--;
      frontCardAlign = _cardAligns[widget._stackNum - 1];
    });
  }
}

typedef CardBuilder = Widget Function(BuildContext context, int index);

enum CardSwipeOrientation { LEFT, RIGHT, RECOVER, UP, DOWN }

/// swipe card to [CardSwipeOrientation.LEFT] or [CardSwipeOrientation.RIGHT]
/// , [CardSwipeOrientation.RECOVER] means back to start.
typedef CardSwipeCompleteCallback = void Function(
    CardSwipeOrientation orientation, int index);

/// [DragUpdateDetails] of swiping card.
typedef CardDragUpdateCallback = void Function(
    DragUpdateDetails details, Alignment align);

enum AmassOrientation { TOP, BOTTOM, LEFT, RIGHT }

class CardAnimation {
  static Animation<Alignment> frontCardAlign(
      AnimationController controller,
      Alignment beginAlign,
      Alignment baseAlign,
      double swipeEdge,
      bool swipeUp,
      bool swipeDown) {
    double endX, endY;

    if (_TinderSwapCardState._trigger == TriggerDirection.none) {
      endX = beginAlign.x > 0
          ? (beginAlign.x > swipeEdge ? beginAlign.x + 10.0 : baseAlign.x)
          : (beginAlign.x < -swipeEdge ? beginAlign.x - 10.0 : baseAlign.x);
      endY = beginAlign.x > 3.0 || beginAlign.x < -swipeEdge
          ? beginAlign.y
          : baseAlign.y;

      if (swipeUp || swipeDown) {
        if (beginAlign.y < 0) {
          if (swipeUp) {
            endY =
                beginAlign.y < -swipeEdge ? beginAlign.y - 10.0 : baseAlign.y;
          }
        } else if (beginAlign.y > 0) {
          if (swipeDown) {
            endY = beginAlign.y > swipeEdge ? beginAlign.y + 10.0 : baseAlign.y;
          }
        }
      }
    } else if (_TinderSwapCardState._trigger == TriggerDirection.left) {
      endX = beginAlign.x - swipeEdge;
      endY = beginAlign.y + 0.5;
    }
    /* Trigger Swipe Up or Down */
    else if (_TinderSwapCardState._trigger == TriggerDirection.up ||
        _TinderSwapCardState._trigger == TriggerDirection.down) {
      var beginY =
          _TinderSwapCardState._trigger == TriggerDirection.up ? -10 : 10;

      endY = beginY < -swipeEdge ? beginY - 10.0 : baseAlign.y;

      endX = beginAlign.x > 0
          ? (beginAlign.x > swipeEdge ? beginAlign.x + 10.0 : baseAlign.x)
          : (beginAlign.x < -swipeEdge ? beginAlign.x - 10.0 : baseAlign.x);
    } else {
      endX = beginAlign.x + swipeEdge;
      endY = beginAlign.y + 0.5;
    }
    return AlignmentTween(begin: beginAlign, end: Alignment(endX, endY))
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
  }

  static Animation<double> frontCardRota(
      AnimationController controller, double beginRot) {
    return Tween(begin: beginRot, end: 0.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
  }

  static Animation<Size?> backCardSize(
      AnimationController controller, Size beginSize, Size endSize) {
    return SizeTween(begin: beginSize, end: endSize)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
  }

  static Animation<Alignment> backCardAlign(AnimationController controller,
      Alignment beginAlign, Alignment endAlign) {
    return AlignmentTween(begin: beginAlign, end: endAlign)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
  }
}

typedef TriggerListener = void Function(TriggerDirection trigger);

class CardController {
  late TriggerListener? _listener;

  void triggerLeft() {
    if (_listener != null) {
      _listener!(TriggerDirection.left);
    }
  }

  void triggerRight() {
    if (_listener != null) {
      _listener!(TriggerDirection.right);
    }
  }

  void triggerUp() {
    if (_listener != null) {
      _listener!(TriggerDirection.up);
    }
  }

  void triggerDown() {
    if (_listener != null) {
      _listener!(TriggerDirection.down);
    }
  }

  void addListener(listener) {
    _listener = listener;
  }

  void removeListener() {
    _listener = null;
  }
}
