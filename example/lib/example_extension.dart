import 'package:dart_board_interface/dart_board_extension.dart';
import 'package:example/impl/decorations/animated_background_decoration.dart';
import 'package:example/impl/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'impl/decorations/color_border_decoration.dart';
import 'impl/decorations/scaffold_appbar_decoration.dart';
import 'impl/pages/about.dart';

/// The Example Extension
class ExampleExtension implements DartBoardExtension {
  @override
  get routes => <RouteDefinition>[]..addMap({
      /// Initial Route
      "/": (ctx, settings) => HomePage(),

      /// About Route
      "/about": (ctx, settings) => AboutPage(),
    });

  /// These are page-scoped decorations
  @override
  get pageDecorations => <WidgetWithChildBuilder>[
        /// The AppBar and Nav Drawer
        (context, child) => ScaffoldWithDrawerDecoration(child: child),

        /// The border around the Body
        (context, child) => DarkColorBorder(child: child),

        /// The animated background effect
        (context, child) => AnimatedBackgroundDecoration(
              color: Theme.of(context).accentColor,
              child: child,
            )
      ];

  /// These are app-level decorations (not needed here)
  @override
  get appDecorations => [];
}
