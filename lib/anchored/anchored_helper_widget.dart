import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pal_widgets/animations/pop_anim.dart';

import 'anchor_model.dart';
import 'painters/anchor_painter.dart';
import 'painters/animated_circle.dart';

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

/// This widget is an helper based on the position of a widget
/// you must have an ancestor of type [HelperOrchestrator]
///
/// to create a
/// You can change [widgetFactory] to create your own anchored widget or use one of
/// - [AnchoredHoleHelper.anchorFactory]
///
/// You are free to add a positiv button / negativ button or an onTap function
/// on the anchor.
class AnchoredHelper extends StatefulWidget {
  /// The reference to the [Key] created by [HelperOrchestrator]
  final String anchorKeyId;

  /// A [Text] widget to show as title
  final Text? title;

  /// A [Text] widget to show as description
  final Text? description;

  /// A Color as Overlayed background
  final Color bgColor;

  /// A [Text] widget to show within the negativ button
  final Text? negativText;

  /// A [Text] widget to show within the positiv button
  final Text? positivText;

  /// Functions to call when user tap on negativ or positiv button
  final Function? onPositivTap, onNegativTap;

  /// Functions to call when widgets encounters any errors
  final Function? onError;

  /// Buttons material style
  final ButtonStyle? negativeBtnStyle, positivBtnStyle;

  /// If you want to use a custom position. Else we will use the [HelperOrchestrator]
  /// to get this using the [anchorKeyId]
  final Anchor? anchor;

  /// function called when user type on anchor position
  final Function? onTapAnchor;

  /// factory to create the all background with the hole
  /// Use one of these
  /// - [AnchoredCircleHoleHelper.anchorFactory]
  /// - [AnchoredRectHoleHelper.anchorFactory]
  /// or create yours
  final AnchorWidgetFactory widgetFactory;

  const AnchoredHelper({
    required this.anchorKeyId,
    this.onPositivTap,
    this.onNegativTap,
    this.positivText,
    this.negativText,
    this.title,
    this.description,
    this.onError,
    this.negativeBtnStyle,
    this.positivBtnStyle,
    this.onTapAnchor,
    Key? key,
    required this.bgColor,
    this.anchor,
    this.widgetFactory = AnchoredCircleHoleHelper.anchorFactory,
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
      curve: const Interval(0, .2, curve: Curves.easeIn),
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
              child: widget.widgetFactory.create(
                currentPos: anchor.offset,
                anchorSize: anchor.size,
                bgColor: widget.bgColor,
                listenable: anchorAnimationController,
                onTap: () async {
                  if (widget.onTapAnchor != null) {
                    HapticFeedback.selectionClick();
                    await fadeAnimController.reverse();
                    widget.onTapAnchor!();
                  }
                },
              ),
            ),
          ),
          Positioned.fromRect(
            rect: anchor.rect,
            child: LayoutBuilder(
              builder: (context, constraints) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: PopAnimation(
                          animation: fadeAnimController,
                          opacityAnim: titleOpacityAnimation,
                          sizeAnim: titleSizeAnimation,
                          child: widget.title ?? Container(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: PopAnimation(
                          animation: fadeAnimController,
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
                          if (widget.negativText != null &&
                              widget.onNegativTap != null)
                            PopAnimation(
                              animation: fadeAnimController,
                              opacityAnim: btnOpacityAnimation,
                              sizeAnim: btnSizeAnimation,
                              child: _buildEditableBordered(
                                widget.negativText!,
                                widget.onNegativTap!,
                                widget.negativeBtnStyle,
                              ),
                            ),
                          const SizedBox(width: 16),
                          if (widget.positivText != null &&
                              widget.onPositivTap != null)
                            PopAnimation(
                              animation: fadeAnimController,
                              opacityAnim: btnOpacityAnimation,
                              sizeAnim: btnSizeAnimation,
                              child: _buildEditableBordered(
                                widget.positivText!,
                                widget.onPositivTap!,
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
        ],
      ),
    );
  }

  Widget _buildEditableBordered(
    Text text,
    Function onTap,
    ButtonStyle? outlineButtonStyle,
  ) {
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
}
