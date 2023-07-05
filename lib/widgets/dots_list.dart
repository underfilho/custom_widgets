import 'package:custom_widgets/painted_widgets/my_popup.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class DotsList extends StatefulWidget {
  final List<Dot> dots;
  final Function(int)? onSelected;
  final int selected;

  const DotsList({
    required this.dots,
    this.onSelected,
    this.selected = 0,
    Key? key,
  }) : super(key: key);

  @override
  State<DotsList> createState() => _DotsListState();
}

class _DotsListState extends State<DotsList>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late CurvedAnimation _curve;
  late int selected;
  Timer? _timerReverse;
  OverlayEntry? _overlayEntry;
  List<GlobalKey> _keys = [];

  @override
  void initState() {
    super.initState();
    selected = widget.selected;
    _animController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _curve = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        _timerReverse = Timer(const Duration(seconds: 1),
            () => _animController.reverse().then((value) => closePopUp()));
    });

    _keys =
        widget.dots.mapIndexed((i, e) => LabeledGlobalKey('dot$i')).toList();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => Future.delayed(const Duration(milliseconds: 100), showPopUp));
  }

  @override
  void dispose() {
    closePopUp();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.dots.mapIndexed((i, dot) {
        return Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              if (i == selected)
                showPopUp();
              else {
                selected = i;
                showPopUp();
                setState(() {});
                if (widget.onSelected != null) widget.onSelected!(i);
              }
            },
            child: Container(
              key: _keys[i],
              height: 30,
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 1.5,
                  color: (i == selected) ? dot.color : Colors.transparent,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: dot.color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void showPopUp() {
    _animController.reset();
    closePopUp();

    _overlayEntry = _overlayEntryBuilder();
    _animController.forward();
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void closePopUp() {
    if (_timerReverse != null && _timerReverse!.isActive)
      _timerReverse?.cancel();

    if (isPopupOpen()) _overlayEntry?.remove();
  }

  bool isPopupOpen() {
    if (_overlayEntry == null) return false;
    return _overlayEntry!.mounted;
  }

  OverlayEntry _overlayEntryBuilder() {
    const width = 150.0;

    return OverlayEntry(
      builder: (context) {
        final renderBox =
            _keys[selected].currentContext!.findRenderObject() as RenderBox;
        final size = renderBox.size;
        final position = renderBox.localToGlobal(Offset.zero);

        final screenWidth = MediaQuery.of(context).size.width;
        var xcoord = 0.5;
        if (position.dx < 100) xcoord = 0.3;
        if (position.dx + size.width > screenWidth - 100) xcoord = 0.7;

        return Positioned(
          top: position.dy + size.height - 5.0,
          left: ((0.5 - xcoord) * width) +
              position.dx -
              width / 2 +
              size.width / 2,
          width: width,
          child: Material(
            color: Colors.transparent,
            child: ScaleTransition(
              alignment: Alignment((xcoord - 0.5) * 2, -1),
              scale: _curve,
              child: MyPopUp(
                xcoord: xcoord,
                color: widget.dots[selected].color,
                text: widget.dots[selected].name,
              ),
            ),
          ),
        );
      },
    );
  }
}

class Dot {
  String name;
  Color color;

  Dot(this.name, this.color);
}
