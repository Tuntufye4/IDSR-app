// test/widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:idsr/main.dart';  // Adjust this to your package name if needed
import 'package:flutter/material.dart';

void main() {
  testWidgets('App loads and displays title', (WidgetTester tester) async {
    // Build the app widget tree
    await tester.pumpWidget(const IdsrApp());

    // Trigger a frame      
    await tester.pumpAndSettle();    

    // Verify the app title appears in the app bar initially (Splash tab)
    expect(find.text('IDSR'), findsOneWidget);     

    // Tap on the 'Form' tab
    await tester.tap(find.byIcon(Icons.note_alt));
    await tester.pumpAndSettle();

    // Verify the Form page title appears
    expect(find.text('IDSR'), findsOneWidget);

    // Tap on the 'Charts' tab
    await tester.tap(find.byIcon(Icons.show_chart));
    await tester.pumpAndSettle();

    // Verify the Charts page title appears
    expect(find.text('IDSR'), findsOneWidget);

    // Tap on the 'Table' tab
    await tester.tap(find.byIcon(Icons.table_chart));
    await tester.pumpAndSettle();

    // Verify the Table page title appears
    expect(find.text('IDSR'), findsOneWidget);
  });
}
      