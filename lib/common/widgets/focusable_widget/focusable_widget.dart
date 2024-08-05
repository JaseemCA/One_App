import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef VoidTapKeyEvent = void Function(RawKeyEvent event);

class FocusableWidget extends StatefulWidget {
  final bool autoFocus;
  final Widget child;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final VoidTapKeyEvent? onKey;
  final void Function(bool)? focusChanged;
  final bool? descendantsAreFocusable;
  final bool ignoreHorizontalMovement;
  final bool ignoreVerticalMovement;

  const FocusableWidget({
    super.key,
    this.autoFocus = false,
    required this.child,
    this.focusNode,
    this.onTap,
    this.onKey,
    this.focusChanged,
    this.descendantsAreFocusable,
    this.ignoreHorizontalMovement = false,
    this.ignoreVerticalMovement = false,
  });

  @override
  State<StatefulWidget> createState() {
    return _FocusableWidget();
  }
}

class _FocusableWidget extends State<FocusableWidget> {
  bool _gestureDetectorRequestedFocus = false;

  KeyEventResult _handleOnKey(FocusNode node, RawKeyEvent event) {
    if (widget.onKey != null) {
      widget.onKey!(event);
    }

    if (event is RawKeyDownEvent) {
      if (PhysicalKeyboardKey.findKeyByCode(event.physicalKey.usbHidUsage) ==
          null) {
        return KeyEventResult.ignored;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        if (widget.ignoreVerticalMovement) {
          return KeyEventResult.ignored;
        }

        node.focusInDirection(TraversalDirection.down);
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (widget.ignoreVerticalMovement) {
          return KeyEventResult.ignored;
        }

        node.focusInDirection(TraversalDirection.up);
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        if (widget.ignoreHorizontalMovement) {
          return KeyEventResult.ignored;
        }

        node.focusInDirection(TraversalDirection.left);
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        if (widget.ignoreHorizontalMovement) {
          return KeyEventResult.ignored;
        }

        node.focusInDirection(TraversalDirection.right);
        return KeyEventResult.handled;
      } else if ((event.logicalKey == LogicalKeyboardKey.enter) ||
          (event.logicalKey == LogicalKeyboardKey.select)) {
        return _handleEnterTapAction();
      }
    }

    return KeyEventResult.ignored;
  }

  KeyEventResult _handleEnterTapAction() {
    if (widget.onTap == null) {
      return KeyEventResult.ignored;
    }

    if (widget.onTap != null) {
      widget.onTap!();
    }

    return KeyEventResult.handled;
  }

  void _handleOnFocusChange(bool focusGained) {
    if (focusGained) {
      if (_gestureDetectorRequestedFocus) {
        _gestureDetectorRequestedFocus = false;
        _handleEnterTapAction();
      }
    }

    if (widget.focusChanged != null) {
      widget.focusChanged!(focusGained);
    }
  }

  void _onFocusChange(bool focusGained) {
    _handleOnFocusChange(focusGained);
  }

  KeyEventResult _onKey(FocusNode node, RawKeyEvent event) {
    return _handleOnKey(node, event);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: widget.autoFocus,
      focusNode: widget.focusNode,
      onFocusChange: _onFocusChange,
      onKey: _onKey,
      descendantsAreFocusable: widget.descendantsAreFocusable,
      child: Builder(
        builder: (BuildContext context) {
          final FocusNode focusNode = Focus.of(context);
          final hasFocus = focusNode.hasFocus;

          return GestureDetector(
            onTap: () {
              if (!hasFocus) {
                _gestureDetectorRequestedFocus = true;
                focusNode.requestFocus();
              } else {
                _handleEnterTapAction();
              }
            },
            child: widget.child,
          );
        },
      ),
    );
  }
}
