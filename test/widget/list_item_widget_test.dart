import 'package:danamoo/generated/assets.dart';
import 'package:danamoo/src/home/view/widget/list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ListItemWidget displays the provided data', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ListItemWidget(
            label: 'Makan',
            nominal: 'Rp20.000',
            date: '27 Juni 2026',
            icon: Assets.assetsIconsFood,
          ),
        ),
      ),
    );

    expect(find.text('Makan'), findsOneWidget);
    expect(find.text('Rp20.000'), findsOneWidget);
    expect(find.text('27 Juni 2026'), findsOneWidget);

    expect(find.byType(Image), findsOneWidget);
  });
}
