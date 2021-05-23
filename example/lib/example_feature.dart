import 'package:dart_board/dart_board.dart';
import 'package:dart_board_minesweeper/minesweeper_feature.dart';
import 'package:dart_board_theme/theme_feature.dart';
import 'package:dart_board_debug/debug_feature.dart';
import 'package:dart_board_log/log_feature.dart';
import 'impl/decorations/color_border_decoration.dart';
import 'impl/decorations/wavy_lines_background.dart';
import 'impl/pages/home_page.dart';
import 'impl/pages/main_page.dart';

import 'impl/pages/haiku_and_code.dart';
import 'impl/routes/custom_routes.dart';
import 'impl/state/nav_state.dart';

/// The Example Feature
///
/// A feature is a set of capabilities you would like to add to an app.
/// For this example, we re going to provide a few things.
///
/// 1) Routes
/// 2) Page Decorations and Config
/// 3) Feature Dependencies
class ExampleFeature extends DartBoardFeature {
  /// These are the Routes were are going to Provide.
  ///
  /// We can use the NamedRouteDefinition() to provide
  /// simple named routes
  ///
  /// We can also apply custom route builders, e.g. the Spin
  /// applied to the /home route
  @override
  List<RouteDefinition> get routes => <RouteDefinition>[
        NamedRouteDefinition(
            routeBuilder: kSpinRoute,
            route: '/home',
            builder: (ctx, settings) => HomePage()),
        NamedRouteDefinition(
            routeBuilder: kSpinRoute,
            route: '/main',
            builder: (ctx, settings) => MainPage()),
        NamedRouteDefinition(
            route: '/about',
            builder: (ctx, settings) => HaikuAndCode(
                haiku: '''Need to integrate?
Dart board will do that for you
It will be simple''',
                url:
                    'https://raw.githubusercontent.com/ahammer/dart_board/master/example/lib/main.dart')),
        NamedRouteDefinition(
            route: '/decorations',
            builder: (ctx, settings) => HaikuAndCode(
                  haiku: '''Painting your project
At the app and page level
is quick and easy''',
                  url:
                      'https://raw.githubusercontent.com/ahammer/dart_board/master/example/lib/impl/decorations/scaffold_appbar_decoration.dart',
                )),
        NamedRouteDefinition(
            route: '/routing',
            builder: (ctx, settings) => HaikuAndCode(
                  haiku: '''Navigate your app
Features provide named pages
Custom transitions
''',
                  url:
                      'https://raw.githubusercontent.com/ahammer/dart_board/master/example/lib/main.dart',
                )),
        NamedRouteDefinition(
            route: '/features',
            builder: (ctx, settings) => HaikuAndCode(
                  haiku: '''Features are code bits
They hook into your apps quick
Composed, they are strong''',
                  url:
                      'https://raw.githubusercontent.com/ahammer/dart_board/master/example/lib/example_feature.dart',
                ))
      ];

  /// These are page-scoped decorations
  @override
  List<PageDecoration> get pageDecorations => <PageDecoration>[
        PageDecoration(
            name: 'color_border',
            decoration: (context, child) => DarkColorBorder(child: child)),

        /// The animated background effect
        PageDecoration(
            name: 'animated_background',
            decoration: (context, child) => AnimatedBackgroundDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  child: child,
                ))
      ];

  @override
  List<WidgetWithChildBuilder> get appDecorations => [
        (ctx, child) => ChangeNotifierProvider<NavState>(
            create: (ctx) => NavState(), child: child)
      ];

  @override
  List<DartBoardFeature> get dependencies =>
      [ThemeFeature(), DebugFeature(), LogFeature(), MinesweeperFeature()];

  @override
  List<String> get pageDecorationDenyList => [
        /// Since on Main, the background isn't visible, we block
        '/main:animated_background',
      ];

  @override
  List<String> get pageDecorationAllowList =>
      ['/main:color_border', '/main:log_frame'];

  @override
  String get namespace => 'example';
}
