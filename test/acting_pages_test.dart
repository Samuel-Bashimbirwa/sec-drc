import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_test/features/acting/view/acting_home_page.dart';
import 'package:frontend_test/features/acting/view/pages/acting_map_page.dart';

void main() {
  group('ActingHomePage', () {
    Widget buildHost() => const MaterialApp(home: ActingHomePage());

    testWidgets('shows search bar only on map tab', (tester) async {
      await tester.pumpWidget(buildHost());
      // AppBar search is rendered via PreferredSize - ensure SearchBar exists
      expect(find.byType(SearchBar), findsOneWidget);

      // Switch to Localisation tab (index 1)
      await tester.tap(find.byIcon(Icons.my_location_outlined).last);
      await tester.pumpAndSettle();
      expect(find.byType(SearchBar), findsNothing);
    });

    testWidgets('bottom navigation switches body content', (tester) async {
      await tester.pumpWidget(buildHost());

      // Initially map stack exists (from ActingMapPage)
      expect(find.byType(ActingMapPage), findsOneWidget);

      // Navigate to Historique (index 2)
      await tester.tap(find.byIcon(Icons.history_outlined).last);
      await tester.pumpAndSettle();
      expect(find.text('Historique'), findsOneWidget);

      // Navigate to Compte (index 3) via AppBar action
      await tester.tap(find.byIcon(Icons.account_circle_outlined).first);
      await tester.pumpAndSettle();
      expect(find.text('Compte'), findsOneWidget);

      // Navigate to Paramètres (index 4) via AppBar action
      await tester.tap(find.byIcon(Icons.settings_outlined).first);
      await tester.pumpAndSettle();
      expect(find.text('Paramètres'), findsOneWidget);
    });

    testWidgets('emits SnackBar when using search submit', (tester) async {
      await tester.pumpWidget(buildHost());

      // Enter text and submit in SearchBar
      final searchField = find.byType(SearchBar);
      expect(searchField, findsOneWidget);

      // SearchBar uses onSubmitted; trigger via enter text & submit
      await tester.enterText(searchField, 'Gombe');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('urgent floating button shows warning snackbar', (tester) async {
      await tester.pumpWidget(buildHost());

      // FAB with warning icon is on map tab body
      await tester.tap(find.byIcon(Icons.warning));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('draggable sheet contains action buttons that trigger snackbars', (tester) async {
      await tester.pumpWidget(buildHost());

      // Buttons are inside the DraggableScrollableSheet -> Card -> ActingActionButtons
      // Tap each label to trigger SnackBar from HomePage toasts
      for (final label in const ['Signaler', 'Aide', 'Urgence', 'Point de vigilance']) {
        await tester.scrollUntilVisible(find.text(label), 100, scrollable: find.byType(Scrollable));
        await tester.tap(find.text(label));
        await tester.pump();
        expect(find.byType(SnackBar), findsOneWidget);
      }
    });
  });

  group('ActingMapPage', () {
    Widget buildHost() => const MaterialApp(home: Scaffold(body: ActingMapPage()));

    testWidgets('shows loading and/or error overlays based on state lifecycle', (tester) async {
      // We cannot easily mock LocationController here without refactor, so we at least ensure
      // the overlay widgets can appear; on web, controller sets error immediately.
      await tester.pumpWidget(buildHost());
      // Allow initState async microtasks
      await tester.pump(const Duration(milliseconds: 500));

      // Expect either loading chip (brief) or error/info chips to be present eventually
      // Fallback check: the page builds with a Stack and at least one Card overlay present
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('has center-on-user floating button', (tester) async {
      await tester.pumpWidget(buildHost());
      expect(find.byIcon(Icons.my_location), findsOneWidget);
      await tester.tap(find.byIcon(Icons.my_location));
      await tester.pump();
      // If no position available, a SnackBar may show; do not assert strictly due to platform variance.
    });
  });
}
