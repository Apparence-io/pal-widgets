import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'anchor_model.dart';
import 'animated_circle_painter.dart';

class AnchorHelperWrapper extends InheritedWidget {
  final Anchor anchor;

  const AnchorHelperWrapper({
    Key? key,
    required this.anchor,
    required Widget child,
  }) : super(key: key, child: child);

  static AnchorHelperWrapper? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AnchorHelperWrapper>();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}

class AnchoredHelper extends StatefulWidget {
  final String anchorKeyId;
  final Text? title;
  final Text? description;
  final Text negativText;
  final Text positivText;
  final Color bgColor;

  final Function onPositivTap, onNegativTap;
  final Function? onError;
  final ButtonStyle? negativeBtnStyle, positivBtnStyle;
  final Anchor? anchor;

  const AnchoredHelper({
    required this.anchorKeyId,
    required this.onPositivTap,
    required this.onNegativTap,
    required this.positivText,
    required this.negativText,
    this.title,
    this.description,
    this.onError,
    this.negativeBtnStyle,
    this.positivBtnStyle,
    Key? key,
    required this.bgColor,
    this.anchor,
  }) : super(key: key);

  @override
  _AnchoredHelperState createState() => _AnchoredHelperState();
}

class _AnchoredHelperState extends State<AnchoredHelper>
    with TickerProviderStateMixin {
  late AnimationController anchorAnimationController, fadeAnimController;
  late Animation<double> backgroundAnimation;

  Animation<double>? titleOpacityAnimation, titleSizeAnimation;
  Animation<double>? descriptionOpacityAnimation, descriptionSizeAnimation;
  Animation<double>? btnOpacityAnimation, btnSizeAnimation;

  Anchor get anchor => widget.anchor ?? AnchorHelperWrapper.of(context)!.anchor;

  @override
  void initState() {
    super.initState();
    anchorAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);
    fadeAnimController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    backgroundAnimation = CurvedAnimation(
      parent: fadeAnimController,
      curve: const Interval(0, .4, curve: Curves.easeIn),
    );
    titleOpacityAnimation = CurvedAnimation(
      parent: fadeAnimController,
      curve: const Interval(.4, .5, curve: Curves.easeIn),
    );
    titleSizeAnimation = CurvedAnimation(
      parent: fadeAnimController,
      curve: const Interval(.4, .6, curve: Curves.easeInOutBack),
    );
    descriptionOpacityAnimation = CurvedAnimation(
      parent: fadeAnimController,
      curve: const Interval(.5, .6, curve: Curves.easeIn),
    );
    descriptionSizeAnimation = CurvedAnimation(
      parent: fadeAnimController,
      curve: const Interval(.5, .7, curve: Curves.easeInOutBack),
    );
    btnOpacityAnimation = CurvedAnimation(
      parent: fadeAnimController,
      curve: const Interval(.8, .9, curve: Curves.easeIn),
    );
    btnSizeAnimation = CurvedAnimation(
      parent: fadeAnimController,
      curve: const Interval(.8, 1, curve: Curves.easeInOutBack),
    );
    fadeAnimController.forward();
  }

  @override
  void dispose() {
    anchorAnimationController.stop();
    fadeAnimController.stop();
    anchorAnimationController.dispose();
    fadeAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: FadeTransition(
              opacity: backgroundAnimation,
              child: AnimatedAnchoredFullscreenCircle(
                currentPos: anchor.offset,
                anchorSize: anchor.size,
                bgColor: widget.bgColor,
                padding: 8,
                listenable: anchorAnimationController,
              ),
            ),
          ),
          Positioned.fromRect(
            rect: anchor.rect,
            child: LayoutBuilder(
              builder: (context, constraints) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: _buildAnimItem(
                            opacityAnim: titleOpacityAnimation,
                            sizeAnim: titleSizeAnimation,
                            child: widget.title ?? Container(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: _buildAnimItem(
                            opacityAnim: descriptionOpacityAnimation,
                            sizeAnim: descriptionSizeAnimation,
                            child: widget.description ?? Container(),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildAnimItem(
                              opacityAnim: btnOpacityAnimation,
                              sizeAnim: btnSizeAnimation,
                              child: _buildEditableBordered(
                                widget.negativText,
                                widget.onNegativTap,
                                widget.negativeBtnStyle,
                              ),
                            ),
                            const SizedBox(width: 16),
                            _buildAnimItem(
                              opacityAnim: btnOpacityAnimation,
                              sizeAnim: btnSizeAnimation,
                              child: _buildEditableBordered(
                                widget.positivText,
                                widget.onPositivTap,
                                widget.positivBtnStyle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableBordered(
      Text text, Function onTap, ButtonStyle? outlineButtonStyle) {
    return OutlinedButton(
      onPressed: () async {
        HapticFeedback.selectionClick();
        await fadeAnimController.reverse();
        onTap();
      },
      style: outlineButtonStyle,
      child: text,
    );
  }

  Widget _buildAnimItem(
          {Animation<double>? sizeAnim,
          Animation<double>? opacityAnim,
          Widget? child}) =>
      AnimatedBuilder(
        animation: fadeAnimController,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, -100 + ((sizeAnim?.value ?? 0) * 100)),
          child: Transform.scale(
            scale: sizeAnim?.value ?? 0,
            child: Opacity(
              opacity: opacityAnim?.value ?? 0,
              child: child,
            ),
          ),
        ),
        child: child,
      );
}
