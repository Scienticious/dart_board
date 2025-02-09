import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_minesweeper/dart_board_minesweeper.dart';
import 'package:dart_board_template_app_bar_sidenav/dart_board_template_app_bar_sidenav.dart';
import 'package:dart_board_theme/dart_board_theme.dart';
import 'package:dart_board_debug/debug_feature.dart';
import 'package:dart_board_log/dart_board_log.dart';
import 'package:example/impl/pages/code_overview.dart';
import 'data/constants.dart';
import 'impl/decorations/color_border_decoration.dart';
import 'impl/decorations/wavy_lines_background.dart';
import 'impl/pages/home_page.dart';
import 'package:dart_board_template_bottomnav/dart_board_template_bottomnav.dart';
import 'package:dart_board_image_background/dart_board_image_background.dart';
import 'impl/pages/haiku_and_code.dart';

/// The Example Feature
///
/// A feature is a set of capabilities you would like to add to an app.
/// For this example, we re going to provide a few things.
///
/// 1) Routes
/// 2) Page Decorations and Config
/// 3) Feature Dependencies
class ExampleFeature extends DartBoardFeature {
  /// A namespace for the feature.
  /// Should be unique to the feature.
  ///
  /// Can conflict, if the expectation is AB test with another feature
  /// Only 1 will load.
  @override
  String get namespace => 'example';

  /// These are the features the Example Uses
  ///
  /// If you remember, our main.dart only brought ExampleExtension
  /// This extension is an "integration" extension,
  /// it's goal is to glue everything else together.
  ///
  ///
  @override
  List<DartBoardFeature> get dependencies => [
        ThemeFeature(),
        DebugFeature(),
        LogFeature(),
        MinesweeperFeature(),

        /// Add 2 template's
        /// can toggle in debug
        BottomNavTemplateFeature(
            route: '/main', config: kMainPageConfig, namespace: 'template'),
        AppBarSideNavTemplateFeature(
            route: '/main',
            config: kMainPageConfig,
            title: 'Example App',
            namespace: 'template'),

        /// Register 3 Backgrounds
        /// can toggle in debug
        ImageBackgroundFeature(
            filename: 'assets/sunset_painting.jpg',
            namespace: 'background',
            implementationName: 'City Image'),
        AnimatedBackgroundFeature(),
        ImageBackgroundFeature(
            filename: 'assets/mush.jpg',
            namespace: 'background',
            implementationName: 'Mushroom Image'),

        /// Isolate the frame into a feature so it can be disabled
        FrameFeature(),
      ];

  /// Navigation entry points
  ///
  /// Use the NamedRouteDefinition() to define some simple named routes
  /// other RouteDefinitions may come soon (e.g. UrlRouteDefinition)
  @override
  List<RouteDefinition> get routes => <RouteDefinition>[
        /// /home route
        NamedRouteDefinition(
            route: '/home', builder: (ctx, settings) => HomePage()),

        /// /code route
        NamedRouteDefinition(
            route: '/code', builder: (ctx, settings) => CodeOverview()),

        /// Additional routes from the Constants files
        /// Each one is dedicated to a specific code file
        /// Files are just raw/master references to the github repo
        ///
        /// Visible on the /code route
        ...kCodeRoutes.map((e) => NamedRouteDefinition(
            route: e['route']!,
            builder: (ctx, setting) =>
                HaikuAndCode(haiku: e['haiku']!, url: e['url']!))),
      ];

  @override
  List<String> get pageDecorationDenyList => ['/main:animated_background'];

  @override
  List<String> get pageDecorationAllowList =>
      ['/main:color_border', '/main:log_frame'];
}

class AnimatedBackgroundFeature extends DartBoardFeature {
  @override
  String get namespace => 'background';

  @override
  String get implementationName => 'Relaxing Waves';

  @override
  List<DartBoardDecoration> get pageDecorations => <DartBoardDecoration>[
        DartBoardDecoration(
            name: 'background',
            decoration: (context, child) => AnimatedBackgroundDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  child: child,
                ))
      ];
}

/// Isolate the Frame/Border into it's own feature so it can be disabled
class FrameFeature extends DartBoardFeature {
  @override
  String get namespace => 'app_border';

  /// Some examples of Page Decorations
  /// These are widgets that get applied to the top of every page
  @override
  List<DartBoardDecoration> get pageDecorations => <DartBoardDecoration>[
        /// A simple Color Border applied to a Page Route
        DartBoardDecoration(
            name: 'color_border',
            decoration: (context, child) => DarkColorBorder(child: child)),
      ];
}
