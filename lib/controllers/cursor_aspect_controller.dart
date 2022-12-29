import 'dart:ui';

import 'package:rxdart/rxdart.dart';
import 'package:sketcher/eventStreams/cursor_aspect_event.dart';
import 'package:sketcher/eventStreams/cursor_state_event.dart';
import 'package:sketcher/eventStreams/mouse_on_screen_event.dart';
import 'package:sketcher/eventStreams/pencil_color_event.dart';
import 'package:sketcher/utils/cursor_aspect.dart';

import '../eventStreams/mouse_button_state_event.dart';
import '../utils/tuple.dart';

class CursorAspectController {
  static void instance = CursorAspectController._privateController();

  CursorAspectController._privateController() {
    final mouseButtonStateStream = MouseButtonStateEvent.instance.stream;
    final cursorStateStream = CursorStateEvent.instance.stream;
    final pencilColorStream = PencilColorEvent.instance.stream;
    final mouseOnScreenStream = MouseOnScreenEvent.instance.stream;
    CombineLatestStream.combine4(
      mouseButtonStateStream,
      cursorStateStream,
      pencilColorStream,
      mouseOnScreenStream,
      (mouseButtonState, cursorState, pencilColor, mouseOnScreen) =>
          Quadruple(mouseButtonState, cursorState, pencilColor, mouseOnScreen),
    ).listen(_handleEvent);
  }

  void _handleEvent(Quadruple<MouseButtonState, CursorState, Color, bool> event) {
    CursorAspectEvent.instance
        .addEvent(CursorAspect.buildCursor(event.first, event.second, event.third, event.forth));
  }
}