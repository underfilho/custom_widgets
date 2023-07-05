import 'package:flutter/material.dart';

class LeftMenu extends StatefulWidget {
  final Widget Function(void Function() closeMenu) menuContent;
  final Widget Function(void Function() openMenu) child;
  final void Function(bool isOpened)? onToogleMenu;
  final bool isMenuOpened;

  const LeftMenu({
    Key? key,
    required this.menuContent,
    required this.child,
    this.isMenuOpened = false,
    this.onToogleMenu,
  }) : super(key: key);

  @override
  State<LeftMenu> createState() => _LeftMenuState();
}

class _LeftMenuState extends State<LeftMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController anim;
  late Animation curveScale;
  late Animation curveTrans;

  late bool isMenuOpened;

  @override
  void initState() {
    super.initState();
    anim = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    curveScale = CurvedAnimation(curve: Curves.easeOut, parent: anim);
    curveTrans = CurvedAnimation(curve: Curves.easeIn, parent: anim);

    menuState();
  }

  void menuState() {
    isMenuOpened = widget.isMenuOpened;
    anim.addStatusListener((status) {
      if (status == AnimationStatus.dismissed ||
          status == AnimationStatus.completed) {
        if (widget.onToogleMenu != null)
          widget.onToogleMenu!(status == AnimationStatus.completed);
        isMenuOpened = status == AnimationStatus.completed;
      }
    });
    if (isMenuOpened) anim.value = 1;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        widget.menuContent(anim.reverse),
        AnimatedBuilder(
          animation: anim,
          builder: (_, child) {
            return Transform.translate(
              offset: Offset(width * .60 * curveTrans.value, 0),
              child: Transform.scale(
                scale: 1 - .15 * curveScale.value,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    curveScale.value * 40 ?? 0,
                  ),
                  child: GestureDetector(
                    onHorizontalDragEnd: (details) =>
                        onDragEnd(details.primaryVelocity!),
                    onHorizontalDragUpdate: (details) =>
                        onDrag(details.primaryDelta!),
                    onTap: isMenuOpened ? () => anim.reverse() : () {},
                    child: AbsorbPointer(
                      absorbing: isMenuOpened,
                      child: child,
                    ),
                  ),
                ),
              ),
            );
          },
          child: widget.child(anim.forward),
        ),
      ],
    );
  }

  void onDrag(double delta) => anim.value += delta / 300;

  void onDragEnd(double delta) {
    if (anim.isCompleted || anim.isDismissed) return;

    if ((isMenuOpened && (anim.value > .9 || delta > 0)) ||
        (!isMenuOpened && anim.value > .1 && delta >= 0))
      anim.forward();
    else
      anim.reverse();
  }
}
